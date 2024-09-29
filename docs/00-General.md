# General
Laber is a chat app that I (Johannes Krabbe) created in the scope of my final "Capstone Project" at the CODE University of Applied Sciences in Berlin.
The goal of this project was to create a usable chat app, similar to Signal or WhatsApp. This document will give you an overview of the technical documentation, including the software architecture decisions I made when creating this project.

## Project Structure
The project consists of two repositories: [laber_app](https://github.com/johannes-krabbe/laber_app) and [laber_api](https://github.com/johannes-krabbe/laber_api). `laber_app` is the frontend app written in Flutter, and `laber_api` is the backend written in TypeScript.
You can find instructions on how to run the project in the `README.md` of the respective projects.
You can find more information about the tech stack and the deployment here: [02-Techstack.md](02-Techstack.md).

## Capabilities
This is a list of capabilities of Laber:
- Create an account with a phone number
- Set username / display name for account
- Set settings for an account
- Create a device
- Add users to the local contact list
- Create a chat
- Message contacts
- Log in with a different device

# Documents
I would recommend reading the documents in the order they are numbered to get a full overview. 
- [01-Terminology.md](./01-Terminology.md)
- [02-Techstack.md](./02-Techstack.md)
- [03-Authentication.md](./03-Authentication.md)
- [04-Discovery.md](./04-Discovery.md)
- [05-KeyPairs.md](./05-KeyPairs.md)
- [06-KeyAgreement.md](./06-KeyAgreement.md)
- [07-Messaging.md](./07-Messaging.md)
- [08-ThreadModel.md](./08-ThreadModel.md)
