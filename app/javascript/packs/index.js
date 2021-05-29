import Vue from 'vue/dist/vue.esm'
import Index from './components/index.vue'
import VueConfetti from 'vue-confetti' //紙吹雪のライブラリ

Vue.use(VueConfetti)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#index',
    data: {
    },
    components: { Index }
  })
})
