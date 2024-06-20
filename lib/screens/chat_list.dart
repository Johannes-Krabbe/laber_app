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
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              ),
              child: Column(
                children: [
                  SafeArea(
                    bottom: false,
                    child: Text(
                      "Chats",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: chatListItems,
      ),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
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
        "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png",
  ),
  ChatTile(
    name: "John Doe",
    message: "Hello, how are you?",
    time: "15:30",
    avatarUrl:
        "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png",
  )
];
