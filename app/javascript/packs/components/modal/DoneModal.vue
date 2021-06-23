<template>
  <transition name="modal" appear>
    <div class="modal modal-overlay" @click.self="$emit('close')">
      <div class="modal-window">
        <div class="modal-close-btn-wrapper">
          <i @click="$emit('close')" class="far fa-times-circle hover-opacity"></i>
        </div>
        <slot name="image" class="post-listed__popper-img"></slot>
        <div class="modal-content">
          <div class="post-listed__popper-title-wrapper">
            <slot name="title"></slot>
            <slot name="text"></slot>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>
<script>
import popperImage from 'packs/assets/images/popper.png'
export default {
  data() {
    return{
      popperImage
    }
  }
}
</script>

<style scoped lang="scss">
.modal {
  &-window {
    display: flex;
    align-items: center;
    flex-direction: column;
    width: 420px;
    @media(max-width: 576px){
      width: 300px;
    }
  }
  &-content {
    width: 100%;
    padding: 10px 20px;
  }
}

.modal-close-btn-wrapper{
  display: flex;
  justify-content: flex-end;
  width: 100%;
  padding: 8px 12px;
  box-sizing: border-box;
  .fa-times-circle{
    font-size: 32px;
    cursor: pointer;
  }
}

.post-listed__popper-img{
  width: 260px;
}

.post-listed__popper-title-wrapper{
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 10px 20px;
}

.post-listed__popper-title{
  font-weight: 700;
  font-size: 20px;
}
</style>