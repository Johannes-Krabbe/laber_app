import 'package:flutter/material.dart';
import 'package:laber_app/store/types/chat.dart';

class InfoMessageWidget extends StatefulWidget {
  final ClientParsedMessage message;

  const InfoMessageWidget({
    required this.message,
    super.key,
  });

  @override
  State<InfoMessageWidget> createState() => _InfoMessageWidgetState();
}

class _InfoMessageWidgetState extends State<InfoMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              textAlign: TextAlign.center,
              widget.message.text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
