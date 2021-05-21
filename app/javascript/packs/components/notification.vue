<template>
  <div class="header-notification" ref="elRoot">
    <div class="header-notification-wrapper">
      <img :src="bellImage" class="notification-img hover-opacity" @click="openNotificationList">
      <span class="header-notification-dot" v-if="notificationCount > 0"></span>
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

      <div v-if="!selectedMenu" class="notification-item-wrapper">
        <div v-if="!Object.keys(usuallNotifications).length">
          <div class="notification-item">
            <span>ただいま通知はありません</span>
          </div>
        </div>
        <template v-else v-for="(notification, index) in usuallNotifications">
          <a :href="notification.url" class="notification-item" :key="`notification-${index}`">
            <div class="notification-img-wrapper">
              <img :src="notificationImage(notification.category)" class="notification-item-img">
            </div>
            <div class="notification-text-wrapper">
              <div>
                <span>{{notification.message}}</span>
              </div>
            </div>
          </a>
        </template>
      </div>
      <div v-else class="notification-item-wrapper">
        <div v-if="!Object.keys(adminNotifications).length">
          <div class="notification-item">
            <span>ただいま通知はありません</span>
          </div>
        </div>
        <template v-else v-for="(notification, index) in adminNotifications">
          <a :href="notification.url" class="notification-item" :key="`notification-${index}`">
            <div class="notification-img-wrapper">
              <img :src="notificationImage(notification.category)" class="notification-item-img">
            </div>
            <div class="notification-text-wrapper">
              <div>
                <span>{{notification.message}}</span>
              </div>
            </div>
          </a>
        </template>
      </div>
    </div>
  </div>
</template>
<script>
import axios from 'packs/axios'
import bellImage from 'packs/assets/images/bell.png'
import inviteImage from 'packs/assets/images/notifications/invite.png'
import changeImage from 'packs/assets/images/notifications/change.png'
import attendImage from 'packs/assets/images/notifications/attend.png'
import absentImage from 'packs/assets/images/notifications/absent.png'

export default {
  computed: {
    selectedUserNotification(){
      return !!this.selectedMenu ? '':'is-active'
    },
    selectedAdminNotification(){
      return !!this.selectedMenu ? 'is-active':''
    },
    notificationImage: function() {
      return function(category) {
        switch (category){
          case "invite":{
            return inviteImage;
            break
          }
          case "change":{
            return changeImage;
            break
          }
          case "attend":{
            return attendImage;
            break
          }
          case "absent":{
            return absentImage;
            break
          }
          default: {
            return inviteImage;
          }
        }
      }
    }
  },
  data() {
    return {
      bellImage,
      inviteImage,
      changeImage,
      notificationCount: 0,
      showNotificationList: false,
      selectedMenu: "",
      usuallNotifications: [],
      adminNotifications: [],
    }
  },
  created() {
    this.fetchNotificationCount();
  },
  mounted(){
    //枠外クリックで非表示する処理
    window.addEventListener('click', this._onBlurHandler = (event) => {
      if (this.$refs.elRoot.contains(event.target)) {
        return;
      }
      this.showNotificationList = false;
    });
  },
  methods: {
    async fetchNotificationCount(){
      var self = this;
      try {
        const res = await axios.get("/api/v1/notification_count")
        self.notificationCount = res.data.notificationCount;
      } catch(e) {
        console.log(e)
      }
    },
    openNotificationList: function(){
      this.notificationCount = 0;
      if(this.showNotificationList){
        this.showNotificationList = false;
      }else{
        this.showNotificationList = true;
      }
      this.fetchNotification();
    },
    async fetchNotification(){
      var self = this;
      try {
        const res = await axios.get("/api/v1/usuall_notifications")
        self.usuallNotifications = res.data.usuallNotifications;
      } catch(e) {
        console.log(e)
      }
    },
    async selectNotificationType(type) {
      this.selectedMenu = type;
      if(type == "admin"){
        var self = this;
        try {
          const res = await axios.get("/api/v1/admin_notifications")
          self.adminNotifications = res.data.adminNotifications;
        } catch(e) {
          console.log(e)
        }
      }
    },
  }
}
</script>
<style scoped lang="scss">
.header-notification{
  position: relative;
}
.header-notification-wrapper{
  position: relative;
  margin-right: 8px;
  display: flex;
  align-items: center;
}

.header-notification-dot{
  position: absolute;
  top: -5px;
  right: -5px;
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
  right: -54px;
  top: 32px;
  min-width: 300px;
  max-height: 400px;
  padding: 8px 0;
  background-color: #fff;
  box-shadow: 1px 1px 6px rgba(0, 0, 0, 0.25);
  z-index: 997;
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

.notification-item-wrapper{
  max-height: 300px;
  overflow: scroll;
}

.notification-item{
  display: flex;
  padding: 16px;
  border-top: 1px solid #f2f2f2;
  font-size: 12px;
}

.notification-img-wrapper{
  display: flex;
  align-items: center;
}

.notification-item-img{
  width: 40px;
}

.notification-text-wrapper{
  display: flex;
  flex-direction: column;
  margin-left: 12px;
}
</style>