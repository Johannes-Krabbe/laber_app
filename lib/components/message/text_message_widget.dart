import 'package:flutter/material.dart';
import 'package:laber_app/components/message/reaction_widget.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/store/types/chat.dart';


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
