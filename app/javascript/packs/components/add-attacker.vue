<template>
  <div style="position: relative;">
    <button
      @click="showFriendsList"
      class="attack_groups__option-btn add-attacker-btn hover-opacity"
    >
      メンバー追加
    </button>

    <div v-if="showList" class="friend-list">
      <p class="friend-list__title">メンバー選択</p>
      <div v-if="!!friends" class="friend-list__items-wrapper">
        <template v-for="(friend, index) in friends">
          <div @click="addAttacker(friend.id)" :key="`friend-${index}`" class="friend-info">
            <img :src="friend.image" class="friend-img">
            <span class="friend-name text-ellipsis">{{friend.name}}</span>
          </div>
        </template>
        <p v-if="friends.length==0" class="no-friend-title">招待可能なフレンドがいません</p>
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
      showList: false,
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
        self.showList = true
      } catch(e) {
        console.log(e)
      }
    },
    async addAttacker(userId){
      try {
        return await axios.post("/api/v1/add_attackers", {
          user_id: userId
        })
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
  right: -24px;
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
  cursor: pointer;
  &:hover{
    background-color: #f7fafc;
  }
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

.no-friend-title{
  padding: 12px;
  text-align: center;
}
</style>