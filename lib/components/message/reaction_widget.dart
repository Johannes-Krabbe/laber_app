import 'package:flutter/material.dart';
import 'package:laber_app/store/types/chat.dart';

class ReactionWidget extends StatelessWidget {
  final ClientParsedMessage message;

  const ReactionWidget({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          width:
              (message.reactions.length <= 15 ? message.reactions.length : 15) *
                      20 +
                  10,
          height: 20,
          margin: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                width: 1, color: Theme.of(context).colorScheme.surface),
          ),
        ),
        Positioned(
          top: -1.5,
          left: 7.5,
          child: Row(
            children: [
              for (var reaction in message.reactions.take(16))
                Text(
                  reaction.emoji,
                  style: const TextStyle(
                    textBaseline: TextBaseline.ideographic,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
