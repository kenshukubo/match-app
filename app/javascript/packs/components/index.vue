<template>
  <div>
    <div class="post-list">
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
                  <img :src="member.image" :key="`member-${index}`" class="post-item__member-img">
                </template>
              </div>
            </div>
          </div>

          <div v-if="post.isHost" class="post-item__option-wrapper">
            <div class="post-item__option" style="margin-right:8px;">
              <img :src="trashImage" class="post-item__option-img">
              <span @click="deletePost(post.id)" class="post-item__option-text">ゴミ箱</span>
            </div>

            <div class="post-item__edit-option-wrapper">
              <a :href="`/posts/${post.id}/edit`" class="post-item__option">
                <img :src="editImage" class="post-item__option-img">
                <span class="post-item__option-text">編集する</span>
              </a>
            </div>
          </div>
          <div v-else class="post-item__request">
            <button class="post-item__request-btn">
              <span class="post-item__chat-text">🙋‍♂️反応する</span>
            </button>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>
<script>
import axios from 'packs/axios'
import postBackgroundImage from 'packs/assets/images/post-background.png'
import trashImage from 'packs/assets/images/trash.png'
import editImage from 'packs/assets/images/edit.png'

export default {
  data() {
    return{
      postBackgroundImage,
      trashImage,
      editImage,
      postList: "",
    }
  },
  created() {
    this.fetchPostList();
  },
  methods: {
    async fetchPostList(){
      var self = this;
      try {
        const res = await axios.get("/api/v1/posts")
        self.postList = res.data.postList;
      } catch(e) {
        console.log(e)
      }
    },
    async deletePost(postId){
      if(confirm('投稿を削除します。よろしいでしょうか？')){
        return await axios.delete(`/api/v1/posts/${postId}`)
      }
    },
  }
}
</script>
<style scoped lang="scss">
.post-item-wrapper{
  margin: 24px 0;
  padding: 16px 16px 4px;
  background: #fff;
}

.post-created{
  display: inline-block;
  padding: 0 8px;
  border-radius: 10px;
  background:#001858;
  color: #fff;
  font-size: .571rem;
  line-height: 1.428rem;
  margin-bottom: 4px;
}

.post-item{
  display: flex;
  justify-content: center;
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
  border: 1px solid;
  border-radius: 50%;
  @media(max-width: 415px){
    width: 48px;
    height: 48px;
  }
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
  padding: 12px 0px;
}

.post-item__request-btn{
  display: flex;
  align-items: center;
  background: #f582ae;
  border: 1px solid #f582ae;
  cursor: pointer;
  border-radius: 10px;
  padding: 0 8px;
}

.post-item__chat-text{
  color: #fff;
  font-size: 1.142rem;
  font-weight: 700;
}
</style>