import consumer from "./consumer"

const chatChannel = consumer.subscriptions.create({ channel: "ChatChannel"})
