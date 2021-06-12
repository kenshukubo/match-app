<template>
  <div>
    <div class="post-list">
      <clip-loader :loading="isLoading" :color="color"></clip-loader>
      <template v-for="(post, index) in postList">
        <div class="post-item-wrapper" :key="`post-${index}`">
          <span class="post-created">{{post.createdAt}}</span>
          <div class="post-item"
            :style="{ 'background-image': 'url(' + postBackgroundImage + ')' }"
          >
            <div class="post-item__text-area">
              <p class="post-item__title">{{post.place}}で{{post.time}}から一緒にご飯いきませんか？</p>
              <div v-if="!!post.members" class="post-item__member-img-wrapper">
                <template v-for="(member, index) in post.members">
                  <img :src="member.image" @click="zoomIn(member)" :key="`member-${index}`" class="post-item__member-img hover-opacity">
                </template>
              </div>
            </div>
            <span v-if="index==0" class="post-item__desc">※アイコンをタップするとプロフィールをみれます</span>
          </div>

          <div v-if="post.isHost" class="post-item__option-wrapper">
            <div class="post-item__option" style="margin-right:8px;">
              <img :src="trashImage" class="post-item__option-img">
              <span @click="deletePost(post.id)" class="post-item__option-text hover-opacity">ゴミ箱</span>
            </div>

            <div class="post-item__edit-option-wrapper">
              <a :href="`/posts/${post.id}/edit`" class="post-item__option">
                <img :src="editImage" class="post-item__option-img">
                <span class="post-item__option-text hover-opacity">編集する</span>
              </a>
            </div>
          </div>
          <div v-else class="post-item__request">
            <button v-if="post.isAttacked" class="post-item__request-btn post-item__attacked">
                <span class="post-item__chat-text">アタック済み</span>
            </button>
            <button v-else class="post-item__request-btn hover-opacity hover-scale">
                <span v-if="post.sex == 'female'" @click="showMenuModal(post.id)" class="post-item__chat-text">🙋‍♂️ アタックする</span>
                <span v-else @click="showMenuModal(post.id)" class="post-item__chat-text">🙋‍♀️ アタックする</span>
            </button>
          </div>
        </div>
      </template>
    </div>

    <ZoomInModal v-if="showZoomInModal" @close="closeModal">
      <template slot="image">
        <img :src="zoomInProfile.image" class="profile-image">
      </template>
      <template slot="name">
        <p class="profile-info">{{zoomInProfile.name}}</p>
      </template>
      <template slot="age" v-if="zoomInProfile.age">
        <p class="profile-info">{{zoomInProfile.age}}才</p>
      </template>
      <template slot="job" v-if="zoomInProfile.job">
        <p class="profile-info">{{zoomInProfile.job}}</p>
      </template>
    </ZoomInModal>

    <SelectMenuModal
      v-if="showSelectMenuModal"
      @close="closeModal"
      :hasAnyAttackGropups="hasAnyAttackGropups"
      @show-friend-list-modal='showAttackGroupModal = $event'
      @hide-menu-modal='showSelectMenuModal = $event'
    >
    </SelectMenuModal>

    <AttackGroupModal
      v-if="showAttackGroupModal"
      @show-attack-done-modal='attackDone = $event'
      @hide-attack-group-modal='showAttackGroupModal = $event'
      @close="closeModal"
      :selectedPostId="selectedPostId"
    >
    </AttackGroupModal>

    <DoneModal v-if="postListed" @close="closeModal">
      <img :src="popperImage" slot="image" class="post-listed__popper-img">
      <span slot="title" class="post-listed__popper-title">募集が投稿されました</span>
      <span slot="text" class="post-listed__popper-text">アタックを待ちましょう</span>
    </DoneModal>

    <DoneModal v-if="attackDone" @close="closeModal">
      <img :src="popperImage" slot="image" class="post-listed__popper-img">
      <span slot="title" class="post-listed__popper-title">💥 アタックしました</span>
      <span slot="text" class="post-listed__popper-text">反応を待ちましょう</span>
    </DoneModal>

  </div>
</template>
<script>
import axios from 'packs/axios'
import postBackgroundImage from 'packs/assets/images/post-background.png'
import trashImage from 'packs/assets/images/trash.png'
import editImage from 'packs/assets/images/edit.png'
import ZoomInModal from './modal/ZoomInModal.vue'
import SelectMenuModal from './modal/SelectMenuModal.vue'
import AttackGroupModal from './modal/AttackGroupModal.vue';
import DoneModal from './modal/DoneModal.vue'
import ClipLoader from 'vue-spinner/src/ClipLoader'

import popperImage from 'packs/assets/images/popper.png'

