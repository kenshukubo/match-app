import Vue from 'vue/dist/vue.esm'
import HeaderMenu from './components/header/menu.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#menu',
    data: {
    },
    components: { HeaderMenu }
  })
})
