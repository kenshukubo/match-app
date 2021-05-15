import Vue from 'vue/dist/vue.esm'
import Index from './components/index.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#index',
    data: {
    },
    components: { Index }
  })
})
