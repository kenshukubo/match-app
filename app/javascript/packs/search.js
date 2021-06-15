import Vue from 'vue/dist/vue.esm'
import Search from './components/header/search.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#search',
    data: {
    },
    components: { Search }
  })
})
