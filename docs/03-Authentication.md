# Authentication
This Document will explain how a user can authenticate themselves for interacting with the API.

## Creating an account
When starting the App for the first time the user can enter their phone number to receive an One Time Password (OTP) via SMS.
When receiving the phone number the server parses it into a uniform format and creates a new user entity in the database if there is no user with this phone number. The server then sends out a 6 digit OTP which can then be traded in, together with the according phone number for a JWT token.
The User now successfully created an account on the server.

Since the user should never be logged out the JWT token is valid forever.

## Logging into an existing account
Logging into an existing account works the same way as creating an account with the key difference being that no new account will be created.

## Onboarding flow
If the user does not have a `name` property they will be forced to run through the onboarding flow on the app side to set properties like `username` and `name`, and to set their security preferences.
Security preferences are currently limited to their discoverability settings (discussed in [discovery.md]())

## Creating a device
As the last step of the Signup/Login flow the user always needs to create a new device by entering a device name. When submitting the device name the app will create one Identity Key, one Signed Pre Key and a set of ten onetime pre keys for this device and post the name together with the public keys to the server. If the device could be created successfully the app will save the private keys together with the key ID's provided from the backend.
You will find more information about key generation and handling in other documents.

## Improvements
There are several improvements could be made to create a more secure authentication process. I will explain them here and implement them in the Future.

### Refresh / Access Token
One current point of weakness is the use of only one long lived Access token without refresh token. If a malicious actor discovers this token they are able to do anything in the name of the user forever. Implementing a basic system with refresh and access tokens, would help the user to maintain in control of the access to their account.

### Include Device ID in the JWT
The only information currently stored in the JWT token is the user id. When sending messages the app provides their own device id in the json payload when necessary. This enables a malicious person to send and receive messages from any device even if they just discover one JWT token from one device.
This was implemented like this, because creating a device also requires an request Authenticated with an JWT token. 
To solve this issue one could create a short lived JWT token that only gets used after signup / login and before creating a device and which cant be used to send messages. The user will receive this token and use it to go through the onboarding flow and then finally, trade it in for an UserDevice JWT token after creating their device.
