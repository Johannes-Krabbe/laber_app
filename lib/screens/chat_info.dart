import 'package:flutter/material.dart';
import 'package:laber_app/components/blur_app_bar.dart';
import 'package:laber_app/store/types/chat.dart';


class ChatInfo extends StatefulWidget {
  final Chat chat;

  const ChatInfo({super.key, required this.chat});

  @override
  State<ChatInfo> createState() => _ChatInfoState();
}

class _ChatInfoState extends State<ChatInfo> {
  @override
  Widget build(BuildContext context) {
    var contact = widget.chat.contact.value;

    if (contact == null) {
      return const Scaffold(
        body: Center(
          child: Text('Contact not found'),
        ),
      );
    }

    return Scaffold(
      appBar: const BlurAppBar(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(contact.profilePicture ?? ''),
            ),
            const SizedBox(height: 10),
            Text(
              contact.name ?? 'NO NAME',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[900],
              ),
              child: Column(
                children: [
                  contact.phoneNumber?.isNotEmpty == true
                      ? InfoDisplay(name: 'Phone:', value: contact.phoneNumber!)
                      : const SizedBox(),
                  widget.chat.messages.isNotEmpty == true
                      ? InfoDisplay(
                          name: 'Raw Messages:',
                          value: widget.chat.messages.length.toString(),
                        )
                      : const SizedBox(),
                  InfoDisplay(
                    name: 'Devices:',
                    value: contact.status ?? 'NO STATUS',
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[900],
              ),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const Text(
                      "Devices",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...contact.deviceApiIds.map((deviceId) {
                      return Text(
                        deviceId,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoDisplay extends StatelessWidget {
  final String name;
  final String value;

  const InfoDisplay({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
