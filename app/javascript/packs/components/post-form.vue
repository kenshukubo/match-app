<template>
  <div>
    <h3>
      合コンをセッティングする
    </h3>

    <div class="form">
      <div class="field">
        <div class="label">
          場所
        </div>
        <input v-model="form.place" type="text" placeholder="東京駅周辺">
      </div>

      <div class="field">
        <div class="label">
          {{userSex}}の人数（自分を合わせて）
        </div>
        <select v-model="form.userNumber">
          <option v-for="number in numbers" :key="`number-${number}`">
            {{ number }}
          </option>
        </select>
      </div>

      <div class="field">
        <div class="label">
          <label>
            時間帯
          </label>
        </div>
        <select></select>〜
      </div>
    </div>

    <div class="field">
      <div class="button-wrapper">
        <button class="app-button conversion">次へ（{{userSex}}メンバーを選ぶ）</button>
      </div>
    </div>

  </div>
</template>
<script>
import axios from 'packs/axios'

export default {
  computed: {
    userSex() {
      if(this.sex == "male"){
        return "男子"
      }else{
        return "女子"
      }
    }
  },
  data() {
    return {
      sex: "",
      numbers: [2,3,4,5],
      form: {
        place: "",
        userNumber: "",
      }
    }
  },
  created() {
    let postFormElement = document.getElementById("post-form");
    let data = JSON.parse(postFormElement.getAttribute('data'));
    this.sex = data.sex
  },
  methods: {

  }
}
</script>
<style lang="sass" scoped>

</style>