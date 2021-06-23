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
        <div class="container">
          <div class="room-header">
            <div class="room-header__title-wrapper">
              <div class="room-header__back-btn hover-opacity" @click="backToIndex">
                <span><i class="fa fa-angle-left"></i></span>
                <span class="room-header__title">一覧に戻る</span>
              </div>
              <div class="room-header__selected-user">
                <span class="room-header__title">{{ selectedPartnerUser.name || "ゲストさん" }}</span>
                <img :src="selectedPartnerUser.image" class="room-user__image">
              </div>
            </div>
          </div>

          <div class="room-body" ref="messages">
            <div class="messages">
              <template v-for="(message, index) in messages">
                <div class="message" :class="messageClass(message)" :key="`room-msg-${index}`">
                  <div class="message-body">
                    <div class="message-user">
                      <img :src="message.userProfileImageUrl" class="message-user__image">
                    </div>
                    <span class="message-content">
                      <div class="message-bubble">{{ message.text.trim() }}</div>
                    </span>
                  </div>
                  <div class="message-footer"> 
                    <span class="message-date">
                      {{ message.formattedCreatedAt }}
                    </span>
                  </div>
                </div>
              </template>
              <div class="room-space-placeholder">
                <div class="rooms-space-placeholder__input"></div>
              </div>
            </div>
          </div>

          <div class="room-footer">
            <div class="room-footer__nav">
              <div></div>
              <button @click="speak" class="room-footer__send-btn hover-opacity">
                送信
              </button>
            </div>
            <textarea v-model="newMessage" placeholder="ここにメッセージ内容を入力" class="room-footer__input"></textarea>
          </div>

          <div class="room-footer room-footer-sp">
            <textarea v-model="newMessage" placeholder="ここにメッセージ内容を入力" class="room-footer__input"></textarea>
            <div class="room-footer__nav">
              <div></div>
              <button @click="speak" class="room-footer__send-btn hover-opacity">
                送信
              </button>
            </div>
          </div>
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
    selectedRoom(){
      if(!this.selectedRoomIdentifiedChar) return ""
      return this.rooms.find(room => room.identifiedChar == this.selectedRoomIdentifiedChar);
    },
    selectedPartnerUser(){
      if(!this.selectedRoom || !this.currentUser) return ""
      return this.selectedRoom.roomUsers.find(roomUser => roomUser.identifiedChar != this.currentUser.identifiedChar);
    },
    messageClass(){
      return function(message) {
        if(message.userIdentifiedChar == this.currentUser.identifiedChar){
          return "my-message" 
        }
        return ""
      }
    },
  },
  watch: {
    messages: function(newValue) {
      if(!this.autoscroll) return
      this.scrollToEnd()
    },
  },
  data() {
    return {
      rooms: [],
      messages: [],
      currentUser: "",
      roomMode: "index",
      inputMode: "text",
      selectedRoomIdentifiedChar: "",
      newMessage: "",
      lastMessage: "",
      messageChannel: null,
      autoscroll: true,
    }
  },
  created() {
    this.fetchCurrentUser();
    this.fetchRooms();

    // safariのメニューバー対策
    let vh = window.innerHeight * 0.01;
    document.documentElement.style.setProperty('--vh', `${vh}px`);

    if(!!this.selectedRoomIdentifiedChar){
      this.roomMode = "show"
      this.fetchRoomMessages();
      this.subscribe();
    }
  },
  methods: {
    selectRoom(identifiedChar){
      this.roomMode = "show"
      this.selectedRoomIdentifiedChar = identifiedChar;
      this.messages = []
      this.unsubscribe();
      this.subscribe();
      this.fetchRoomMessages();
    },
    speak() {
      if (!this.messageChannel) return
      switch (this.inputMode) {
        case 'text':
          if (this.newMessage == '') return
          this.messageChannel.perform('speak', { 
            identified_char: this.selectedRoomIdentifiedChar,
            text: this.newMessage, 
            message_type: "text"
          });
          this.newMessage = ""
          break;
        default:
          console.log('invalid request');
      }
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
    subscribe(){
      this.messageChannel = this.$cable.subscriptions.create( 
          {
            channel: "MessageChannel", 
            room_id: this.selectedRoomIdentifiedChar,
          } ,{
        received: (data) => {
          // console.log("MessageChannel received")
          // 選択中の部屋のメッセージのみ反映
          if(data.roomIdentifiedChar != this.selectedRoomIdentifiedChar) return

          // 二重投稿防止
          const duplicateMessage = this.messages.find(message => message.id == data.messageId);
          if(!!duplicateMessage) return

          this.messages.push(data)
          this.lastMessage = data
        },
      })  
    },
    unsubscribe(){
      var self = this
      this.$cable.subscriptions.subscriptions.forEach(function (subscription) {
          // メッセージチャンネルのサブスクリプションを削除
          if(subscription.identifier.includes("MessageChannel")){
            // console.log("message unsubsucribed")
            self.$cable.subscriptions.remove(subscription);
          }
      });
    },
    scrollToEnd() {
      this.$nextTick(() => {
        const chatLog = this.$refs.messages
        if (!chatLog) return
        chatLog.scrollTop = chatLog.scrollHeight
      })
    },
    backToIndex(){
      this.roomMode = "index"
    },
  },
}
</script>