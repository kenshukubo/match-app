<template>
  <div>
    <div class="header-menu-wrapper">
      <div @click="showMenuList = !showMenuList" class="header-btn-wrapper hover-opacity">
        <i class="fas fa-th-large"></i>
        <span class="header-btn-title">メニュー</span>
      </div>

      <div v-if="showMenuList" class="header-menu-modal" ref="elRoot">
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
  methods: {

  }
}
</script>

<style lang="scss" scoped>
.header-menu-wrapper{
  position: relative;
}
.fa-th-large{
  margin-top: 8px;
  font-size: 20px;
}

.header-menu-modal{
  position: absolute;
  right: -54px;
  top: 47px;
  width: 300px;
  padding: 0px 12px;
  background-color: #fff;
  box-shadow: 1px 1px 6px rgba(0, 0, 0, 0.25);
  z-index: 997;
  display: flex;
  flex-direction: column;
  border-radius: 8px;
  @media(max-width: 567px){
    width: 260px;
    right: -120px;
  }
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