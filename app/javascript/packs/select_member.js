import Vue from 'vue/dist/vue.esm'
import SelectMember from './components/select-member.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#select-member',
    data: {
    },
    components: { SelectMember }
  })
})
