import Vue from 'vue/dist/vue.esm'
import ActionCable from 'actioncable';
import Rooms from './components/rooms.vue'

const cable = ActionCable.createConsumer('ws:localhost:3000/cable');
Vue.prototype.$cable = cable;

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#rooms',
    data: {
    },
    components: { Rooms }
  })
})
