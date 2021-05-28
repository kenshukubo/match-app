<template>
  <div style="position: relative;">
    <button
      @click="showFriendsList"
      class="attack_groups__option-btn add-attacker-btn hover-opacity"
    >
      メンバー追加
    </button>

    <div class="friend-list">
      <p class="friend-list__title">メンバー選択</p>
      <div class="friend-list__items-wrapper">
        <template v-for="(friend, index) in friends">
          <div :key="`friend-${index}`" class="friend-info">
            <img :src="friend.image" class="friend-img">
            <span class="friend-name text-ellipsis">{{friend.name}}</span>
          </div>
        </template>
      </div>
    </div>
  </div>
</template>
<script>
import axios from 'packs/axios'

export default {
  data() {
    return {
      attackGroupId: "",
      friends: "",
    }
  },
  created() {
    let addAttackerElement = document.getElementById("add-attacker");
    let data = JSON.parse(addAttackerElement.getAttribute('data'));
    this.attackGroupId = data.attackGroupId
  },
  methods: {
    async showFriendsList(){
      var self = this;
      try {
        const res = await axios.get("/api/v1/add_attackers", {
          params: {attack_group_id: self.attackGroupId}
        })
        self.friends = res.data.friends
      } catch(e) {
        console.log(e)
      }
    }
  }
}
</script>
<style scoped lang="scss">
.add-attacker-btn{
  min-width: 100px;
  background: none;
  border-radius: 8px;
  border-width: 1px;
  font-weight: 700;
  margin-right:8px;
  cursor: pointer;
}

.friend-list{
  position: absolute;
  right: 0px;
  min-width: 300px;
  padding: 8px 0;
  background-color: #fff;
  box-shadow: 0 .5rem 1rem rgba(0,0,0,.15);
}
.friend-list__title{
  font-weight: 700;
  border-bottom: 1px solid #e6e6e6;
  text-align: center;
  padding: 4px 0 12px;
}
.friend-list__items-wrapper{
  max-height: 200px;
  overflow: scroll;
}
.friend-info{
  display: flex;
  align-items: center;
  padding: 12px;
}
.friend-img{
  width: 42px;
  height: 42px;
  object-fit: cover;
  margin-right: 8px;
}
.friend-name{
  max-width: 220px;
}
</style>