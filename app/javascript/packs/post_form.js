import Vue from 'vue/dist/vue.esm'
import PostForm from './components/post-form.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#post-form',
    data: {
    },
    components: { PostForm }
  })
})
