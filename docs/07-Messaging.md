# Messaging
This document will explain how messages are sent out, received, and processed.

## Chat initialization
In order to create a chat, the user first needs to add a user to their local contact list. Receiving the user data is explained in [04-Discovery.md](./04-Discovery.md).

The discovery flow will not let the discovered user know anything about the initiating User or Device yet. The user who wants to start a chat first needs to press the "create chat" button. This will refetch the contact data, including the connected device IDs. The client will use this information to initiate a chat with every device individually, as explained in [07-Messaging.md](./07-Messaging.md).

After creating a secret for every device of the recipient user, the initiating user will refetch the meUser and check if there is a key for every self device. If not, it will start a key initialization with each self device.

## Message data
The message data is a deeply nested type. Each layer serves different purposes. 

The outer layer is called `API message` and represents the data that is stored in the Database on the API side. The properties of the `API message` are `messageData`, `apiSenderDeviceId`, and `apiRecipientDeviceId`. The Device IDs in the API message data are used for routing the message to the correct mailbox.

The `messageData` is of type `API message data`. The properties of this type are `encryptionContext`, `encryptedMessage`, and `type`. The type of the `encryptedMessage` depends on the value of the `type`. The type can be one of the following: `keyAgreement` or `applicationRawMessage`. If the type is `keyAgreement`, the `encryptedMessage` is the initiation message discussed in [06-KeyAgreement.md](./06-KeyAgreement.md). If the type is `applicationRawMessage`, the `encryptedMessage` is a base64 encoded Uint8Array. This Uint8Array is an encrypted JSON representation of type `RawMessage`. The encryption context has a version number, and the `nonceLength` and `macLength` needed for decrypting the message.

The `RawMessage` data type is the decrypted message that is stored in the local database on the phone. This data is used to display the messages in the chat app.

## Sending messages
Messages are encrypted with the ChaCha20-Poly1305 algorithm and the Secret key.
When a user wants to send a message to another user, the device encrypts the message for all devices of the recipient user and for all self devices. 

## Receiving messages
The client can manually fetch messages from the server. It will check the type of the message and either create a secret with the received message or decrypt the message and add it to an existing chat.
