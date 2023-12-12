// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import consumer from "./channels/consumer"


const chatChannel = consumer.subscriptions.create("ChatChannel", {
    connected(){
        console.log("Connected to channel")
    },

    disconnected(){

    },

    received(data){
        const messageContainer = document.getElementById('messages')
        const newMessageDiv = document.createElement('div');
        newMessageDiv.className = 'message mb-2';
        newMessageDiv.innerHTML = `<div class="content-container">
                                            <div class="content">
                                            ${data.message}
                                            </div>
                                            <div class="author">
                                            Assistant
                                            </div>
                                            </div>
                                             `;
        messageContainer.appendChild(newMessageDiv);
        console.log(data)
    }

})


document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('new_message_form');
    const inputField = form.querySelector('[name="message[content]"]'); // Adjust selector as needed

    form.addEventListener('submit', function(event) {
        event.preventDefault();

        const messageContent = inputField.value.trim();
        const messageContainer = document.getElementById('messages')
        if (messageContent !== '') {
            chatChannel.send({ body: messageContent });
                // Assuming your message structure is similar to the existing one
                const newMessageDiv = document.createElement('div');
                newMessageDiv.className = 'message mb-2 me';
                newMessageDiv.innerHTML = `<div class="content-container">
                                            <div class="content">
                                            ${messageContent}
                                            </div>
                                            <div class="author">
                                            You
                                            </div>
                                            </div>
                                             `;
                messageContainer.appendChild(newMessageDiv);
            inputField.value = ''; // Clear the input field
            console.log("Data sent")
        }
    });
});
