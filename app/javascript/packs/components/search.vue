<template>
  <div>
    <div @click="openSearchModal" class="header-btn-wrapper hover-opacity">
      <img :src="addFriendImage" class="add-friend-img">
      <span class="header-btn-title">フレンド</span>
    </div>

    <div class="search-modal" v-show="showSearchModal">
      <div class="search-modal-container">
        <div class="search-area-header">
          <div class="search-area-wrapper">
            <input v-bind="keyword" ref="input" type="text" v-on:keyup.enter="searchKeyword" placeholder="ユーザー名でフレンド検索" class="search-area">
            <i class="fas fa-search hover-opacity" @click="searchKeyword"></i>
          </div>
          <i class="fas fa-times hover-opacity" @click="closeSearchModal"></i>
        </div>

        <div>
          <ul class="results-menu-wrapper">
            <li :class="selectedResults" @click="selectSearchType('')" class="results-menu">
              <span>結果</span>
            </li>
            <li :class="selectedFriends" @click="selectSearchType('friends')" class="results-menu">
              <span>フレンド</span>
            </li>
          </ul>
        </div>

        <div v-if="!!userList">
          <template v-for="(user, index) in userList">
            <div :key="`results-item-${index}`" class="results-item">
              <div class="results-item-img-wrapper">
                <img :src="user.image" class="results-item-img">
              </div>
              <div class="results-item-header">
                <span class="results-item-name text-ellipsis">{{user.name}}</span>
                <button v-if="user.isFriend" @click="removeFriend(user, index)" class="results-remove-btn results-btn">
                  フレンド解除
                </button>
                <button v-else @click="addFriend(user, index)" class="results-follow-btn results-btn">
                  フレンド追加
                </button>
              </div>
            </div>
          </template>
        </div>
        <div v-else class="default-result">
          <clip-loader :loading="isLoading" :color="color"></clip-loader>
          <span v-show='!isLoading'>ユーザー検索結果が表示されます</span>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import axios from 'packs/axios'
import addFriendImage from 'packs/assets/images/add-friend.png'
import ClipLoader from 'vue-spinner/src/ClipLoader'

export default {
  computed: {
    selectedResults(){
      return !!this.selectedMenu ? '':'is-active'
    },
    selectedFriends(){
      return !!this.selectedMenu ? 'is-active':''
    },
    userList(){
      if(this.selectedMenu == "friends"){
        return this.friends;
      }else{
        return this.users;
      }
    },
  },
  components: {
    ClipLoader
  },
  data() {
    return {
      addFriendImage,
      showSearchModal: false,
      keyword: "",
      users: "",
      friends: "",
      selectedMenu: "",
      isLoading: false,
      color: "#8bd3dd",
    }
  },
  methods: {
    async searchKeyword() {
      var self = this;
      self.isLoading = true;
      self.keyword = this.$refs.input.value;
      try {
        const res1 = await axios.get("/api/v1/searches", {
          params:{
            keyword: self.keyword
          },
        })
        self.users = res1.data.users;
        self.selectedMenu = "";

        const res2 = await axios.get("/api/v1/search_friends", {
          params:{
            keyword: self.keyword
          },
        })
        self.friends = res2.data.friends;
        self.isLoading = false;
      } catch(e) {
        console.log(e)
      }
    },
    async selectSearchType(menuType) {
      var self = this;
      self.selectedMenu = menuType;
    },
    async addFriend(user, i) {
      const res = await axios.post("/api/v1/friends", {
        user_id: user.id
      })
      this.users[i].isFriend = res.data.addedUser.isFriend;
      this.friends.push(res.data.addedUser)
    },
    async removeFriend(user, i) {
      var self = this;
      const res = await axios.delete("/api/v1/friends", {
        data: {user_id: user.id }
      })
      // TODO フレンド解除時ボタンが切り替わらない
      console.log(res.data.removedUser.isFriend)
      self.users[i].isFriend = res.data.removedUser.isFriend;
      console.log(this.users[i].isFriend)
      self.friends = self.friends.filter( e => e.id !== res.data.removedUser.id )
    },
    openSearchModal: function(){
      this.showSearchModal = true;
    },
    closeSearchModal: function(){
      this.showSearchModal = false;
    },
  }
}
</script>
<style scoped lang="scss">
.add-friend-img{
  width: 28px;
  height: 28px;
}

.search-modal{
  background-color: #fff;
  position: fixed;
  left: 0;
  top: 0;
  height: 100%;
  width: 100%;
  z-index: 1000;
  display: flex;
  justify-content: center;
}
.search-modal-container{
  max-width: 600px;
  width: 100%;
}

.search-area-header{
  display: flex;
  align-items: center;
  padding: 4px;
  margin-bottom: 16px;
}

.search-area-wrapper{
  position: relative;
  width: 100%;
  display: flex;
  align-items: center;
}

.search-area{
  width: 100%;
  min-height: 40px;
  padding: 4px 8px;
  font-size: 14px;
  padding-right: 40px!important;
  border-radius: 4px;
  border-width: 1px;
}

.fas{
  cursor: pointer;
}
.fa-search{
  font-size: 20px;
  padding: 8px;
  position: absolute;
  right: 12px;
}
.fa-times{
  font-size: 28px;
  padding: 8px;
}

.results-menu-wrapper{
  display: flex;
  border-bottom: 1px solid #e6e6e6;
}
.results-menu{
  width: 50%;
  padding: 4px 0 12px;
  font-weight: 700;
  font-size: 14px;
  text-align: center;
  cursor: pointer;
}

.is-active{
  border-bottom: 2px solid #000;
}

.results-item{
  display: flex;
  align-items: center;
  padding: 12px 16px;
  border-bottom: 1px solid rgb(235, 238, 240);
}

.results-item-img-wrapper{
  margin-right: 12px;
}
.results-item-img{
  width: 48px;
  height: 48px;
  object-fit: cover;
  border-radius: 9999px;
}

.results-item-header{
  display: flex;
  justify-content: space-between;
  width: 100%;
}

.results-btn{
  min-height: 32px;
  font-weight: 700;
  font-size: 15px;
  padding: 0 15px;
  border-radius: 9999px;
  cursor: pointer;
  &:hover{
    transition: .7;
  }
}

.results-follow-btn{
  border: 1px solid #8bd3dd;
  color: #8bd3dd;
  background: #fff;
  &:hover{
    background: rgba(139,211,221,.3);
  }
}

.results-remove-btn{
  border: 1px solid #f582ae;
  color: #f582ae;
  background: #fff;
  &:hover{
    background: rgba(245,130,174,.3);
  }
}

.default-result{
  text-align: center;
  padding: 36px 0px;
}
</style>