export default {
  components: {
    ZoomInModal,
    SelectMenuModal,
    AttackGroupModal,
    DoneModal,
    ClipLoader,
  },
  data() {
    return{
      postBackgroundImage,
      trashImage,
      editImage,
      popperImage,

      postList: "",
      zoomInProfile: "",
      hasAnyAttackGropups: "",
      selectedPostId: "",

      showZoomInModal: false,
      showSelectMenuModal: false,
      showAttackGroupModal: false,
      attackDone: false,
      postListed: false,

      isLoading: false,
      color: "#8bd3dd",
      
    }
  },
  created() {
    this.fetchPostList();
    this.fetchPostIsListed();
  },
  methods: {
    async fetchPostList(){
      var self = this;
      self.isLoading = true;
      try {
        const res = await axios.get("/api/v1/posts")
        self.postList = res.data.postList;
        self.isLoading = false;
      } catch(e) {
        console.log(e)
      }
    },
    async zoomIn(member) {
      var self = this;
      try {
        const res = await axios.get('/api/v1/zoom_in_profile', {
          params: {id: member.id}
        })
        self.zoomInProfile = res.data.zoomInProfile;
        self.showZoomInModal = true;
      } catch(e) {
        console.log(e)
      }
    },
    async showMenuModal(postId) {
      var self = this;
      try {
        const res = await axios.get('/api/v1/attack_group_check')
        self.hasAnyAttackGropups = res.data.anyAttackGroups
        self.showSelectMenuModal = true;
        self.selectedPostId = postId
      } catch(e) {
        console.log(e)
      }
    },
    async fetchPostIsListed(){
      var self = this;
      try {
        const res =  await axios.patch("/api/v1/post_listed_check")
        self.postListed = res.data.isModal
        if(self.postListed) this.confettiStart();
      } catch(e) {
        console.log(e)
      }
    },
    closeModal() {
      var self = this;
      self.showZoomInModal      = false;
      self.showSelectMenuModal  = false;
      self.postListed           = false;
      self.showAttackGroupModal = false;
      self.attackDone           = false;
      this.confettiStop();
    },
    async deletePost(postId){
      if(confirm('投稿を削除します。よろしいでしょうか？')){
        return await axios.delete(`/api/v1/posts/${postId}`)
      }
    },
    confettiStart() {
      this.$confetti.start();
    },
    confettiStop() {
      this.$confetti.stop();
    },
  }
}
</script>
<style scoped lang="scss">
.post-item-wrapper{
  margin-bottom: 36px;
  padding: 16px 16px 0px;
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 .5rem 1rem rgba(0,0,0,.15);
}

.post-created{
  display: inline-block;
  padding: 0 8px;
  border-radius: 10px;
  background:#fff;
  color: #001858;
  border: 1px solid #001858;
  font-size: .571rem;
  line-height: 1.428rem;
  margin-bottom: 4px;
}

.post-item{
  display: flex;
  flex-direction: column;
  align-items: center;
  background-size: cover;
  height: 320px;
  @media(max-width: 415px){
    height: 220px;
  }
}

.post-item__text-area{
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  width: 90%;
  height: 72%;
  margin-top: 20px;
  background: #fff;
  border-radius: 8px;
  padding: 16px 20px;
  box-sizing: border-box;
  @media(max-width: 415px){
    padding: 12px 18px;
  }
}

.post-item__title{
  max-height: 144px;
  font-weight: 700;
  font-size: 34px;
  text-align: center;
  @media(max-width: 576px){
    font-size: 28px;
  }
  @media(max-width: 415px){
    font-size: 20px;
  }
}

.post-item__member-img-wrapper{
  display: flex;
  justify-content: space-evenly;
}
.post-item__member-img{
  width: 64px;
  height: 64px;
  object-fit: cover;
  border-radius: 50%;
  cursor: pointer;
  @media(max-width: 415px){
    width: 48px;
    height: 48px;
  }
}

.post-item__desc{
  display: block;
  width: -webkit-fill-available;
  text-align: end;
  font-size: 10px;
  color: #fff;
  padding-right: 30px;
}

.post-item__option-wrapper{
  display: flex;
  height: 24px;
}

.post-item__edit-option-wrapper{
  display: flex;
  align-items: center;
}

.post-item__option{
  display: flex;
  align-items: center;
}

.post-item__option-img{
  width: 12px;
  height: 12px;
}

.post-item__option-text{
  font-size: .714rem;
  font-weight: 700;
  cursor: pointer;
}

.post-item__request{
  display: flex;
  justify-content: center;
  padding: 8px 0px;
}

.post-item__request-btn{
  display: flex;
  align-items: center;
  background: #8bd3dd;
  border: 1px solid #8bd3dd;
  cursor: pointer;
  border-radius: 10px;
  min-width: 150px;
  text-align: center;
}

.post-item__attacked{
  background: #ddd;
  border: 1px solid #ddd;
  cursor: unset;
}

.post-item__chat-text{
  width: 100%;
  color: #fff;
  font-weight: 700;
  line-height: 24px;
}

.profile-image{
  max-width: 360px;
  max-height: 360px;
}
.profile-info{
  text-align: center;
}
</style>