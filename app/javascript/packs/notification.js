import Vue from 'vue/dist/vue.esm'
import Notification from './components/notification.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#notification',
    data: {
    },
    components: { Notification }
  })
})
