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
        </div>
      </template>
    </div>
  </div>
</template>
<script>
import axios from 'packs/axios'
import postBackgroundImage from 'packs/assets/images/post-background.png'
export default {
  data() {
    return{
      postBackgroundImage,
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
</style>