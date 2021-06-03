<template>
  <transition name="modal" appear>
    <div class="modal modal-overlay" @click.self="$emit('close')">
      <div class="modal-window">
        <div class="modal-content">
          <h3 class="attack-group-select__header-title">チームを選んでください</h3>
          <div v-swiper:mySwiper="swiperOption">
            <div class="swiper-wrapper">
              <div class="swiper-slide" v-for="(attackGroup, index) in attackGroups" :key="`group-${index}`">
                <p class="attack-group-item__team-name">
                  チーム{{attackGroup.groupNumber}}
                </p>
                <div class="attacker-info" v-for="(attacker, index) in attackGroup.attackers" :key="`attacker-${index}`">
                  <img :src="attacker.image" class="attacker-info__user-img">
                  <span class="attacker-info__user-name text-ellipsis">{{attacker.name}}</span>
                </div>
              </div>
            </div>
            <div class="swiper-pagination" slot="pagination"></div>
            <div class="swiper-button-prev" slot="button-prev"></div>
            <div class="swiper-button-next" slot="button-next"></div>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>
<script>
import axios from 'packs/axios'
import { directive } from 'vue-awesome-swiper'
// Import Swiper styles
import 'swiper/css/swiper.css'

export default {
  directives: {
    swiper: directive
  },
  data() {
    return{
      attackGroups: "",
      swiperOption: {
        pagination: {
          el: '.swiper-pagination',
          clickable: true
        },
        navigation: {
          nextEl: '.swiper-button-next',
          prevEl: '.swiper-button-prev'
        },
        slidesPerView: 1,
      }
    }
  },
  mounted() {
    console.log('Current Swiper instance object', this.mySwiper)
    // this.mySwiper.slideTo(3, 1000, false)
  },
  created() {
    this.fetchAttackGroups()
  },
  methods: {
    async fetchAttackGroups(){
      var self = this;
      try {
        const res = await axios.get("/api/v1/attack_groups")
        self.attackGroups = res.data.attackGroups;
      } catch(e) {
        console.log(e)
      }
    }
  }
}
</script>
<style scoped lang="scss">
.modal {
  &-content {
    display: flex;
    flex-direction: column;
    padding: 16px 32px;
  }
}

.attack-group-select__header-title{
  font-size: 14px;
  text-align: center;
  margin-bottom: 24px;
}

.attack-group-item{
  margin-bottom: 24px;
}

.attack-group-item__team-name{
  text-align: center;
  margin-bottom: 8px;
}

.attacker-info{
  display: flex;
  align-items: center;
  margin-bottom: 6px;
}

.attacker-info__user-img{
  width: 38px;
  height: 38px;
  object-fit: cover;
  border-radius: 50%;
  margin-right: 8px;
}

.attacker-info__user-name{
  max-width: 240px;
  min-width: 160px;
}

.swiper-container {
  width: 300px;
  height: 100%;
}

.swiper-wrapper{
  margin-bottom: 52px;
}

.swiper-button-next, .swiper-button-prev{
  @media(max-width: 415px){
    display: none;
  }
}

.swiper-button-next:after, .swiper-button-prev:after{
  padding-bottom: 18px;
}
</style>