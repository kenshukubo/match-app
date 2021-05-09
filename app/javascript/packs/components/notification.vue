<template>
  <div>
    <div class="header-notification-wrapper">
      <img :src="bellImage" class="notification-img" @click="openNotificationList">
      <span class="header-notification-dot" v-if="NotificationCount > 0"></span>
    </div>
    <div class="notification-list-wrapper" v-if="showNotificationList">
      <div>
        <ul class="notification-menu-wrapper">
          <li class="notification-menu" :class="selectedUserNotification" @click="selectNotificationType('')">
            <span>通知</span>
          </li>
          <li class="notification-menu" :class="selectedAdminNotification" @click="selectNotificationType('admin')">
            <span>お知らせ</span>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>
<script>
import bellImage from 'packs/assets/images/bell.png'

export default {
  computed: {
    selectedUserNotification(){
      return !!this.selectedMenu ? '':'is-active'
    },
    selectedAdminNotification(){
      return !!this.selectedMenu ? 'is-active':''
    }
  },
  data() {
    return {
      bellImage,
      NotificationCount: 0,
      showNotificationList: false,
      selectedMenu: "",
    }
  },
  methods: {
    openNotificationList: function(){
      if(this.showNotificationList){
        this.showNotificationList = false;
      }else{
        this.showNotificationList = true;
      }
    },
    selectNotificationType(type) {
      this.selectedMenu = type;
    },
  }
}
</script>
<style scoped lang="scss">
.header-notification-wrapper{
  position: relative;
  margin-right: 8px;
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
  cursor: pointer;
  width: 20px;
}

.notification-list-wrapper{
  position: absolute;
  left: 58%;
  top: 45px;
  min-width: 300px;
  padding: 8px 0;
  background-color: #fff;
  box-shadow: 1px 1px 6px rgba(0, 0, 0, 0.25);
}

.notification-menu-wrapper{
  display: flex;
  border-bottom: 1px solid #e6e6e6;
}

.notification-menu{
  width: 50%;
  padding: 4px 0 12px;
  font-weight: 700;
  font-size: 14px;
  text-align: center;
  cursor: pointer;
}

.is-active{
  border-bottom: 2px solid #000;
}
</style>