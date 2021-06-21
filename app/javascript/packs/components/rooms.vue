<template>
  <div class="room-window" :class="`room-window--${roomMode}`">
      <div class="rooms">
        <div class="rooms-header">
          <span class="rooms-header__title">メッセージ一覧</span>
        </div>
        <div class="rooms-body">
          <div class="room-list">
            <!-- 選択可能なRooms -->
            <template v-for="(room, index) in rooms">
              <div
                @click="selectRoom(room.identifiedChar)"
                class="room-list-item"
                :key="`room-list-${index}`" 
              >
                <template v-for="(roomUser, index) in room.roomUsers">
                  <div 
                    v-if="!!currentUser && roomUser.identifiedChar !== currentUser.identifiedChar" 
                    class="room-user"
                    :key="`room-user-${index}`"
                  >
                    <div class="room-user-header">
                      <div class="room-user__image-wrapper">
                        <img :src="roomUser.image" class="room-user__image">
                      </div>
                    </div>
                    <div class="room-user-body">
                      <span class="room-user__name">{{ roomUser.name || "ゲストさん" }}</span>
                      <!-- <span class="room-user__last-msg">
                        <template v-if="showLastMessage">
                            {{ lastMessage.text }}
                        </template>
                        <template v-else>
                            {{ room.lastMessage }}
                        </template>
                      </span> -->
                    </div>
                  </div>
                </template>
              </div>
            </template>
          </div>
        </div>
      </div>
      <div class="room">
        <div class="room-header">
          <div class="rooms-header__title-wrapper">
            <div>
              <span><i class="fa fa-angle-left"></i></span>
              <span class="rooms-header__title">{{ selectedPartnerUser.name || "ゲストさん" }}</span>
            </div>
            <img :src="selectedPartnerUser.image" class="room-user__image">
          </div>
        </div>

        <div class="room-body">
          <div class="messages">
            <template v-for="(message, index) in messages">
              <div class="message" :key="`room-msg-${index}`">
                <div class="message-body">
                  <div class="message-user">
                    <img :src="message.userProfileImageUrl" class="message-user__image">
                  </div>
                  <span class="message-content">
                    <div class="message-bubble">{{ message.text.trim() }}</div>
                  </span>
                </div>
              </div>
            </template>
          </div>
        </div>

        <div class="room-footer">
          <textarea v-model="newMessage" placeholder="ここにメッセージ内容を入力" class="room-footer__input"></textarea>
        </div>
      </div>
  </div>
</template>

<script>
import axios from 'packs/axios'
import emojiData from 'packs/assets/emoji/index.json'

export default {
  components: {
  },
  computed: {
    selectedRoom: function(){
      if(!this.selectedRoomIdentifiedChar) return ""
      return this.rooms.find(room => room.identifiedChar == this.selectedRoomIdentifiedChar);
    },
    selectedPartnerUser: function(){
      if(!this.selectedRoom || !this.currentUser) return ""
      return this.selectedRoom.roomUsers.find(roomUser => roomUser.identifiedChar != this.currentUser.identifiedChar);
    },
  },
  data() {
    return {
      rooms: [],
      messages: [],
      currentUser: "",
      roomMode: "index",
      selectedRoomIdentifiedChar: "",
      newMessage: "",
    }
  },
  created() {
    this.fetchCurrentUser();
    this.fetchRooms();
  },
  methods: {
    selectRoom(identifiedChar){
      this.roomMode = "show"
      this.selectedRoomIdentifiedChar = identifiedChar;
      this.fetchRoomMessages();
    //   this.lastMessage = ""
    //   this.messages = []
    //   this.unsubscribe();
    //   this.subscribe();
    //   this.subscribeNotification();
    },
    fetchRooms(){
      var self = this;
      axios.get(`/api/v1/rooms`)
      .then(function(res) {
        self.rooms.push(...res.data.rooms)
      }).catch((err) => {
        console.log(err)
      })
    },
    fetchRoomMessages(){
      var self = this;
      axios.get(`/api/v1/rooms/${this.selectedRoomIdentifiedChar}/room_messages`)
      .then(function(res) {
        self.messages = res.data.roomMessages;
      }).catch((err) => {   
        console.log(err)
      })
    },
    fetchCurrentUser(){
      var self = this;
      axios.get("/api/v1/current_user")
      .then(function(res) {
        self.currentUser = res.data.currentUser
      }).catch((err) => {
        console.log(err)
      })
    },
  },
}
</script>