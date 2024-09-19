import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:laber_app/components/blur_background.dart';
import 'package:laber_app/components/button.dart';
import 'package:laber_app/components/message/base_message_widget.dart';
import 'package:laber_app/components/profile_picture.dart';
import 'package:laber_app/isar.dart';
import 'package:laber_app/screens/chat_info.dart';
import 'package:laber_app/services/message_recieve_service.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:laber_app/state/bloc/chat_bloc.dart';
import 'package:laber_app/state/types/chat_state.dart';
import 'package:laber_app/store/types/chat.dart';
import 'package:laber_app/store/types/raw_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  double renderedHeight = 0;
  late ChatBloc chatBloc;
  late AuthBloc authBloc;

  StreamSubscription<void>? _messageSubscription;

  @override
  void initState() {
    super.initState();
    chatBloc = context.read<ChatBloc>();
    chatBloc.add(LoadChatEvent());

    _setupIsarListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chatBloc = context.watch<ChatBloc>();
    authBloc = context.watch<AuthBloc>();
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  void _setupIsarListener() async {
    final isar = await getIsar();
    _messageSubscription = isar.rawMessages.watchLazy().listen((_) {
      chatBloc.add(LoadChatEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (chatBloc.state.state == ChatStateEnum.loading ||
        chatBloc.state.state == ChatStateEnum.none) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Loading chat...'),
            ],
          ),
        ),
      );
    }

    if (chatBloc.state.state == ChatStateEnum.notCreated) {
      return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(IconoirIcons.infoCircle),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: Text(
                  'Before you can start messaging you need to initiate a chat with this contact.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Button(
                text: 'Create chat',
                onPressed: () {
                  chatBloc.add(CreateChatEvent());
                },
              ),
            ],
          ),
        ),
      );
    }

    if (chatBloc.state.state != ChatStateEnum.success) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error),
              const SizedBox(height: 10),
              Text(chatBloc.state.error ?? 'Error loading chat'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BlurBackground(
          child: ChatHead(chat: chatBloc.state.chat!),
        ),
      ),
      body: Builder(builder: (context) {
        final chat = chatBloc.state.chat!;
        if (chat.messages.isEmpty == true) {
          return const Center(child: Text('No messages'));
        }

        return ListView.builder(
            reverse: true,
            itemCount: chat.sortedParsedMessages.length,
            itemBuilder: (context, index) {
              return BaseMessageWidget(
                message: chat.sortedParsedMessages[index],
              );
            });
      }),

      /*
      body: ListView.builder(
        reverse: true,
        itemCount:
            contactsBloc.state.getById(widget.contactId)!.messages.length,
        itemBuilder: (context, index) {
          return MessageWidget(
            message: contactsBloc.state
                .getById(widget.contactId)!
                .sortedMessages[index],
          );
        },
      ),
      */
      bottomNavigationBar: ChatInput(
        chatBloc: chatBloc,
      ),
    );
  }
}

class ChatInput extends StatelessWidget {
  final ChatBloc chatBloc;
  final TextEditingController controller = TextEditingController();

  ChatInput({
    super.key,
    required this.chatBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlurBackground(
      child: SafeArea(
        top: false,
        child: Container(
          color: Colors.transparent,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    child: TextField(
                      controller: controller,
                      maxLines: 4,
                      minLines: 1,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (controller.text.isEmpty) {
                      return;
                    }
                    chatBloc.add(SendTextMessageEvent(controller.text));
                    controller.clear();
                  },
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatHead extends StatelessWidget {
  final Chat chat;

  const ChatHead({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).padding.top,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatInfo(
                  chat: chat,
                ),
              ),
            );
          },
          child: Container(
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
                ProfilePicture(
                    radius: 20, imageUrl: chat.contact.value?.profilePicture),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        chat.contact.value?.name ??
                            chat.contact.value?.name ??
                            'NO NAME',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () async {
                    await MessageRecieveService().processNew();
                  },
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
