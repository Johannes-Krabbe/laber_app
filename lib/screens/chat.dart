import 'dart:ui';

import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  double renderedHeight = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView(
                  reverse: true,
                  children: [
                    AnimatedSize(
                      curve: Curves.easeIn,
                      duration: const Duration(milliseconds: 100),
                      child: SizedBox(
                          height:
                              renderedHeight < 20 ? 20 : renderedHeight - 20),
                    ),
                    const Message(
                      isMe: true,
                      message: 'Hello',
                    ),
                    const Message(
                      isMe: false,
                      message:
                          'Hellosdf asd asd;lfkHello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello ',
                    ),
                    const Message(
                      isMe: true,
                      message: 'Hello Hello Hello Hello Hello HelloHello aaaaa',
                    ),
                    const Message(
                      isMe: false,
                      message:
                          'Hellosdf asd asd;lfkHello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello ',
                    ),
                    const Message(
                      isMe: true,
                      message: 'Hello Hello Hello Hello Hello HelloHello aaaaa',
                    ),
                    const Message(
                      isMe: true,
                      message: 'Hello',
                    ),
                    const Message(
                      isMe: false,
                      message:
                          'Hellosdf asd asd;lfkHello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello ',
                    ),
                    const Message(
                      isMe: true,
                      message: 'Hello Hello Hello Hello Hello HelloHello aaaaa',
                    ),
                    const Message(
                      isMe: false,
                      message:
                          'Hellosdf asd asd;lfkHello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello ',
                    ),
                    const Message(
                      isMe: true,
                      message: 'Hello Hello Hello Hello Hello HelloHello aaaaa',
                    ),
                    const SizedBox(height: 250),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(0.5),
                  ),
                  child: const ChatHead(),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(0.5),
                  ),
                  child: AnimatedSize(
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 100),
                    child: Builder(
                      builder: (context) {
                        return NotificationListener(
                          onNotification: (notification) {
                            if (notification is ScrollMetricsNotification) {
                              if (context.size!.height != renderedHeight) {
                                setState(() {
                                  renderedHeight = context.size!.height;
                                });
                              }
                            }
                            return true;
                          },
                          child: const ChatInput(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String message;
  final bool isMe;

  const Message({
    required this.message,
    required this.isMe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = isMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color:
              isMe ? Theme.of(context).colorScheme.primary : Colors.grey[900],
        ),
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Text(
          message,
          softWrap: true,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class ChatInput extends StatelessWidget {
  const ChatInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const TextField(
                    maxLines: 4,
                    minLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {},
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatHead extends StatelessWidget {
  const ChatHead({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).padding.top,
        ),
        Container(
          color: Colors.transparent,
          height: 56,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(width: 10),
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    'https://storage.googleapis.com/pfpai/styles/574c62e5-0c3d-4e31-b49d-d9a4c8b07bc9.png?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=headshotpro-backend-production@stockai-362303.iam.gserviceaccount.com/20240606/auto/storage/goog4_request&X-Goog-Date=20240606T020118Z&X-Goog-Expires=518400&X-Goog-SignedHeaders=host&X-Goog-Signature=99b7440c3cdb369961dd20b15c8dc4d280a7ceb91ea24ab153b08a7938e03c35da316f860c2a37cf94ec35b1b4d00db8cb34869b18b06e9d6618c5a0bed62371c9ff6e9253f1284ba5f624e1451b3ca1edc25e3b217e98df33dd904525397f7fec7c4fc6c0bbeb8f5d2aa85a006602df4098681c45f80e427929f895d5a8c7b84353ba81550516068058e50171106c9931becf448109f7dd979f8a96e5eb78a3f1fb227d8965f44bc28add8ee4dc54fe6dc9c730e931d13629b1134879e130d9f7a011c66b1259306abbc1bc43cf27d5690be63b60902aa3605ecd7eb7d3850f15c683ba8b1e27b49251707980eaba3ae710650ce124be1c3e761e823cd7a83b'),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text('Active now'),
                  ],
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }
}
