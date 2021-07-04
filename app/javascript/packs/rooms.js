import Vue from 'vue/dist/vue.esm'
import ActionCable from 'actioncable';
import Rooms from './components/rooms.vue'

// TODO ドメイン決まったら変更
const cable = ActionCable.createConsumer('wss:https://match-app.onrender.com/cable');
Vue.prototype.$cable = cable;

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#rooms',
    data: {
    },
    components: { Rooms }
  })
})
