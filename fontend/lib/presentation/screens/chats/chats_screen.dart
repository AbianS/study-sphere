import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/domain/entity/chat.dart';
import 'package:study_sphere_frontend/infraestructure/repositories/chat_repository_impl.dart';
import 'package:study_sphere_frontend/presentation/common/common/profile_avatar.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final token =
        Provider.of<AuthProvider>(context, listen: false).user?.token ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: FutureBuilder(
        future: ChatRepositoryImpl().getChats(token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/not-chats.svg',
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Parece que no tienes chats',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                        'Unete a una clase y comienza a chatear con tus amigos'),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => ChatRepositoryImpl().getChats(token),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final Chat chat = snapshot.data![index];
                  return ListTile(
                    onTap: () => context.push('/chats/${chat.id}'),
                    leading: ProfileAvatar(
                      name: chat.name,
                      avatarUrl: chat.avatar,
                    ),
                    title: Text('${chat.name} ${chat.surname}'),
                    subtitle: Text(chat.email),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
