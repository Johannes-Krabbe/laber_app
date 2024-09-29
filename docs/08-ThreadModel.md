# Threat Model
This document will list and explain potential threats for the app:

1. Fly.io
   The backend and the database are hosted on a server controlled by a third-party provider. If there is a malicious actor who has physical access to the server, they could access the complete user data.

2. Data mining
   There is no rate limit for pulling mass amounts of user data via the discovery endpoints.

3. Curve25519
   There is no sign that the Curve25519 is not secure, but if a security vulnerability were discovered, all chats and messages could be affected.

4. JWT tokens
   The JWT access tokens do not have an expiry date. If a malicious actor is able to discover one from a user, they would have full access to the account forever.

5. Local storage
   Although the JWT tokens are stored in the secure storage of the device, the shared secret keys are stored in an unencrypted database on the phone. If a malicious actor (e.g., an installed app) gained access to the application storage, they would not only be able to read all existing messages but also decrypt all following messages.

6. Insecure third-party libraries
   If the app uses outdated or vulnerable third-party libraries, it could introduce security vulnerabilities into the system.

7. Insufficient protection against brute force attacks
   There is no rate limit on the verify OTP endpoint. This means that a malicious actor would most likely be able to log in as any user if they tried enough OTPs.

Most of the described threats are fixable. I think 7. is the highest threat that needs to be fixed before releasing the app to a public userbase.
