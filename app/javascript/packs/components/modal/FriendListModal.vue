<template>
  <transition name="modal" appear>
    <div class="modal modal-overlay" @click.self="$emit('close')">
      <div class="modal-window">
        <div class="modal-content">
          <h3 class="attack-group-select__header-title">チームを選んでください</h3>

          <div v-swiper:mySwiper="swiperOption">
            <div class="swiper-wrapper">
              <clip-loader :loading="isLoading" :color="color"></clip-loader>
              <div
                v-for="(attackGroup, index) in attackGroups"
                :key="`group-${index}`"
                @click="selectGroup(attackGroup)"
                v-bind:class="{ groupSelectActive: selectedGroupNumber == attackGroup.groupNumber }"
                class="swiper-slide attack-group-item"
              >
                <p class="attack-group-item__team-name">
                  チーム{{attackGroup.groupNumber}}
                </p>
                <div class="attacker-info-wrapper">
                  <div class="attacker-info" v-for="(attacker, index) in attackGroup.attackers" :key="`attacker-${index}`">
                    <img :src="attacker.image" class="attacker-info__user-img">
                    <span class="attacker-info__user-name text-ellipsis">{{attacker.name}}</span>
                  </div>
                </div>
                <div v-bind:class="{ checkRound: selectedGroupNumber == attackGroup.groupNumber }" class="check-position">
                  <span v-bind:class="{ checkMark: selectedGroupNumber == attackGroup.groupNumber }"></span>
                </div>
              </div>
            </div>
            <div class="swiper-pagination" slot="pagination"></div>
            <div class="swiper-button-prev" slot="button-prev"></div>
            <div class="swiper-button-next" slot="button-next"></div>
          </div>

          <button
            @click="submitRequest"
            v-bind:class="{ activeModalBtn: selectedGroupNumber }"
            v-bind:disabled="!selectedGroupNumber"
            class="modal-select-btn modal-select-disabled-btn"
          >
            チームを確定する
          </button>
        </div>
      </div>
    </div>
  </transition>
</template>
<script>
import axios from 'packs/axios'
import ClipLoader from 'vue-spinner/src/ClipLoader'
import { directive } from 'vue-awesome-swiper'
import 'swiper/css/swiper.css'

export default {
  props: ['selectedPostId'],
  components: {
    ClipLoader
  },
  directives: {
    swiper: directive
  },
  data() {
    return{
      attackGroups: "",
      color: "#8bd3dd",
      selectedGroupNumber: "",
      swiperOption: {
        pagination: {
          el: '.swiper-pagination',
          clickable: true
        },
        navigation: {
          nextEl: '.swiper-button-next',
          prevEl: '.swiper-button-prev'
        },
        centeredSlides: true,
        slidesPerView: 1,
        spaceBetween: 5,
      },
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
      self.isLoading = true;
      try {
        const res = await axios.get("/api/v1/attack_groups")
        self.attackGroups = res.data.attackGroups;
        self.isLoading = false;
      } catch(e) {
        console.log(e)
      }
    },
    selectGroup(group){
      this.selectedGroupNumber = group.groupNumber
    },
    async submitRequest(){
      var self = this;
      
      const res = await axios.post("/api/v1/request", {
        group_number: self.selectedGroupNumber,
        selected_post_id: self.selectedPostId
      })
      .then( res => {
        console.log("リクエスト完了")
        this.$emit('show-attack-done-modal', true);
        this.$emit('hide-attack-group-modal', false);
      })
      .catch( error => {
        console.log(error)
      })
    }
  }
}
</script>
<style scoped lang="scss">
.modal {
  &-content {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 16px 32px;
  }
}
// オーバーレイのトランジション
.modal-enter-active {
  transition: opacity 0.4s;

  // オーバーレイに包含されているモーダルウィンドウのトランジション
  .modal-window {
    transition: opacity 0.4s, transform 0.4s;
  }
}

.modal-enter {
  opacity: 0;

  .modal-window {
    opacity: 0;
    transform: translateY(-20px);
  }
}

.attack-group-select__header-title{
  font-size: 14px;
  text-align: center;
  margin-bottom: 24px;
}

.attack-group-item{
  cursor: pointer;
  width: 274px!important;
  border-radius: 8px;
  padding: 8px 12px;
  border: 1px solid transparent;
  position: relative;
  &:hover{
    border-color: #f582ae;
    background: #ffc6c7;
  }
}

.groupSelectActive{
  border-color:#f582ae;
  background: #ffc6c7;
}

.check-position{
  position: absolute;
  top: -0.05em;
  right: 106px;
}

.attack-group-item__team-name{
  text-align: center;
  margin-bottom: 8px;
}

.attacker-info-wrapper{
  height: 130px;
  overflow-y: scroll;
}

.attacker-info{
  display: flex;
  align-items: center;
  margin-bottom: 8px;
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