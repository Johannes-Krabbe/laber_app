# Discovery

This document explains how when and how users are allowed to receive what kind of user data from other users from the api.

## Requirements
The goal of the user discovery protocol is to share as little information as possible to the server and having high control over what people can find out about you.
One of the main assumptions of the discovery protocol is that most people know the mobile phone numbers of their friends and are most likely to create a chat based on the phone number.

## Public user data
The public user data consists of the userId, name, username and profile picture url.
## Discovery by phone number
A goal for a future version might be to import all of your contacts from your system and check who has an account on Laber. 
In order to not send the phone numbers of all your contacts to the server, for privacy reasons, we create a hash of the phone number and send the first 5 characters of this hash to the server. The server then responds with the public user data that have a phone number hash that starts with the provided characters.
When receiving the public user data in this way it will include the hashed phone number as an extra property so the app can match the correct user to the phone number if multiple users are found.

## Discovery by username (not implemented)
You can send a username to the server and receive the public user data.

## Post discovery data fetching
After a user gets discovered from now on, the userid is used to (re-) fetch the public user data from the server. This ensures that even if a user changes their phone number or username, the correct userdata will always be received.
