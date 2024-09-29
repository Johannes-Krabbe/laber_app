# Authentication
This document will explain how a user can authenticate themselves for interacting with the API.

## Creating an account
When starting the app for the first time, the user can enter their phone number to receive a One-Time Password (OTP) via SMS.

When receiving the phone number, the server parses it into a uniform format and creates a new user entity in the database if there is no user with this phone number. The server then sends out a 6-digit OTP which can be traded in, together with the corresponding phone number, for a JWT token.

The user has now successfully created an account on the server.

Since the user should never be logged out, the JWT token is valid forever. (This is not ideal, as explained below in the Improvements section)

## Logging into an existing account
Logging into an existing account works the same way as creating an account, with the key difference being that no new account will be created.

## Onboarding flow
If the user does not have a `name` property, they will be forced to run through the onboarding flow on the app side to set properties like `username` and `name`, and to set their security preferences.

The security preferences currently allow the user to choose if they want to be discovered by phone number or username (both or neither is also valid).

## Creating a device
As the last step of the Signup/Login flow, the user always needs to create a new device by entering a device name. When submitting the device name, the app will create one Identity Key, one Signed Pre Key, and a set of ten one-time pre keys for this device and post the name together with the public keys to the server. If the device was created successfully, the app will save the private keys together with the key IDs provided from the backend.

You will find more information about key generation and handling in [05-KeyHandling.md](./05-KeyHandling.md).

## Improvements
Several improvements could be made to create a more secure authentication process. I will explain them here and implement them in the future.

### Refresh / Access Token
One current point of weakness is the use of only one long-lived access token without a refresh token. If a malicious actor discovers this token, they are able to do anything in the name of the user forever. Implementing a basic system with refresh and access tokens would help the user maintain control of access to their account.

### Include Device ID in the JWT
The only information currently stored in the JWT token is the user ID. When sending messages, the app provides its own device ID in the JSON payload when necessary. This enables a malicious person to send and receive messages from any device even if they just discover one JWT token from one device.

This was implemented like this because creating a device also requires a request authenticated with a JWT token. 

To solve this issue, one could create a short-lived JWT token that only gets used after signup/login and before creating a device, which can't be used to send messages. The user will receive this token and use it to go through the onboarding flow, and then finally, trade it in for a UserDevice JWT token after creating their device.
