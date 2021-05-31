<template>
  <transition name="modal" appear>
    <div class="modal modal-overlay" @click.self="$emit('close')">
      <div class="modal-window">
        <div class="modal-content">
          <h3 class="attack-group-select__header-title">チームを選びましょう</h3>
        </div>
      </div>
    </div>
  </transition>
</template>
<script>
</script>
<style scoped lang="scss">
.modal {
  &-content {
    display: flex;
    flex-direction: column;
    padding: 28px 32px;
  }
}

.attack-group-select__header-title{
  font-size: 14px;
  text-align: center;
  margin-bottom: 12px;
}
</style>