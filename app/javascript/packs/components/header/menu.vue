<template>
  <div ref="elRoot">
    <div class="header-menu-wrapper">
      <div @click="showMenuList = !showMenuList" class="header-menu-btn hover-opacity">
        <span>メニュー</span>
      </div>

      <div v-if="showMenuList" class="header-menu-modal">
        <div class="header-menu-modal__row">
          <a href="/posts/new" class="header-menu-modal__item">
            <i class="far fa-calendar-plus"></i>
            <span class="header-menu-modal__item-title">募集作成</span>
          </a>
          <a href="/post_members/new" class="header-menu-modal__item">
            <i class="far fa-envelope"></i>
            <span class="header-menu-modal__item-title">募集へ招待</span>
          </a>
        </div>
        <div class="header-menu-modal__row">
          <a href="/attack_groups/new" class="header-menu-modal__item">
            <i class="fas fa-user-plus"></i>
            <span class="header-menu-modal__item-title">アタックチーム作成</span>
          </a>
          <a href="/attack_groups" class="header-menu-modal__item">
            <i class="fas fa-users"></i>
            <span class="header-menu-modal__item-title">チーム一覧</span>
          </a>
        </div>
        <div @click="showMenuList = false" class="header-menu-modal__row close-btn-wrapper">
          <span>閉じる</span>
        </div>
      </div>
    </div>  
  </div>
</template>

<script>
export default {
  data() {
    return {
      showMenuList: false,
    }
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
  cursor: pointer;
}
.header-menu-btn{
  display: flex;
  align-items: center;
  justify-content: center;
  width: 82px;
  height: 34px;
  font-weight: 700;
  color: #fff;
  background: #8bd3dd;
  border: 1px solid #8bd3dd;
  border-radius: 4px;
  font-size: 14px;
  margin-right: 12px;
}

.header-menu-modal{
  position: absolute;
  right: 12px;
  top: 40px;
  width: 260px;
  padding: 0px 12px;
  background-color: #fff;
  box-shadow: 1px 1px 6px rgba(0, 0, 0, 0.25);
  z-index: 997;
  display: flex;
  flex-direction: column;
}

.header-menu-modal__row{
  display: flex;
  align-items: center;
  justify-content: space-evenly;
}

.header-menu-modal__item{
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 50%;
  padding: 20px 0;
  .fas, .far{
    font-size: 28px;
    margin-bottom: 6px;
  }
  &:hover{
    background-color: #f7fafc;
  }
}

.header-menu-modal__item-title{
  font-size: 12px;
}

.close-btn-wrapper{
  padding: 16px 0px;
  cursor: pointer;
  font-size: 12px;
  &:hover{
    background-color: #f7fafc;
  }
}
</style>