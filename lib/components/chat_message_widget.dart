import 'package:flutter/material.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/store/types/chat.dart';

class MessageWidget extends StatefulWidget {
  final ClientParsedMessage message;

  const MessageWidget({
    required this.message,
    super.key,
  });

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.message.type == ParsedMessageTypes.textMessage) {
      return TextMessageWidget(message: widget.message);
    }

    return Text(
        "NOT IMPLEMENTED MESSAGE TYPE : ${widget.message.type.toString()}");
  }
}

class TextMessageWidget extends StatefulWidget {
  final ClientParsedMessage message;

  const TextMessageWidget({
    required this.message,
    super.key,
  });

  @override
  State<TextMessageWidget> createState() => _TextMessageWidgetState();
}

class _TextMessageWidgetState extends State<TextMessageWidget> {
  late AuthBloc authBloc;
  late bool isMe;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authBloc = context.read<AuthBloc>();
    isMe = authBloc.state.meUser?.id == widget.message.senderUserId;
  }

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
      child: Stack(
        children: [
          Container(
            padding: widget.message.reactions.isNotEmpty
                ? const EdgeInsets.only(bottom: 10)
                : const EdgeInsets.only(bottom: 0),
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.85,
                  minWidth: ((widget.message.reactions.length <= 15
                              ? widget.message.reactions.length
                              : 15) *
                          20 +
                      10)),
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: isMe
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[900],
              ),
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 10),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                widget.message.text,
                softWrap: true,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (widget.message.reactions.isNotEmpty)
            Positioned(
              bottom: 0,
              left: isMe ? 20 : null,
              right: isMe ? null : 20,
              child: ReactionWidget(
                message: widget.message,
              ),
            )
        ],
      ),
    );
  }
}

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
