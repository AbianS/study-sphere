import 'package:go_router/go_router.dart';
import 'package:study_sphere_frontend/presentation/screens/annotation/annotation_screen.dart';
import 'package:study_sphere_frontend/presentation/screens/board/drawing_canvas/init_page.dart';
import 'package:study_sphere_frontend/presentation/screens/board/drawing_page.dart';
import 'package:study_sphere_frontend/presentation/screens/chats/chats_screen.dart';
import 'package:study_sphere_frontend/presentation/screens/chats/detail_chat.dart';
import 'package:study_sphere_frontend/presentation/screens/clase/activities/doc_screen.dart';
import 'package:study_sphere_frontend/presentation/screens/clase/activities/material_screen.dart';
import 'package:study_sphere_frontend/presentation/screens/clase/activities/task_grade.dart';
import 'package:study_sphere_frontend/presentation/screens/clase/activities/task_screen.dart';
import 'package:study_sphere_frontend/presentation/screens/clase/attendance_screen.dart';
import 'package:study_sphere_frontend/presentation/screens/clase/clase_screen.dart';
import 'package:study_sphere_frontend/presentation/screens/clase/create_comment.dart';
import 'package:study_sphere_frontend/presentation/screens/clase/create_material.dart';
import 'package:study_sphere_frontend/presentation/screens/clase/create_task.dart';
import 'package:study_sphere_frontend/presentation/screens/home/create-class/create_class_screen.dart';
import 'package:study_sphere_frontend/presentation/screens/home/home_screen.dart';
import 'package:study_sphere_frontend/presentation/screens/home/join-class/join_class_screen.dart';
import 'package:study_sphere_frontend/presentation/screens/intro/intro_screen.dart';
import 'package:study_sphere_frontend/presentation/screens/login/login_screen.dart';
import 'package:study_sphere_frontend/presentation/screens/profile/profile_screen.dart';
import 'package:study_sphere_frontend/presentation/screens/register/register_screen.dart';
import 'package:study_sphere_frontend/presentation/screens/reset/reset_screen.dart';
import 'package:study_sphere_frontend/presentation/screens/reset/restart_password_screen.dart';
import 'package:study_sphere_frontend/presentation/screens/splash/splash_screen.dart';
import 'package:study_sphere_frontend/presentation/screens/todo/todos_screen.dart';

final app_router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, __) => const SplashScreen(),
    ),
    GoRoute(
      path: '/intro',
      builder: (context, state) => const IntroScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/chats',
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/todos',
      builder: (context, state) => const TodosScreen(),
    ),
    GoRoute(
      path: '/intro-board',
      builder: (context, state) => const InitBoard(),
    ),
    GoRoute(
      path: '/board',
      builder: (context, state) => const DrawingPage(),
    ),
    GoRoute(
      path: '/reset',
      builder: (context, state) => const ResetScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/restart-password/:email',
      builder: (context, state) =>
          RestartPasswordScreen(email: state.params['email']!),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/chats/:id',
      builder: (context, state) {
        return DetailChat(chatId: state.params['id']!);
      },
    ),
    GoRoute(
      path: '/home/create',
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return CreateClassScreen(homeProvider: args['homeProvider']);
      },
    ),
    GoRoute(
      path: '/home/join',
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return JoinClassScreen(homeProvider: args['homeProvider']);
      },
    ),
    GoRoute(
        path: '/clase/attendance',
        builder: (context, state) {
          Map<String, dynamic> args = state.extra as Map<String, dynamic>;
          return AttendanceScreen(
            students: args['students'],
          );
        }),
    GoRoute(
      path: '/clase/annotation',
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return AnnotationScreen(
          claseProvider: args['claseProvider'],
          annotations: args['annotations'],
          type: args['type'],
          id: args['id'],
        );
      },
    ),
    GoRoute(
      path: '/clase/create/material',
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return CreateMaterial(
          classId: args['classId'],
        );
      },
    ),
    GoRoute(
      path: '/clase/material',
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return MaterialScreen(
          material: args['material'],
        );
      },
    ),
    GoRoute(
      path: '/clase/task/grade',
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return TaskGrade(
          completeTaskUser: args['completeTaskUser'],
          teacherProvider: args['teacherProvider'],
        );
      },
    ),
    GoRoute(
      path: '/clase/task',
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return TaskScreen(
          taskId: args['taskId'],
        );
      },
    ),
    GoRoute(
        path: '/clase/doc',
        builder: (context, state) {
          Map<String, dynamic> args = state.extra as Map<String, dynamic>;
          return DocScreen(
            taskId: args['taskId'],
            taskProvider: args['taskProvider'],
          );
        }),
    GoRoute(
      path: '/clase/:id',
      builder: (context, state) => ClaseScreen(
        classId: state.params["id"],
      ),
    ),
    GoRoute(
      path: '/clase/create/comment',
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return CreateCommentScreen(
          claseProvider: args['classProvider'],
        );
      },
    ),
    GoRoute(
      path: '/clase/create/task/:classId',
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return CreateTaskScreen(
          classId: state.params['classId']!,
          claseProvider: args['claseProvider'],
        );
      },
    ),
  ],
);
