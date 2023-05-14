import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/config/theme/colors.dart';
import 'package:study_sphere_frontend/domain/entity/chat.dart';
import 'package:study_sphere_frontend/domain/entity/chat_message.dart';
import 'package:study_sphere_frontend/infraestructure/repositories/chat_repository_impl.dart';
import 'package:study_sphere_frontend/presentation/common/common/profile_avatar.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/socket_provider.dart';
import 'package:study_sphere_frontend/presentation/screens/chats/widgets/chat_message.dart';

class DetailChat extends StatefulWidget {
  final ChatRepositoryImpl repository;
  final String chatId;

  DetailChat({super.key, required this.chatId, ChatRepositoryImpl? repository})
      : repository = repository ?? ChatRepositoryImpl();

  @override
  State<DetailChat> createState() => _DetailChatState();
}

class _DetailChatState extends State<DetailChat> {
  late SocketProvider socketProvider;
  late AuthProvider authProvider;
  Chat? chat;
  final controller = TextEditingController();
  final _focusNode = FocusNode();

  List<ChatMessageToShow> _message = [];

  String chatText = "";
  bool isWritting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    socketProvider = Provider.of<SocketProvider>(context, listen: false)
      ..connect(context);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    socketProvider.socket.on('mensaje-personal', _listenMessage);
    socketProvider.socket.on('writting', _listenWritting);

    _loadHistory(authProvider.user?.token ?? '', widget.chatId);
  }

  @override
  void didChangeDependencies() async {
    chat = await widget.repository.getChatUser(widget.chatId);
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    socketProvider.socket.off('mensaje-personal');
    socketProvider.disconnect();
    super.dispose();
  }

  void _loadHistory(String token, String messengerId) async {
    List<ChatMessage> chats =
        await widget.repository.getHistorialChat(token, messengerId);

    final history = chats.map(
      (e) => ChatMessageToShow(
        texto: e.content,
        from: e.senderId,
        to: e.reciberId,
        date: e.createdAt,
      ),
    );

    setState(() {
      _message.insertAll(0, history);
    });
  }

  void _listenWritting(dynamic payload) {
    setState(() {
      isWritting = true;
    });
    _timer?.cancel();

    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        isWritting = false;
      });
    });
  }

  void _listenMessage(dynamic payload) {
    if (payload['from'] != widget.chatId) return;

    ChatMessageToShow chatMessage = ChatMessageToShow(
      texto: payload['message'],
      from: payload['from'],
      to: payload['to'],
      date: DateTime.parse(payload['date']),
    );

    setState(() {
      _message.insert(0, chatMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: chat == null
            ? const CircularProgressIndicator()
            : Row(
                children: [
                  ProfileAvatar(name: chat!.name, avatarUrl: chat!.avatar),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(chat!.name),
                      isWritting
                          ? FadeIn(
                              child: const Text(
                                'escribiendo...',
                                style: TextStyle(fontSize: 10),
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  )
                ],
              ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _message.length,
              itemBuilder: (_, i) => _message[i],
              reverse: true,
            ),
          ),
          const Divider(height: 1),
          Container(
            color: Colors.white,
            child: _InputChat(),
          )
        ],
      ),
    );
  }

  Widget _InputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: controller,
                onSubmitted: (_) => _handleSubmit(),
                onChanged: (e) {
                  _writteText(e);
                  socketProvider.emit('writting', {
                    'to': widget.chatId,
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: IconButton(
                  onPressed: () => _handleSubmit(),
                  icon: const Icon(
                    Icons.send,
                    color: MyColors.PRIMARY_COLOR,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _writteText(String newValue) {
    chatText = newValue;
  }

  void _handleSubmit() {
    if (chatText.isEmpty) return;
    controller.clear();
    _focusNode.requestFocus();
    final newMessage = ChatMessageToShow(
      texto: chatText,
      from: authProvider.user?.id ?? '',
      to: widget.chatId,
      date: DateTime.now(),
    );
    _message.insert(0, newMessage);
    setState(() {});

    socketProvider.emit('mensaje-personal', {
      'from': authProvider.user?.id ?? "",
      'to': widget.chatId,
      'message': chatText,
    });
  }
}
