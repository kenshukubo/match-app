<template>
  <transition name="modal" appear>
    <div class="modal modal-overlay" @click.self="$emit('close')">
      <div class="modal-window">
        <div class="modal-content">
          <h3 class="attack-select-header">アタック方法を選びましょう</h3>
          <div class="attack-select-btn-wrapper" style="margin-bottom:32px;">
            <span class="attack-select-title">新しいチームを作る</span>
            <button class="modal-select-btn team-create-btn hover-opacity">
              <a href="/attack_groups/new" class="attack-select-link">新規チーム作成</a>
            </button>
          </div>
          <div class="attack-select-btn-wrapper">
            <span class="attack-select-title">作成済のチームでアタックする</span>
            <button
              v-bind:class="{ activeModalBtn: hasAnyAttackGropups }"
              v-bind:disabled="!hasAnyAttackGropups"
              @click="showFriendList"
              class="modal-select-btn modal-select-disabled-btn"
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

.team-create-btn{
  border: 1px solid #f582ae;
  color: #f582ae;
  cursor: pointer;
}

.attack-select-link{
  display: inline-block;
  width: 100%;
}
</style>