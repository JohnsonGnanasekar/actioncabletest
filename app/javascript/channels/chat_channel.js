import consumer from "./consumer"

const chatChannel = consumer.subscriptions.create({ channel: "ChatChannel"})

chatChannel.send({ body: "This is a cool chat app." })