import 'package:flutter/material.dart';
import 'package:laber_app/screens/chat.dart';
import 'package:laber_app/types/client_contact.dart';

class ChatTile extends StatelessWidget {
  final ClientContact contact;
  final String? message;
  final String? time;

  const ChatTile({
    super.key,
    required this.contact,
    this.message,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ChatScreen(
            contactId: contact.id,
          )),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        // set a color for the gesture detector to work
        color: Colors.transparent,
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(contact.profilePicture ?? ''),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          contact.name ?? 'NO NAME',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Builder(
                        builder: (context) {
                          if(time == null) {
                            return const SizedBox();
                          }
                          return Text(time!);
                        }
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Builder(
                    builder: (context) {
                      if(message == null) {
                        return const SizedBox();
                      }
                      return Text(message!, overflow: TextOverflow.ellipsis, maxLines: 2);
                    }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
