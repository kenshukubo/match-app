<template>
  <div>
    <div class="header-search-wrapper">
      <img :src="searchImage" class="search-img" @click="openSearchModal">
    </div>

    <div class="search-modal" v-show="showSearchModal">
      <div class="search-modal-container">
        <div class="search-area-header">
          <div class="search-area-wrapper">
            <input type="text" placeholder="メールアドレスや名前で検索" class="search-area">
            <img :src="searchImage" class="search-img modal-search-img">
          </div>
          <img :src="closeImage" class="close-img" @click="closeSearchModal">
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
    }
  },
  methods: {
    openSearchModal: function(){
      this.showSearchModal = true;
    },
    closeSearchModal: function(){
      this.showSearchModal = false;
    },
  }
}
</script>
<style scoped>
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
</style>
