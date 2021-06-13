<template>
  <transition name="modal" appear>
    <div class="modal modal-overlay" @click.self="$emit('close')">
      <div class="modal-window">
        <div class="modal-content">
          <h3 class="attack-select-header">アタック方法を選びましょう</h3>
          <div class="attack-select-btn-wrapper" style="margin-bottom:32px;">
            <span class="attack-select-title">新しいチームを作る</span>
            <button class="select-btn team-create-btn hover-opacity">
              <a href="/attack_groups/new" class="attack-select-link">新規チーム作成</a>
            </button>
          </div>
          <div class="attack-select-btn-wrapper">
            <span class="attack-select-title">作成済のチームでアタックする</span>
            <button
              v-bind:class="{ activeModalBtn: hasAnyAttackGropups }"
              v-bind:disabled="!hasAnyAttackGropups"
              @click="showFriendList"
              class="select-btn modal-select-disabled-btn"
            >
              アタックチームを選択する
            </button>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>
<script>
export default {
  props: ['hasAnyAttackGropups'],
  methods: {
    showFriendList() {
      this.$emit('show-friend-list-modal', true);
      this.$emit('hide-menu-modal', false);
    },
  }
}
</script>
<style scoped lang="scss">
.modal {
  &-content {
    display: flex;
    flex-direction: column;
    padding: 16px 32px;
    width: 300px;
  }
}

// オーバーレイのトランジション
.modal-enter-active {
  transition: opacity 0.4s;

  // オーバーレイに包含されているモーダルウィンドウのトランジション
  .modal-window {
    transition: opacity 0.4s, transform 0.4s;
  }
}

.modal-enter {
  opacity: 0;

  .modal-window {
    opacity: 0;
    transform: translateY(-20px);
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

.attack-select-link{
  display: inline-block;
  width: 100%;
}
</style>