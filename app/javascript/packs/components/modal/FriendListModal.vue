<template>
  <transition name="modal" appear>
    <div class="modal modal-overlay" @click.self="$emit('close')">
      <div class="modal-window">
        <div class="modal-content">
          <h3 class="">チームを選びましょう</h3>
        </div>
      </div>
    </div>
  </transition>
</template>
<script>
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
    border-radius: 8px;
    overflow: hidden;
  }
  &-content {
    display: flex;
    flex-direction: column;
    padding: 28px 32px;
  }

}
</style>