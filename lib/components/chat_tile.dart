import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/screens/chat.dart';
import 'package:laber_app/state/bloc/chat_bloc.dart';
import 'package:laber_app/store/types/chat.dart';

class ChatTile extends StatelessWidget {
  final Chat chat;

  const ChatTile({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    final contact = chat.contact.value;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (context) {
                  return ChatBloc(contact!.apiId);
                },
                child: const ChatScreen(),
              );
            },
          ),
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
              // TODO use a placeholder image
              backgroundImage: NetworkImage(contact?.profilePicture ?? ''),
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
                          contact?.name ?? 'NO NAME',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Builder(builder: (context) {
                        final time = chat.latestMessage?.formattedLongTime;
                        if (time == null) {
                          return const SizedBox();
                        }
                        return Text(time);
                      }),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Builder(builder: (context) {
                    final preview = chat.latestMessage?.previewString;
                    if (preview == null) {
                      return const SizedBox();
                    }
                    return Text(preview,
                        overflow: TextOverflow.ellipsis, maxLines: 2);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
