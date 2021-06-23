<template>
  <div>
    <div class="select-member__invite-form-wrapper">
      <div class="select-member__form-area form">
        <span class="select-member__list-title">招待するユーザーを探す</span>
        <div class="select-member__form-wrapper">
          <input v-bind="keyword" ref="input" type="text" v-on:keyup.enter="searchKeyword" placeholder="ユーザー名で検索">
          <i class="fas fa-search hover-opacity" @click="searchKeyword"></i>
        </div>

        <div class="select-member__list-wrapper">
          <clip-loader :loading="isSearching" :color="color"></clip-loader>
          <template v-for="(user, index) in searchedUsers">
            <div
              @click="selectUser(user.id)"
              v-bind:class="{ selectedUser: selectedUserIds.includes(user.id) }"
              class="select-member__list-item"
              :key="`friend-${index}`"
            >
              <img :src="user.image" class="select-member__list-item-img">
              <span class="select-member__list-item-name text-ellipsis">{{user.name}}</span>
              <div v-bind:class="{ checkRound: selectedUserIds.includes(user.id) }" class="check-position">
                <span v-bind:class="{ checkMark: selectedUserIds.includes(user.id) }"></span>
              </div>
            </div>
          </template>
        </div>
      </div>

      <div style="margin-bottom:1rem;">
        <span class="select-member__list-title">フレンドから選ぶ</span>

        <div v-if="!anyFriends && !isLoading">
          <p class="select-member__exception-title">
            <span>(同性の)フレンドがいません</span>
            <span>
              ヘッダーの
              <img :src="addFriendImage" class="select-member__exception-search-img">
              からフレンド追加できます
            </span>
          </p>
        </div>
        <div v-else>
          <div v-if="listedFriends.length == 0 && !isLoading">
            <p class="select-member__exception-title">
              <span>全フレンド選択済みです</span>
            </p>
          </div>
          <div v-else>
            <div class="select-member__list-wrapper">
              <clip-loader :loading="isLoading" :color="color"></clip-loader>
              <template v-for="(friend, index) in listedFriends">
                <div
                  @click="selectUser(friend.id)"
                  v-bind:class="{ selectedUser: selectedUserIds.includes(friend.id) }"
                  class="select-member__list-item"
                  :key="`friend-${index}`"
                >
                  <img :src="friend.image" class="select-member__list-item-img">
                  <span class="select-member__list-item-name text-ellipsis">{{friend.name}}</span>
                  <div v-bind:class="{ checkRound: selectedUserIds.includes(friend.id) }" class="check-position">
                    <span v-bind:class="{ checkMark: selectedUserIds.includes(friend.id) }"></span>
                  </div>
                </div>
              </template>
            </div>
          </div>
        </div>
      </div>

      <div class="button-wrapper">
        <button
          @click="confirmMember"
          class="app-button conversion"
          style="min-width: 180px;"
        >
          <span v-if="listedType == 'post_member'">招待確定する</span>
          <span v-else-if="listedType == 'attack_group'">チーム作成する</span>
        </button>
      </div>
    </div>

    <DoneModal v-if="showModal" @close="showModal = false">
      <img :src="megaphoneImage" slot="image" class="post-listed__popper-img">
      <span slot="title" class="post-listed__popper-title">招待完了しました</span>
      <span slot="text" class="post-listed__popper-text">招待の承認を待ちましょう</span>
    </DoneModal>
  </div>
</template>

<script>
import axios from 'packs/axios'
import addFriendImage from 'packs/assets/images/add-friend.png'
import megaphoneImage from 'packs/assets/images/megaphone.png'
import ClipLoader from 'vue-spinner/src/ClipLoader'
import DoneModal from './modal/DoneModal.vue'

