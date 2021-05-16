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

            </div>
          </div>

          <div v-if="post.isHost" class="post-item__option-wrapper">
            <div class="post-item__option" style="margin-right:8px;">
              <img :src="trashImage" class="post-item__option-img">
              <span class="post-item__option-text">ゴミ箱</span>
            </div>

            <div class="post-item__option">
              <a :href="`/posts/${post.id}/edit`">
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
  }
}
</script>
<style>
.post-item-wrapper{
  margin: 24px 0;
  padding: 16px 16px 4px;
  background: #fff;
  box-shadow: 2px 2px 8px -2px rgb(0 0 0 / 5%);
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
}

.post-item__text-area{
  width: 90%;
  height: 72%;
  margin-top: 20px;
  background: #fff;
  border-radius: 8px;
}

.post-item__option-wrapper{
  display: flex;
  height: 24px;
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