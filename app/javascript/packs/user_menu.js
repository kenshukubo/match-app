import Vue from 'vue/dist/vue.esm'
import UserMenu from './components/header/user-menu.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#user-menu',
    data: {
    },
    components: { UserMenu }
  })
})
