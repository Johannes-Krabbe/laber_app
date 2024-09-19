import 'package:flutter/material.dart';
import 'package:laber_app/components/message/info_message_widget.dart';
import 'package:laber_app/components/message/text_message_widget.dart';
import 'package:laber_app/store/types/chat.dart';

class BaseMessageWidget extends StatefulWidget {
  final ClientParsedMessage message;

  const BaseMessageWidget({
    required this.message,
    super.key,
  });

  @override
  State<BaseMessageWidget> createState() => _BaseMessageWidgetState();
}

class _BaseMessageWidgetState extends State<BaseMessageWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.message.type) {
      case ParsedMessageTypes.textMessage:
        return TextMessageWidget(message: widget.message);
      case ParsedMessageTypes.infoMessage:
        return InfoMessageWidget(message: widget.message);
      default:
        return Text(
            "NOT IMPLEMENTED MESSAGE TYPE : ${widget.message.type.toString()}");
    }
  }
}
