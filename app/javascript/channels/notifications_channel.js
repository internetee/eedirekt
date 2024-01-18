import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log("Connected to notifications channel")
  },

  disconnected() {
    console.log("Disconnected from notifications channel")
  },

  received(data) {
    const notificationsList = document.querySelector('#notifications');
    const listItem = document.createElement('li');
    listItem.innerText = data.message;
    notificationsList.appendChild(listItem);
  }
});
