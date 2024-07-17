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
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              ),
              child: const ChatHead(),
            ),
          ),
        ),
      ),
      body: ListView(
        reverse: true,
        children: const [
          Message(
            isMe: true,
            message: 'Hello Hello Hello Hello Hello HelloHello aaaaa',
          ),
          Message(
            isMe: true,
            message: 'Hello Hello Hello Hello Hello HelloHello aaaaa',
          ),
          Message(
            isMe: true,
            message: 'Hello Hello Hello Hello Hello HelloHello aaaaa',
          ),
          Message(
            isMe: true,
            message: 'Hello Hello Hello Hello Hello HelloHello aaaaa',
          ),
          Message(
            isMe: true,
            message: 'Hello Hello Hello Hello Hello HelloHello aaaaa',
          ),
          Message(
            isMe: true,
            message: 'Hello Hello Hello Hello Hello HelloHello aaaaa',
          ),
          Message(
            isMe: true,
            message: 'Hello Hello Hello Hello Hello HelloHello aaaaa',
          ),
          Message(
            isMe: true,
            message: 'Hello Hello Hello Hello Hello HelloHello aaaaa',
          ),
          Message(
            isMe: true,
            message: 'Hello Hello Hello Hello Hello HelloHello aaaaa',
          ),
          Message(
            isMe: true,
            message: 'Hello Hello Hello Hello Hello HelloHello aaaaa',
          ),
          Message(
            isMe: true,
            message: 'Hello Hello Hello Hello Hello HelloHello aaaaa',
          ),
          Message(
            isMe: true,
            message: 'Hello Hello Hello Hello Hello HelloHello aaaaa',
          ),
        ],
      ),
      bottomNavigationBar: AnimatedSize(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 100),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    'https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png'),
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
