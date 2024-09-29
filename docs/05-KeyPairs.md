# Key pairs
This document explains how key pairs are generated, how they are stored, and what they are used for.

## Curve
Laber uses Curve25519 to generate X25519 key pairs. X25519 is designed for use in Diffie-Hellman operations but can also be used for signing payloads with the help of [XEdDSA](https://signal.org/docs/specifications/xeddsa/). 

I copied the code for XEdDSA from [libsignal_protocol_dart](https://github.com/MixinNetwork/libsignal_protocol_dart), a library that implements the Signal protocol. The code that I copied is limited to the folder `laber_app/lib/utils/curve/xeddsa`.

## Creation of key pairs
When creating a device, the app generates three types of key pairs:
- One Device Identity key pair
- One Device Signed pre-key (the public key is signed with the identity private key)
- A set of one-time pre-key pairs

When publishing the public keys of these key pairs to the server, the database generates a unique ID for each key pair and returns it to the device. The device then stores the private keys together with the unique IDs on the device.

The device does not need to store the public keys, since they can be derived from the private key at any time.

For every Key agreement that is initialized by another device for this device, one one-time pre-key is used and deleted from the server. This means that if the server is "running low" on one-time pre-keys, the client needs to provide newly generated ones. Providing the server with new one-time pre-keys should happen automatically without any user input, but is currently not implemented.

The last type of key pair that is generated is an ephemeral key pair, which is created when initializing a new chat. More information about that can be found in [06-KeyAgreement.md](./06-KeyAgreement.md).

## Chat Device Secret Keys
In Laber, one key is always only used to encrypt messages between two devices. The number of keys used in one chat `nKeys` can be calculated with the number of devices `nDevices` that are part of the chat like this: 

```
nKeys = (nDevices * (nDevices - 1)) / 2
```

For example:
- With 2 devices, there is one key: (2 * (2-1)) / 2 = 1
- With 3 devices, there are three keys: (3 * (3-1)) / 2 = 3
- With 4 devices, there are six keys: (4 * (4-1)) / 2 = 6

Keys that are used for encrypting messages sent from one device to another, where the user owns both devices, will be reused among different chats.
