<template>
  <div class="header-notification-wrapper">
    <img :src="bellImage" class="notification-img">
    <span class="header-notification-dot" v-if="NotificationCount > 0"></span>
  </div>
</template>
<script>
import bellImage from 'packs/assets/images/bell.png'

export default {
  data() {
    return {
      bellImage,
      NotificationCount: 0,
    }
  }
}
</script>
<style scoped lang="scss">
.header-notification-wrapper{
  position: relative;
}

.header-notification-dot{
  position: absolute;
  top: -4px;
  right: 6px;
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background-color: #FF3654;
}

.notification-img{
  width: 20px;
  margin-right: 8px;
}
</style>