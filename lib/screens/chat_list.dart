import 'package:laber_app/components/chat_tile.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ListView(
              children: chatListItems,
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -10,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.5),
                    ),
                    child: BottomNavigationBar(
                      currentIndex: 0,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.chat),
                          label: 'Chat',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.people_alt),
                          label: 'Contacts',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.settings),
                          label: 'Settings',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

var chatListItems = const <Widget>[
  ChatTile(
    name: "John Doe",
    message:
        "Hello, how are you? Hello, how are you? Hello, how are you? Hello, how are you? Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://storage.googleapis.com/pfpai/styles/574c62e5-0c3d-4e31-b49d-d9a4c8b07bc9.png?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=headshotpro-backend-production@stockai-362303.iam.gserviceaccount.com/20240606/auto/storage/goog4_request&X-Goog-Date=20240606T020118Z&X-Goog-Expires=518400&X-Goog-SignedHeaders=host&X-Goog-Signature=99b7440c3cdb369961dd20b15c8dc4d280a7ceb91ea24ab153b08a7938e03c35da316f860c2a37cf94ec35b1b4d00db8cb34869b18b06e9d6618c5a0bed62371c9ff6e9253f1284ba5f624e1451b3ca1edc25e3b217e98df33dd904525397f7fec7c4fc6c0bbeb8f5d2aa85a006602df4098681c45f80e427929f895d5a8c7b84353ba81550516068058e50171106c9931becf448109f7dd979f8a96e5eb78a3f1fb227d8965f44bc28add8ee4dc54fe6dc9c730e931d13629b1134879e130d9f7a011c66b1259306abbc1bc43cf27d5690be63b60902aa3605ecd7eb7d3850f15c683ba8b1e27b49251707980eaba3ae710650ce124be1c3e761e823cd7a83b",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://storage.googleapis.com/pfpai/styles/574c62e5-0c3d-4e31-b49d-d9a4c8b07bc9.png?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=headshotpro-backend-production@stockai-362303.iam.gserviceaccount.com/20240606/auto/storage/goog4_request&X-Goog-Date=20240606T020118Z&X-Goog-Expires=518400&X-Goog-SignedHeaders=host&X-Goog-Signature=99b7440c3cdb369961dd20b15c8dc4d280a7ceb91ea24ab153b08a7938e03c35da316f860c2a37cf94ec35b1b4d00db8cb34869b18b06e9d6618c5a0bed62371c9ff6e9253f1284ba5f624e1451b3ca1edc25e3b217e98df33dd904525397f7fec7c4fc6c0bbeb8f5d2aa85a006602df4098681c45f80e427929f895d5a8c7b84353ba81550516068058e50171106c9931becf448109f7dd979f8a96e5eb78a3f1fb227d8965f44bc28add8ee4dc54fe6dc9c730e931d13629b1134879e130d9f7a011c66b1259306abbc1bc43cf27d5690be63b60902aa3605ecd7eb7d3850f15c683ba8b1e27b49251707980eaba3ae710650ce124be1c3e761e823cd7a83b",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://storage.googleapis.com/pfpai/styles/574c62e5-0c3d-4e31-b49d-d9a4c8b07bc9.png?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=headshotpro-backend-production@stockai-362303.iam.gserviceaccount.com/20240606/auto/storage/goog4_request&X-Goog-Date=20240606T020118Z&X-Goog-Expires=518400&X-Goog-SignedHeaders=host&X-Goog-Signature=99b7440c3cdb369961dd20b15c8dc4d280a7ceb91ea24ab153b08a7938e03c35da316f860c2a37cf94ec35b1b4d00db8cb34869b18b06e9d6618c5a0bed62371c9ff6e9253f1284ba5f624e1451b3ca1edc25e3b217e98df33dd904525397f7fec7c4fc6c0bbeb8f5d2aa85a006602df4098681c45f80e427929f895d5a8c7b84353ba81550516068058e50171106c9931becf448109f7dd979f8a96e5eb78a3f1fb227d8965f44bc28add8ee4dc54fe6dc9c730e931d13629b1134879e130d9f7a011c66b1259306abbc1bc43cf27d5690be63b60902aa3605ecd7eb7d3850f15c683ba8b1e27b49251707980eaba3ae710650ce124be1c3e761e823cd7a83b",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://storage.googleapis.com/pfpai/styles/574c62e5-0c3d-4e31-b49d-d9a4c8b07bc9.png?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=headshotpro-backend-production@stockai-362303.iam.gserviceaccount.com/20240606/auto/storage/goog4_request&X-Goog-Date=20240606T020118Z&X-Goog-Expires=518400&X-Goog-SignedHeaders=host&X-Goog-Signature=99b7440c3cdb369961dd20b15c8dc4d280a7ceb91ea24ab153b08a7938e03c35da316f860c2a37cf94ec35b1b4d00db8cb34869b18b06e9d6618c5a0bed62371c9ff6e9253f1284ba5f624e1451b3ca1edc25e3b217e98df33dd904525397f7fec7c4fc6c0bbeb8f5d2aa85a006602df4098681c45f80e427929f895d5a8c7b84353ba81550516068058e50171106c9931becf448109f7dd979f8a96e5eb78a3f1fb227d8965f44bc28add8ee4dc54fe6dc9c730e931d13629b1134879e130d9f7a011c66b1259306abbc1bc43cf27d5690be63b60902aa3605ecd7eb7d3850f15c683ba8b1e27b49251707980eaba3ae710650ce124be1c3e761e823cd7a83b",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://storage.googleapis.com/pfpai/styles/574c62e5-0c3d-4e31-b49d-d9a4c8b07bc9.png?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=headshotpro-backend-production@stockai-362303.iam.gserviceaccount.com/20240606/auto/storage/goog4_request&X-Goog-Date=20240606T020118Z&X-Goog-Expires=518400&X-Goog-SignedHeaders=host&X-Goog-Signature=99b7440c3cdb369961dd20b15c8dc4d280a7ceb91ea24ab153b08a7938e03c35da316f860c2a37cf94ec35b1b4d00db8cb34869b18b06e9d6618c5a0bed62371c9ff6e9253f1284ba5f624e1451b3ca1edc25e3b217e98df33dd904525397f7fec7c4fc6c0bbeb8f5d2aa85a006602df4098681c45f80e427929f895d5a8c7b84353ba81550516068058e50171106c9931becf448109f7dd979f8a96e5eb78a3f1fb227d8965f44bc28add8ee4dc54fe6dc9c730e931d13629b1134879e130d9f7a011c66b1259306abbc1bc43cf27d5690be63b60902aa3605ecd7eb7d3850f15c683ba8b1e27b49251707980eaba3ae710650ce124be1c3e761e823cd7a83b",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://storage.googleapis.com/pfpai/styles/574c62e5-0c3d-4e31-b49d-d9a4c8b07bc9.png?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=headshotpro-backend-production@stockai-362303.iam.gserviceaccount.com/20240606/auto/storage/goog4_request&X-Goog-Date=20240606T020118Z&X-Goog-Expires=518400&X-Goog-SignedHeaders=host&X-Goog-Signature=99b7440c3cdb369961dd20b15c8dc4d280a7ceb91ea24ab153b08a7938e03c35da316f860c2a37cf94ec35b1b4d00db8cb34869b18b06e9d6618c5a0bed62371c9ff6e9253f1284ba5f624e1451b3ca1edc25e3b217e98df33dd904525397f7fec7c4fc6c0bbeb8f5d2aa85a006602df4098681c45f80e427929f895d5a8c7b84353ba81550516068058e50171106c9931becf448109f7dd979f8a96e5eb78a3f1fb227d8965f44bc28add8ee4dc54fe6dc9c730e931d13629b1134879e130d9f7a011c66b1259306abbc1bc43cf27d5690be63b60902aa3605ecd7eb7d3850f15c683ba8b1e27b49251707980eaba3ae710650ce124be1c3e761e823cd7a83b",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://storage.googleapis.com/pfpai/styles/574c62e5-0c3d-4e31-b49d-d9a4c8b07bc9.png?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=headshotpro-backend-production@stockai-362303.iam.gserviceaccount.com/20240606/auto/storage/goog4_request&X-Goog-Date=20240606T020118Z&X-Goog-Expires=518400&X-Goog-SignedHeaders=host&X-Goog-Signature=99b7440c3cdb369961dd20b15c8dc4d280a7ceb91ea24ab153b08a7938e03c35da316f860c2a37cf94ec35b1b4d00db8cb34869b18b06e9d6618c5a0bed62371c9ff6e9253f1284ba5f624e1451b3ca1edc25e3b217e98df33dd904525397f7fec7c4fc6c0bbeb8f5d2aa85a006602df4098681c45f80e427929f895d5a8c7b84353ba81550516068058e50171106c9931becf448109f7dd979f8a96e5eb78a3f1fb227d8965f44bc28add8ee4dc54fe6dc9c730e931d13629b1134879e130d9f7a011c66b1259306abbc1bc43cf27d5690be63b60902aa3605ecd7eb7d3850f15c683ba8b1e27b49251707980eaba3ae710650ce124be1c3e761e823cd7a83b",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://storage.googleapis.com/pfpai/styles/574c62e5-0c3d-4e31-b49d-d9a4c8b07bc9.png?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=headshotpro-backend-production@stockai-362303.iam.gserviceaccount.com/20240606/auto/storage/goog4_request&X-Goog-Date=20240606T020118Z&X-Goog-Expires=518400&X-Goog-SignedHeaders=host&X-Goog-Signature=99b7440c3cdb369961dd20b15c8dc4d280a7ceb91ea24ab153b08a7938e03c35da316f860c2a37cf94ec35b1b4d00db8cb34869b18b06e9d6618c5a0bed62371c9ff6e9253f1284ba5f624e1451b3ca1edc25e3b217e98df33dd904525397f7fec7c4fc6c0bbeb8f5d2aa85a006602df4098681c45f80e427929f895d5a8c7b84353ba81550516068058e50171106c9931becf448109f7dd979f8a96e5eb78a3f1fb227d8965f44bc28add8ee4dc54fe6dc9c730e931d13629b1134879e130d9f7a011c66b1259306abbc1bc43cf27d5690be63b60902aa3605ecd7eb7d3850f15c683ba8b1e27b49251707980eaba3ae710650ce124be1c3e761e823cd7a83b",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://storage.googleapis.com/pfpai/styles/574c62e5-0c3d-4e31-b49d-d9a4c8b07bc9.png?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=headshotpro-backend-production@stockai-362303.iam.gserviceaccount.com/20240606/auto/storage/goog4_request&X-Goog-Date=20240606T020118Z&X-Goog-Expires=518400&X-Goog-SignedHeaders=host&X-Goog-Signature=99b7440c3cdb369961dd20b15c8dc4d280a7ceb91ea24ab153b08a7938e03c35da316f860c2a37cf94ec35b1b4d00db8cb34869b18b06e9d6618c5a0bed62371c9ff6e9253f1284ba5f624e1451b3ca1edc25e3b217e98df33dd904525397f7fec7c4fc6c0bbeb8f5d2aa85a006602df4098681c45f80e427929f895d5a8c7b84353ba81550516068058e50171106c9931becf448109f7dd979f8a96e5eb78a3f1fb227d8965f44bc28add8ee4dc54fe6dc9c730e931d13629b1134879e130d9f7a011c66b1259306abbc1bc43cf27d5690be63b60902aa3605ecd7eb7d3850f15c683ba8b1e27b49251707980eaba3ae710650ce124be1c3e761e823cd7a83b",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://storage.googleapis.com/pfpai/styles/574c62e5-0c3d-4e31-b49d-d9a4c8b07bc9.png?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=headshotpro-backend-production@stockai-362303.iam.gserviceaccount.com/20240606/auto/storage/goog4_request&X-Goog-Date=20240606T020118Z&X-Goog-Expires=518400&X-Goog-SignedHeaders=host&X-Goog-Signature=99b7440c3cdb369961dd20b15c8dc4d280a7ceb91ea24ab153b08a7938e03c35da316f860c2a37cf94ec35b1b4d00db8cb34869b18b06e9d6618c5a0bed62371c9ff6e9253f1284ba5f624e1451b3ca1edc25e3b217e98df33dd904525397f7fec7c4fc6c0bbeb8f5d2aa85a006602df4098681c45f80e427929f895d5a8c7b84353ba81550516068058e50171106c9931becf448109f7dd979f8a96e5eb78a3f1fb227d8965f44bc28add8ee4dc54fe6dc9c730e931d13629b1134879e130d9f7a011c66b1259306abbc1bc43cf27d5690be63b60902aa3605ecd7eb7d3850f15c683ba8b1e27b49251707980eaba3ae710650ce124be1c3e761e823cd7a83b",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://storage.googleapis.com/pfpai/styles/574c62e5-0c3d-4e31-b49d-d9a4c8b07bc9.png?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=headshotpro-backend-production@stockai-362303.iam.gserviceaccount.com/20240606/auto/storage/goog4_request&X-Goog-Date=20240606T020118Z&X-Goog-Expires=518400&X-Goog-SignedHeaders=host&X-Goog-Signature=99b7440c3cdb369961dd20b15c8dc4d280a7ceb91ea24ab153b08a7938e03c35da316f860c2a37cf94ec35b1b4d00db8cb34869b18b06e9d6618c5a0bed62371c9ff6e9253f1284ba5f624e1451b3ca1edc25e3b217e98df33dd904525397f7fec7c4fc6c0bbeb8f5d2aa85a006602df4098681c45f80e427929f895d5a8c7b84353ba81550516068058e50171106c9931becf448109f7dd979f8a96e5eb78a3f1fb227d8965f44bc28add8ee4dc54fe6dc9c730e931d13629b1134879e130d9f7a011c66b1259306abbc1bc43cf27d5690be63b60902aa3605ecd7eb7d3850f15c683ba8b1e27b49251707980eaba3ae710650ce124be1c3e761e823cd7a83b",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://storage.googleapis.com/pfpai/styles/574c62e5-0c3d-4e31-b49d-d9a4c8b07bc9.png?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=headshotpro-backend-production@stockai-362303.iam.gserviceaccount.com/20240606/auto/storage/goog4_request&X-Goog-Date=20240606T020118Z&X-Goog-Expires=518400&X-Goog-SignedHeaders=host&X-Goog-Signature=99b7440c3cdb369961dd20b15c8dc4d280a7ceb91ea24ab153b08a7938e03c35da316f860c2a37cf94ec35b1b4d00db8cb34869b18b06e9d6618c5a0bed62371c9ff6e9253f1284ba5f624e1451b3ca1edc25e3b217e98df33dd904525397f7fec7c4fc6c0bbeb8f5d2aa85a006602df4098681c45f80e427929f895d5a8c7b84353ba81550516068058e50171106c9931becf448109f7dd979f8a96e5eb78a3f1fb227d8965f44bc28add8ee4dc54fe6dc9c730e931d13629b1134879e130d9f7a011c66b1259306abbc1bc43cf27d5690be63b60902aa3605ecd7eb7d3850f15c683ba8b1e27b49251707980eaba3ae710650ce124be1c3e761e823cd7a83b",
  )
];
