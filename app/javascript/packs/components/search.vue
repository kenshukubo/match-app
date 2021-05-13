<template>
  <div>
    <div class="header-search-wrapper">
      <img :src="searchImage" class="search-img" @click="openSearchModal">
    </div>

    <div class="search-modal" v-show="showSearchModal">
      <div class="search-modal-container">
        <div class="search-area-header">
          <div class="search-area-wrapper">
            <input v-bind="keyword" ref="input" type="text" v-on:keyup.enter="searchKeyword" placeholder="メールアドレスや名前で検索" class="search-area">
            <img :src="searchImage" @click="searchKeyword" class="search-img modal-search-img">
          </div>
          <img :src="closeImage" class="close-img" @click="closeSearchModal">
        </div>

        <div v-if="!!users">
          <template v-for="(user, index) in users">
            <div :key="`results-item-${index}`" class="results-item">
              <div class="results-item-img-wrapper">
                <img :src="user.image" class="results-item-img">
              </div>
              <div class="results-item-header">
                <span class="results-item-name text-ellipsis">{{user.name}}</span>
                <button class="results-follow-btn">フレンド追加</button>
              </div>
            </div>
          </template>
        </div>
        <div v-else class="default-result">
          <span>検索結果が表示されます</span>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import axios from 'packs/axios'
import searchImage from 'packs/assets/images/search.png'
import closeImage from 'packs/assets/images/close.png'

export default {
  data() {
    return {
      searchImage,
      closeImage,
      showSearchModal: false,
      keyword: "",
      users: "",
    }
  },
  methods: {
    async searchKeyword() {
      var self = this;
      self.keyword = this.$refs.input.value;
      try {
        const res = await axios.get("/api/v1/search", {
          params:{
            keyword: self.keyword
          },
        })
        self.users = res.data.users;
      } catch(e) {
        console.log(e)
      }
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
.header-search-wrapper{
  position: relative;
  margin-right: 20px;
  display: flex;
  align-items: center;
}
.search-img{
  cursor: pointer;
  width: 20px;
  height: 20px;
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
}

.modal-search-img{
  padding: 8px;
  position: absolute;
  right: 12px;
}
.close-img{
  width: 20px;
  height: 20px;
  padding: 8px;
}

.results-item{
  display: flex;
  align-items: center;
  padding: 12px 16px;
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

.results-follow-btn{
  min-height: 32px;
  font-weight: 700;
  font-size: 15px;
  padding: 0 15px;
  border-radius: 9999px;
  border: 1px solid #8bd3dd;
  color: #8bd3dd;
  background: #fff;
  &:hover{
    background: rgba(139,211,221,.3);
    transition: .7;
  }
}

.default-result{
  text-align: center;
  padding: 36px 0px;
}
</style>
