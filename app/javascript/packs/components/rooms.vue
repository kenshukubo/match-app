<template>
  <div class="room-window" :class="`room-window--${roomMode}`">
      <div class="rooms">
        <div class="rooms-header">
          <span class="rooms-header__title">メッセージ一覧</span>
        </div>
        <div class="rooms-body">
          <div class="room-list">
            <div class="room-space-placeholder">
              <div class="rooms-space-placeholder__header"></div>
            </div>
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
                    <!-- <div class="room-user-body">
                      <span class="room-user__name">{{ roomUser.name || "ゲストさん" }}</span>
                      <span class="room-user__last-msg">
                        <template v-if="showLastMessage">
                            {{ lastMessage.text }}
                        </template>
                        <template v-else>
                            {{ room.lastMessage }}
                        </template>
                      </span>
                    </div> -->
                  </div>
                </template>
              </div>
            </template>
          </div>
        </div>
      </div>
      <div class="room">


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
  },
  data() {
    return {
      rooms: [],
      currentUser: "",
      roomMode: "index",
      selectedRoomIdentifiedChar: "",
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
    //   this.lastMessage = ""
    //   this.messages = []
    //   this.unsubscribe();
    //   this.subscribe();
    //   this.subscribeNotification();
    //   this.fetchRoomMessages();
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