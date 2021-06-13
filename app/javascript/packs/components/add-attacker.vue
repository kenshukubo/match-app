<template>
  <div style="position: relative;">
    <button
      @click="showFriendsList"
      class="attack_groups__option-btn add-attacker-btn hover-opacity"
    >
      <span>メンバー追加</span>
    </button>

    <div v-if="showList" class="friend-list">
      <p class="friend-list__title">
        <span>メンバー選択</span>
        <span @click="closeFriendList" class="close-friend-list">✖️</span>
      </p>
      <div v-if="!!friends" class="friend-list__items-wrapper">
        <template v-for="(friend, index) in friends">
          <div v-if="!isInvite" @click="addAttacker(friend.id)" :key="`friend-${index}`" class="friend-info">
            <img :src="friend.image" class="friend-img">
            <span class="friend-name text-ellipsis">{{friend.name}}</span>
          </div>
        </template>
        <p v-if="isInvite" class="result-title">招待完了しました</p>
        <p v-if="friends.length==0" class="result-title">招待可能なフレンドがいません</p>
      </div>

    </div>
  </div>
</template>
<script>
import axios from 'packs/axios'

export default {
  props: ['attackGroupId'],
  data() {
    return {
      friends: "",
      showList: false,
      isInvite: false
    }
  },
  created() {
  },
  methods: {
    async showFriendsList(){
      var self = this;
      self.isInvite = false
      const res = await axios.get("/api/v1/add_attackers", {
        params: {attack_group_id: self.attackGroupId}
      })
      .then( res => {
        self.friends = res.data.friends
        self.showList = true
      })
      .catch( error => {
        console.log(error)
      })
    },
    async addAttacker(userId){
      var self = this
      const res =  await axios.post("/api/v1/add_attackers", {
        user_id: userId,
        group_id: self.attackGroupId
      })
      .then( res => {
        self.isInvite = true;
      })
      .catch( error => {
        console.log(error)
      })
      
    },
    async closeFriendList(){
      this.showList = false
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
  top: 32px;
  min-width: 300px;
  padding: 8px 0;
  background-color: #fff;
  box-shadow: 0 .5rem 1rem rgba(0,0,0,.15);
}
.friend-list__title{
  display: flex;
  justify-content: space-between;
  font-weight: 700;
  border-bottom: 1px solid #e6e6e6;
  padding: 4px 12px 12px 12px;
}
.close-friend-list{
  cursor: pointer;
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
  border-radius: 50%;
  margin-right: 8px;
}
.friend-name{
  max-width: 220px;
}

.result-title{
  padding: 12px;
  text-align: center;
}
</style>