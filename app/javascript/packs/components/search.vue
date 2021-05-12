<template>
  <div>
    <div class="header-search-wrapper">
      <img :src="searchImage" class="search-img" @click="openSearchModal">
    </div>

    <div class="search-modal" v-show="showSearchModal">
      <div class="search-modal-container">
        <input type="text">
      </div>
    </div>
  </div>
</template>
<script>
import axios from 'packs/axios'
import searchImage from 'packs/assets/images/search.png'

export default {
  data() {
    return {
      searchImage,
      showSearchModal: false,
    }
  },
  methods: {
    openSearchModal: function(){
      this.showSearchModal = true;
    }
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
}
</style>
