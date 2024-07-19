import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:laber_app/components/blur_background.dart';
import 'package:laber_app/state/bloc/contacts_bloc.dart';
import 'package:laber_app/state/types/contacts_state.dart';

class ChatScreen extends StatefulWidget {
  final String contactId;
  const ChatScreen({super.key, required this.contactId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  double renderedHeight = 0;
  late ContactsBloc contactsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contactsBloc = context.watch<ContactsBloc>();
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
        itemCount:
            contactsBloc.state.getById(widget.contactId)!.messages.length,
        itemBuilder: (context, index) {
          return MessageWidget(
            message: contactsBloc.state
                .getById(widget.contactId)!
                .sortedMessages[index],
            isMe: contactsBloc.state
                    .getById(widget.contactId)!
                    .sortedMessages[index]
                    .senderId !=
                contactsBloc.state.getById(widget.contactId)!.id,
          );
        },
      ),
      bottomNavigationBar: ChatInput(
          contactsBloc: contactsBloc,
          contact: contactsBloc.state.getById(widget.contactId)!),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageWidget({
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
          message.message,
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
  final ContactsBloc contactsBloc;
  final Contact contact;
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
  final Contact contact;

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
                backgroundImage: NetworkImage(contact.profilePicture),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      contact.name,
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
