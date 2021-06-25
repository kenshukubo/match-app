<template>
  <div>
    <div class="select-member__invite-form-wrapper">
      <div class="select-member__form-area">
        <span class="select-member__list-title">招待するユーザー</span>
        <div class="select-member__list-wrapper selected-users-list">
          <template v-for="(user, index) in selectedUsers">
            <div
              class="select-member__list-selected-item"
              :key="`user-${index}`"
            >
              <img :src="user.image" class="select-member__list-item-img">
              <span class="select-member__list-item-name text-ellipsis">{{user.name}}</span>
              <div class="check-position">
                <i class="fas fa-times hover-opacity" @click="removeSelectedUser(user.id)"></i>
              </div>
            </div>
          </template>
        </div>
      </div>

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
              @click="selectUser(user)"
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
                  @click="selectUser(friend)"
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

    <DoneModal v-if="isShowModal" @close="closeModal">
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
  computed: {
    // すでに選ばれているかどうかの判定
    isSelected(){
      return function(user) {
        if(this.selectedUsers.length == 0) return false;

        for (let i = 0 ; i < this.selectedUsers.length ; i++){
          if(this.selectedUsers[i].id == user.id){
            return true
          }
        }
      }
    },
    // すでに検索されているかどうかの判定
    isSearched(){
      return function(user) {
        if(this.searchedUsers.length == 0) return false;

        for (let i = 0 ; i < this.searchedUsers.length ; i++){
          if(this.searchedUsers[i].id == user.id){
            return true
          }
        }
      }
    },
    // 選択されているユーザーIDを返す
    selectedUserIds(){
      var selectedUserIds = []
      for (let i = 0 ; i < this.selectedUsers.length ; i++){
        selectedUserIds.push(this.selectedUsers[i].id)
      }
      return selectedUserIds
    }
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
      searchedUsers: [],
      selectedUsers: [],
      isLoading: false,
      isSearching: false,
      color: "#8bd3dd",
      isShowModal: false,
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
        
        var users = res.data.searchedUsers
        for (let i = 0 ; i < users.length ; i++){
          var user = users[i]

          // 選択済み or 検索済みのユーザーは取得しない
          if(this.isSelected(user) || this.isSearched(user)){
            continue
          }else{
            self.searchedUsers.push(user)
          }
        }
        self.isSearching = false;
      } catch(e) {
        console.log(e)
      }
    },
    selectUser(user){
      var self = this

      // すでに選択済みの場合
      if(self.selectedUsers.includes(user)) return;
      // 募集人数分すでに選択している場合
      if(self.selectedUsers.length >= self.invitableNumber) return;

      self.selectedUsers.push(user)
      if(self.listedFriends.includes(user)){
        self.listedFriends = self.listedFriends.filter(n => n !== user);
      }else{
        self.searchedUsers = self.searchedUsers.filter(n => n !== user);
      }
    },
    removeSelectedUser(userId){
      var self = this
      const target = self.selectedUsers.find((user) => {
          return (user.id == userId);
      });

      if(self.selectedUsers.includes(target)){
        self.selectedUsers = self.selectedUsers.filter(n => n !== target);
      }

      if(target.isFriend){
        self.listedFriends.push(target)
      }else{
        self.searchedUsers.push(target)
      }
    },
    async confirmMember(){
      var self = this
      if(self.selectedUsers.length == 0) return;

      if(self.listedType == "post_member"){
        const res = await axios.post("/api/v1/add_post_members", {
          user_ids: this.selectedUserIds
        })
        .then( res => {
          self.isShowModal = true
        })
        .catch( error => {
          console.log(error)
        })
      }else if(self.listedType == "attack_group"){
        const res = await axios.post("/api/v1/attack_groups", {
          user_ids: this.selectedUserIds
        })
        .then( res => {
          self.isShowModal = true
        })
        .catch( error => {
          console.log(error)
        })
      }
    },
    closeModal(){
      this.isShowModal = false
      window.location.href = '/post_members/new'
    },
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
  background: #f9f9f9;
  border-radius: 4px;
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
  max-width: 100%;
}

.check-position{
  position: absolute;
  top: -0.2em;
  left: 6.7em;
}

.select-member__list-selected-item{
  border: 1px solid #001858;
  border-radius: 5rem;
  padding: 4px;
  min-width: 120px;
  height: 44px;
  box-sizing: border-box;
  display: flex;
  align-items: center;
  margin-right: 8px;
  position: relative;
}

.selected-users-list{
  border: 2px solid #ddd;
  min-height: 56px;
  box-sizing: border-box;
}

.fa-times{
  border-radius: 50%;
  background: #fff;
  padding: 4px;
}

.select-member__list-item{
  border: 1px solid #001858;
  border-radius: 5rem;
  padding: 4px;
  min-width: 120px;
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