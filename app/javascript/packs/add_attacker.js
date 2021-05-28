import Vue from 'vue/dist/vue.esm'
import AddAttacker from './components/add-attacker.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#add-attacker',
    data: {
    },
    components: { AddAttacker }
  })
})
