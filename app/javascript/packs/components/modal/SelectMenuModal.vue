<template>
  <transition name="modal" appear>
    <div class="modal modal-overlay" @click.self="$emit('close')">
      <div class="modal-window">
        <div class="modal-content">
          <h3 class="attack-select-header">アタック方法を選びましょう</h3>
          <div class="attack-select-btn-wrapper" style="margin-bottom:32px;">
            <span class="attack-select-title">新しいチームを作る</span>
            <button class="attack-select-btn hover-opacity">
              <a href="/attack_groups/new" class="attack-select-link">新規チーム作成</a>
            </button>
          </div>
          <div class="attack-select-btn-wrapper">
            <span class="attack-select-title">作成済のチームでアタックする</span>
            <button class="attack-select-btn hover-opacity">
              アタックチームを選択する
            </button>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>
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

.attack-select-header{
  font-size: 14px;
  text-align: center;
  margin-bottom: 12px;
}

.attack-select-btn-wrapper{
  display: flex;
  flex-direction: column;
  align-items: center;
}

.attack-select-title{
  font-size: 12px;
  color: #a09f9e;
  margin-bottom: 8px;
}

.attack-select-btn{
  width: 260px;
  background: #fff;
  border: 1px solid #f582ae;
  color: #f582ae;
  border-radius: 8px;
  padding: 8px 12px;
  font-weight: 700;
  cursor: pointer;
}

.attack-select-link{
  display: inline-block;
  width: 100%;
}
</style>