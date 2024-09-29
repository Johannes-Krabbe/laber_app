# Laber App
This is the frontend repository for the Laber app, built using Flutter. The app is currently only tested and optimized for iOS.

## Prerequisites
Before you begin, ensure you have the following installed:
- [Flutter](https://flutter.dev/docs/get-started/install) (v3.x)
- [Xcode](https://developer.apple.com/xcode/) (latest version)

## Getting Started
Follow these steps to run the Laber app on an iOS simulator:
1. Install Flutter dependencies:
   ```
   flutter pub get
   ```
2. Open the iOS simulator:
   ```
   open -a Simulator
   ```
3. Run the app:
   ```
   flutter run
   ```
For more information, refer to the official [Flutter documentation](https://docs.flutter.dev/).

## Documentation
You can find all application-specific documentation in the `docs/` folder. It is recommended that you start with the [00-General.md](./docs/00-General.md) file to get a general understanding of the app and an overview of the documentation.

# License
This project incorporates code from [libsignal_protocol_dart](https://github.com/MixinNetwork/libsignal_protocol_dart), which is licensed under the GNU General Public License v3.0 (GPL-3.0).

## GPL-3.0 Licensed Code
Portions of this project use code from libsignal_protocol_dart, Copyright (c) MixinNetwork. This code is licensed under the GPL-3.0 license, a copy of which can be found at https://www.gnu.org/licenses/gpl-3.0.en.html.

The code copied is limited to the contents of the folder `laber_app/lib/utils/curve/xeddsa`.

As per the requirements of the GPL-3.0 license, any modifications or derivative works based on the libsignal_protocol_dart code must also be released under the GPL-3.0 license.

## Acknowledgment
We gratefully acknowledge the MixinNetwork team for their work on libsignal_protocol_dart.

## Your Rights and Responsibilities
As a user of this software, you have the right to use, modify, and distribute it under the terms of the GPL-3.0 license. However, if you choose to distribute this software or any derivative works, you must do so under the same license terms, including providing access to the source code.

For the full terms and conditions of the GPL-3.0 license, please refer to the [LICENSE](./LICENSE) file in this project or visit https://www.gnu.org/licenses/gpl-3.0.en.html.
