import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:study_sphere_frontend/config/router/app_router.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/create_topic_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/notification_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/restore_password_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/socket_provider.dart';
import 'package:study_sphere_frontend/presentation/screens/connectivity/connectivity_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationProvider.initializeFirebaseNotifications();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CreateTopicProvider()),
        ChangeNotifierProvider(create: (context) => SocketProvider()),
        ChangeNotifierProvider(
          create: (context) => RestorePasswordProvider(
              Provider.of<AuthProvider>(context, listen: false)),
        ),
        ChangeNotifierProvider(
            create: (context) => NotificationProvider(context: context))
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(
      builder: (context) => MaterialApp.router(
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: app_router,
        builder: (context, child) =>
            HandleNotificationInteractions(child: child!),
      ),
    );
  }
}

class HandleNotificationInteractions extends StatefulWidget {
  final Widget child;

  const HandleNotificationInteractions({super.key, required this.child});

  @override
  State<HandleNotificationInteractions> createState() =>
      _HandleNotificationInteractionsState();
}

class _HandleNotificationInteractionsState
    extends State<HandleNotificationInteractions> {
  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      app_router.push('/chats/${message.data['id']}');
    }
  }

  @override
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityScreen(
      child: widget.child,
    );
  }
}
