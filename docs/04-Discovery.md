# Discovery
This document explains when and how users are allowed to receive user data from other users via the API.

## Requirements
The goal of the user discovery protocol is to share as little information as possible with the server while maintaining high control over what people can find out about you.

One of the main assumptions of the discovery protocol is that most people know the mobile phone numbers of their friends and are most likely to create a chat based on the phone number.

## Public User Data
The public user data consists of the userId, name, username, and profile picture URL.

## Discovery by Phone Number
A goal for a future version might be to import all of your contacts from your system and check who has an account on Laber. 

In order to avoid sending the phone numbers of all your contacts to the server for privacy reasons, we create a hash of the phone number and send the first 5 characters of this hash to the server. The server then responds with the public user data for accounts that have a phone number hash starting with the provided characters.

When receiving the public user data in this way, it will include the hashed phone number as an extra property so the app can match the correct user to the phone number if multiple users are found.

## Discovery by Username (not implemented)
You can send a username to the server and receive the public user data.

## Post-Discovery Data Fetching
After a user is discovered, the userId is used to (re-)fetch the public user data from the server. This ensures that even if a user changes their phone number or username, the correct user data will always be received.
