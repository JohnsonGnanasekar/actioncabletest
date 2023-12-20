// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import consumer from "./channels/consumer"

// Create a ChatChannel subscription using Action Cable consumer.
const chatChannel = consumer.subscriptions.create("ChatChannel", {
    // Callback when the connection is established.
    connected(){
        console.log("Connected to channel")
    },

    // Callback when the connection is lost.
    disconnected(){

    },


    // Callback when a new message is received from the server.
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

// Event listener for when the DOM content is loaded.
document.addEventListener('DOMContentLoaded', function() {
    // Get references to the form and input field.
    const form = document.getElementById('new_message_form');
    const inputField = form.querySelector('[name="message[content]"]'); // Adjust selector as needed
    // Event listener for form submission.
    form.addEventListener('submit', function(event) {
        event.preventDefault();

        // Get the trimmed content of the input field.
        const messageContent = inputField.value.trim();
        const messageContainer = document.getElementById('messages')
        // Check if the message content is not empty.
        if (messageContent !== '') {
            // Send the message to the server via the ChatChannel.
            chatChannel.send({ body: messageContent });
                // Display the sent message in the chat interface.
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
            // Clear the input field after sending the message.
            inputField.value = '';
            console.log("Data sent")
        }
    });
});
