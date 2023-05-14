import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/config/theme/colors.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';

class ChatMessageToShow extends StatelessWidget {
  final String texto;
  final String from;
  final String? to;
  final DateTime? date;

  const ChatMessageToShow({
    super.key,
    required this.texto,
    required this.from,
    this.to,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    final userId =
        Provider.of<AuthProvider>(context, listen: false).user?.id ?? "";

    return Container(
      child:
          from == userId ? _MyMessage(texto, date) : _NotMyMessage(texto, date),
    );
  }
}

class _MyMessage extends StatelessWidget {
  final String text;
  final DateTime? date;
  const _MyMessage(this.text, this.date);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(
          right: 5,
          bottom: 5,
          left: 100,
        ),
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: MyColors.PRIMARY_COLOR,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              DateFormat('h:mm').format(date!),
              style: const TextStyle(fontSize: 10, color: Colors.white),
              textAlign: TextAlign.end,
            )
          ],
        ),
      ),
    );
  }
}

class _NotMyMessage extends StatelessWidget {
  final String text;
  final DateTime? date;
  const _NotMyMessage(this.text, this.date);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(
          right: 100,
          bottom: 5,
          left: 5,
        ),
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xffe4e5e8),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              style: const TextStyle(color: Colors.black87),
            ),
            Text(
              DateFormat('h:mm').format(date!),
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.end,
            )
          ],
        ),
      ),
    );
  }
}
