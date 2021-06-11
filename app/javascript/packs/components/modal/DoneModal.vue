<template>
  <transition name="modal" appear>
    <div class="modal modal-overlay" @click.self="$emit('close')">
      <div class="modal-window">
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