import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/firebase_options.dart';
import 'package:study_sphere_frontend/infraestructure/repositories/auth_repository_impl.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotificationProvider extends ChangeNotifier {
  final AuthRepositoryImpl repository;
  final BuildContext context;
  NotificationProvider({AuthRepositoryImpl? repository, required this.context})
      : repository = repository ?? AuthRepositoryImpl() {
    _initialStatusCheck();
    _onForegroundMessage();
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  AuthorizationStatus status = AuthorizationStatus.notDetermined;
  List<dynamic> notifications = [];

  static Future<void> initializeFirebaseNotifications() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _changeStatus(AuthorizationStatus newStatus) {
    status = newStatus;
    notifyListeners();
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    _changeStatus(settings.authorizationStatus);
    _getFCMToke();
  }

  void _getFCMToke() async {
    if (status != AuthorizationStatus.authorized) return;

    final notificationToken = await messaging.getToken();
    final token =
        Provider.of<AuthProvider>(context, listen: false).user?.token ?? '';

    if (notificationToken!.isNotEmpty && token.isNotEmpty) {
      await repository.createNotificationToken(token, notificationToken);
    }
    print(token);
  }

  void _handleRemoteMessage(RemoteMessage message) {
    print(message);
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    _changeStatus(settings.authorizationStatus);
  }
}
