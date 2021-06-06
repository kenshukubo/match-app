<template>
  <div class="select-member__invite-form-wrapper">
    <div class="select-member__form form">
      <input v-model="keyword" placeholder="ユーザー名で検索" type="text">
      <img :src="searchImage" @click="searchKeyword" class="search-img hover-opacity">
    </div>

    <span class="select-member__list-title">フレンドから選ぶ</span>

    <div v-if="!anyFriends" v-cloak>
      <p class="select-member__exception-title">
        <span>(同性の)フレンドがいません</span>
        <span>
          ヘッダーの
          <img :src="addFriendImage" class="select-member__exception-search-img">
          からフレンド追加できます
        </span>
      </p>
    </div>
    <div v-else>
      <div v-if="!listedFriends">
        <p class="select-member__exception-title">
          <span>全フレンド選択済みです</span>
        </p>
      </div>
      <div v-else v-cloak>
        <div class="select-member__list-wrapper">
          <clip-loader :loading="isLoading" :color="color"></clip-loader>
          <template v-for="(friend, index) in listedFriends">
            <div class="select-member__list-item" :key="`friend-${index}`">
              <img :src="friend.image" class="select-member__list-item-img">
              <span class="select-member__list-item-name text-ellipsis">{{friend.name}}</span>
            </div>
          </template>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'packs/axios'
import addFriendImage from 'packs/assets/images/add-friend.png'
import searchImage from 'packs/assets/images/search.png'
import ClipLoader from 'vue-spinner/src/ClipLoader'

export default {
  components: {
    ClipLoader
  },
  data() {
    return {
      addFriendImage,
      searchImage,
      keyword: "",
      listedType: "",
      anyFriends: false,
      listedFriends: "",
      isLoading: false,
      color: "#8bd3dd",
    }
  },
  created() {
    let selectMemberElement = document.getElementById("select-member");
    let data = JSON.parse(selectMemberElement.getAttribute('data'));
    this.listedType = data.listedType
    this.fetchfriends();
  },
  methods: {
    async fetchfriends(){
      var self = this;
      self.isLoading = true;
      try {
        const res = await axios.get("/api/v1/check_friends")
        self.anyFriends = res.data.anyFriends;
        self.listedFriends = res.data.listedFriends;
        self.isLoading = false;
      } catch(e) {
        console.log(e)
      }
    },
    async searchKeyword(){

    }
  }
}
</script>
<style scoped lang="scss">
.search-img{
  width: 18px;
  height: 18px;
  padding: 8px;
  position: absolute;
  right: 12px;
  cursor: pointer;
}

.select-member__invite-form-wrapper{
  padding: 32px 0;
}
.select-member__form{
  display: flex;
  align-items: center;
  margin-bottom: 32px;
  position: relative;
}

.select-member__exception-title{
  text-align: center;
  padding: 28px 0px;
  font-size: 14px;
  display: flex;
  flex-direction: column;
}

.select-member__exception-search-img{
  width: 20px;
  height: 20px;
}

.select-member__list-title{
  font-size: 14px;
  font-weight: 700;
}

.select-member__list-wrapper{
  overflow-x: auto;
  white-space: nowrap;
  display: flex;
  padding: 4px 0;
}

.select-member__list-item{
  border: 1px solid #001858;
  border-radius: 8px;
  padding: 4px;
  min-width: 140px;
  box-sizing: border-box;
  display: flex;
  align-items: center;
  margin-right: 12px;
}

.select-member__list-item-img{
  width: 42px;
  height: 42px;
  border-radius: 50%;
  object-fit: cover;
  margin-right: 8px;
}

.select-member__list-item-name{
  font-size: 12px;
  font-weight: 700;
}

[v-cloak] {
  display: none;
}

</style>