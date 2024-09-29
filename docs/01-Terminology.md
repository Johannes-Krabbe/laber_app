# Terminology 
This document explains different project-specific terms used throughout the entire documentation.

## User
A user represents a human in the real world. It is used in the backend to store information like `phoneNumber`, `username`, `createdAt`, etc. 
A user has an ID which can't change and always uniquely identifies the user. The `username` and `phoneNumber` of a user are also unique but can be changed anytime.

### Me user
The me user is the user data on the device of the currently logged-in user.

## Device
A device represents a phone in the real world. A user can have multiple devices, but a device can only be owned by one user. A device has an ID which can't change and always uniquely identifies the device.

### Me device
The me device describes the device that is currently logged in.

### Self device
Self devices are all devices of the me user.

## Contact
A contact is a representation of a user on a different user's device. It is stored locally on a user's device.

## Key pair
A key pair is an X25519 key pair. The private key never leaves the device it was created on. When publishing a public key to the server, the server will assign a unique ID to it that can be used to identify the key pair everywhere.

## Device shared secret
A device shared secret is a secret key that is only known by two devices and used to encrypt messages between these two devices.

## Mailbox
A mailbox is an entity on the server that contains all messages that were sent to the server for a specific device that were not fetched by the receiving device and therefore not deleted.
