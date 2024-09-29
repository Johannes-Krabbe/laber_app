# Key Agreement
This document explains when and how parties agree on a shared secret that can be used to encrypt messages. The Key agreement protocol used in Laber is based on the [X3DH Key Agreement Protocol](https://signal.org/docs/specifications/x3dh/) from [Signal](https://signal.org). This document will partially quote from the Signal documentation.
You can find the implementation of the key agreement in the file `laber_app/lib/services/key_agreement_service.dart`.
This document discusses the Key agreement between two devices: `DEVICE 1` and `DEVICE 2`.

## Initialization
To start the key agreement, `DEVICE 1` fetches a key bundle from the server for `DEVICE 2`. This key bundle includes:
1. An Identity key (`D2_IK`) + its KeyId `D2_IK_ID`
2. A Signed pre-key (`D2_SPK`) + its KeyId `D2_SPK_ID`
3. (Optionally) A One-time pre-key (`D2_OPK`) + its KeyId `D2_OPK_ID`

After receiving the key bundle, `DEVICE 1` verifies the Signature of `D2_SPK`.
`DEVICE 1` then retrieves its own Identity key `D1_IK` from the secure storage together with its id `D1_IK_ID` and generates an ephemeral key pair `D1_EK_pub`, `D1_EK_priv`. 

If the bundle does not contain `D2_OPK`, `DEVICE 1` calculates:
```
DH1 = DH(D1_IK, D2_SPK)
DH2 = DH(D1_EK, D2_IK)
DH3 = DH(D1_EK, D2_SPK)
SK = KDF(DH1 || DH2 || DH3)
```

If the bundle *does* contain a one-time pre-key, the calculation is modified to include an additional *DH*:
```
DH4 = DH(D1_EK, D2_OPK)
SK = KDF(DH1 || DH2 || DH3 || DH4)
```

In addition to the Secret key, `DEVICE 1` calculates a safety number consisting of a concatenation of fingerprints of both Identity keys, starting with the `D2_IK`.

After that, `DEVICE 1` crafts the AgreementMessageData consisting of `D2_OPK_ID`, `D2_SPK_ID`, `D1_EK_pub`, `D1_ID`, and `U1_ID`. This message is then sent to the mailbox of `D2`.

## Receiving of the initialization message
When receiving the Initialization message from `D1`, `D2` can retrieve `D2_IK` as well as `D2_OPK` and `D2_SPK` based on `D2_OPK_ID` and `D2_SPK_ID` from its local store, and `D1_EK_pub` from the initialization message and `D1_IK` from the server.

With these keys and the same calculations shown above, `D2` can arrive at the same SK that `D1` previously calculated.

From this point onward, `D1` and `D2` can have an encrypted chat as described in [messaging.md]().


## Visualization
![image](https://raw.githubusercontent.com/Johannes-Krabbe/laber_app/refs/heads/main/docs/assets/KeyAgreement.png)
