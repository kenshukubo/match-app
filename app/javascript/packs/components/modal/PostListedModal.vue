<template>
  <transition name="modal" appear>
    <div class="modal modal-overlay" @click.self="$emit('close')">
      <div class="modal-window">
        <img :src="popperImage" class="post-listed__popper-img">
        <div class="modal-content">
          <div class="post-listed__popper-title-wrapper">
            <span class="post-listed__popper-title">募集が投稿されました</span>
            <span>アタックを待ちましょう</span>
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