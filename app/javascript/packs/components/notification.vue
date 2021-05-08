<template>
  <img :src="bellImage" class="notification-img">
</template>
<script>
import bellImage from 'packs/assets/images/bell.png'

export default {
  data() {
    return {
      bellImage,
    }
  }
}
</script>
<style scoped lang="scss">
.notification-img{
  width: 24px;
  margin-right: 4px;
}
</style>