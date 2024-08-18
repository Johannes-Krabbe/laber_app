import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:laber_app/components/blur_background.dart';
import 'package:laber_app/components/chat_message_widget.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:laber_app/state/bloc/contacts_bloc.dart';
import 'package:laber_app/types/client_contact.dart';
import 'package:laber_app/types/client_message.dart';

class ChatScreen extends StatefulWidget {
  final String contactId;
  const ChatScreen({super.key, required this.contactId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  double renderedHeight = 0;
  late ContactsBloc contactsBloc;
  late AuthBloc authBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contactsBloc = context.watch<ContactsBloc>();
    authBloc = context.watch<AuthBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BlurBackground(
          child:
              ChatHead(contact: contactsBloc.state.getById(widget.contactId)!),
        ),
      ),
      body: ListView.builder(
          reverse: true,
          itemCount: 2,
          itemBuilder: (context, index) {
            return MessageWidget(
              message: ClientParsedMessage(
                id: "id",
                unixTime: 12345,
                type: ParsedMessageTypes.textMessage,
                userId:
                    index == 0 ? (authBloc.state.meUser?.id ?? '123') : '123',
                content:
                    "TEST with index asd adsf   asdf asdf asdf asd f : $index",
                reactions: [
                  ClientReaction(
                    emoji: "🚀",
                    userId: contactsBloc.state.getById(widget.contactId)?.id ??
                        "123",
                    unixTime: 12345567,
                  ),
                ],
                relatedMessageIds: ["id"],
              ),
            );
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
          contactsBloc: contactsBloc,
          contact: contactsBloc.state.getById(widget.contactId)!),
    );
  }
}

class ChatInput extends StatelessWidget {
  final ContactsBloc contactsBloc;
  final ClientContact contact;
  final TextEditingController controller = TextEditingController();

  ChatInput({
    super.key,
    required this.contactsBloc,
    required this.contact,
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
                    contactsBloc.add(
                        SendMessageContactsEvent(contact.id, controller.text));
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
  final ClientContact contact;

  const ChatHead({
    required this.contact,
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
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(contact.profilePicture ?? ''),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      contact.name ?? contact.phoneNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    // TODO add last seen
                    const Text('Active now'),
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