export default {
  components: {
    ClipLoader,
    DoneModal
  },
  data() {
    return {
      addFriendImage,
      megaphoneImage,
      keyword: "",
      listedType: "",
      invitableNumber: "",
      anyFriends: false,
      listedFriends: "",
      searchedUsers: "",
      selectedUserIds: [],
      isLoading: false,
      isSearching: false,
      color: "#8bd3dd",
      showModal: false,
    }
  },
  created() {
    let selectMemberElement = document.getElementById("select-member");
    let data = JSON.parse(selectMemberElement.getAttribute('data'));
    this.listedType = data.listedType
    this.invitableNumber = data.invitableNumber
    this.fetchfriends();
  },
  methods: {
    async fetchfriends(){
      var self = this;
      self.isLoading = true;
      try {
        const res = await axios.get("/api/v1/check_friends")
        self.anyFriends = res.data.anyFriends;
        self.listedFriends = res.data.listedFriends;
        self.isLoading = false;
      } catch(e) {
        console.log(e)
      }
    },
    async searchKeyword(){
      var self = this;
      self.isSearching = true;
      try {
        const res = await axios.get("/api/v1/search_users", {
          params:{
            keyword: self.keyword,
            type: self.listedType
          },
        })
        self.searchedUsers = res.data.searchedUsers;
        self.isSearching = false;
      } catch(e) {
        console.log(e)
      }
    },
    async selectUser(userId){
      var self = this
      
      if(self.selectedUserIds.includes(userId)){
        self.selectedUserIds = self.selectedUserIds.filter(n => n !== userId);
      }else{
        if(self.selectedUserIds.length >= self.invitableNumber) return;
        self.selectedUserIds.push(userId)
      }
    },
    async confirmMember(){
      var self = this
      if(self.selectedUserIds.length == 0) return;

      if(self.listedType == "post_member"){
        const res = await axios.post("/api/v1/add_post_members", {
          user_ids: self.selectedUserIds
        })
        .then( res => {
          self.showModal = true
        })
        .catch( error => {
          console.log(error)
        })
      }else if(self.listedType == "attack_group"){
        const res = await axios.post("/api/v1/attack_groups", {
          user_ids: self.selectedUserIds
        })
        .then( res => {
          self.showModal = true
        })
        .catch( error => {
          console.log(error)
        })
      }
    }
  }
}
</script>
<style scoped lang="scss">
.fa-search{
  font-size: 20px;
  padding: 8px;
  position: absolute;
  right: 12px;
  cursor: pointer;
}

.select-member__invite-form-wrapper{
  padding: 16px 0;
}
.select-member__form-area{
  display: flex;
  flex-direction: column;
  margin-bottom: 32px;
}

.select-member__form-wrapper{
  display: flex;
  align-items: center;
  position: relative;
  width: 100%;
}

.select-member__exception-title{
  text-align: center;
  padding: 28px 0px;
  font-size: 14px;
  display: flex;
  flex-direction: column;
}

.select-member__exception-search-img{
  width: 20px;
  height: 20px;
}

.select-member__list-title{
  font-size: 14px;
  font-weight: 700;
}

.select-member__list-wrapper{
  overflow-x: auto;
  white-space: nowrap;
  display: flex;
  padding: 4px;
  width: 100%;
}

.check-position{
  position: absolute;
  top: -0.2em;
  left: 6.7em;
}

.select-member__list-item{
  border: 1px solid #001858;
  border-radius: 5rem;
  padding: 4px;
  width: 120px;
  height: 44px;
  box-sizing: border-box;
  display: flex;
  align-items: center;
  margin-right: 8px;
  cursor: pointer;
  position: relative;
  &:hover{
    box-shadow: 0px 0px 0px 0.2rem rgba(0, 123, 255, 0.25);
    border: none
  }
}

.select-member__list-item-img{
  width: 36px;
  height: 36px;
  border-radius: 50%;
  object-fit: cover;
  margin-right: 8px;
}

.select-member__list-item-name{
  font-size: 12px;
  font-weight: 700;
}

.selectedUser{
  border: none;
  box-shadow: 0px 0px 0px 0.2rem rgba(0, 123, 255, 0.25);
}
</style>