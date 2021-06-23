<template>
  <div ref="elRoot">
    <div class="header-menu-wrapper">
      <div @click="showMenuList = !showMenuList" class="header-btn-wrapper hover-opacity">
        <img :src="userIcon" class="header-menu__user-icon">
      </div>

      <div v-if="showMenuList" class="header-menu-modal">
        <ul class="header-menu__wrapper">
          <li class="header-menu__item">
            <a href="/user_profile/edit" class="header-menu__item-link header-menu__item-user-name">
              <span>{{userName}}</span>
              <span class="header-menu__profile-setting-text">プロフィールを編集</span>
            </a>
          </li>
          <li class="header-menu__item">
            <a href="/chat" class="header-menu__item-link">
              <span>チャット</span>
            </a>
          </li>
          <li class="header-menu__item">
            <a class="header-menu__item-link">
              <span>ログアウト</span>
            </a>
          </li>
        </ul>
      </div>
    </div>  
  </div>
</template>

<script>
export default {
  data() {
    return {
      showMenuList: false,
      userName: "",
      userIcon: ""
    }
  },
  created() {
    let userMenuElement = document.getElementById("user-menu");
    let data = JSON.parse(userMenuElement.getAttribute('data'));
    this.userName = data.username
    this.userIcon = data.user_image
  },
  mounted(){
    //枠外クリックで非表示する処理
    window.addEventListener('click', this._onBlurHandler = (event) => {
      if (this.$refs.elRoot.contains(event.target)) {
        return;
      }
      this.showMenuList = false;
    });
  },
}
</script>

<style lang="scss" scoped>
.header-menu-wrapper{
  position: relative;
}
.header-menu__user-icon{
  width: 36px;
  height: 36px;
  object-fit: cover;
  border-radius: 50%;
}

.header-menu-modal{
  position: absolute;
  right: 12px;
  top: 40px;
  width: 180px;
  padding: 8px 0px;
  background-color: #fff;
  box-shadow: 1px 1px 6px rgba(0, 0, 0, 0.25);
  z-index: 997;
  @media(max-width: 567px){
    width: 180px;
  }
}

.header-menu__wrapper{
  display: flex;
  flex-direction: column;
}

.header-menu__item{
  text-align: left;
  width: 100%;
  font-size: 12px;
  font-weight: 700;
  box-sizing: border-box;
  &:hover{
    background-color: #f7f9f9;
  }
}

.header-menu__item-link{
  display: block;
  padding: 10px 16px;
}

.header-menu__item-user-name{
  display: flex;
  flex-direction: column;
}

.header-menu__profile-setting-text{
  font-size: 12px;
  font-weight: 400;
  color: #6f7372;
}
</style>