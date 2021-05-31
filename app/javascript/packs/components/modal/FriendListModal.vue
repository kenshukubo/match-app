<template>
  <transition name="modal" appear>
    <div class="modal modal-overlay" @click.self="$emit('close')">
      <div class="modal-window">
        <div class="modal-content">
          <h3 class="attack-group-select__header-title">チームを選んでください</h3>
          <div>
            <template v-for="(attackGroup, index) in attackGroups">
              <div class="attack-group-item" :key="`group-${index}`">
                <p class="attack-group-item__team-name">
                  チーム{{attackGroup.groupNumber}}
                </p>
                <template v-for="(attacker, index) in attackGroup.attackers">
                  <div class="attacker-info" :key="`attacker-${index}`">
                    <img :src="attacker.image" class="attacker-info__user-img">
                    <span class="attacker-info__user-name text-ellipsis">{{attacker.name}}</span>
                  </div>
                </template>
              </div>
            </template>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>
<script>
import axios from 'packs/axios'
export default {
  data() {
    return{
      attackGroups: ""
    }
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
</style>