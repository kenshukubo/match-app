<template>
  <transition name="modal" appear>
    <div class="modal modal-overlay" @click.self="$emit('close')">
      <div class="modal-window">
        <img :src="congratsImage">
        <div class="modal-content">
        </div>
      </div>
    </div>
  </transition>
</template>
<script>
import congratsImage from 'packs/assets/images/congrats.png'
export default {
  data() {
    return{
      congratsImage
    }
  }
}
</script>

<style scoped lang="scss">
.modal {
  &.modal-overlay {
    display: flex;
    align-items: center;
    justify-content: center;
    position: fixed;
    z-index: 30;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
  }
  &-window {
    background: #fff;
    border-radius: 4px;
    overflow: hidden;
  }
  &-content {
    padding: 10px 20px;
  }

}
</style>