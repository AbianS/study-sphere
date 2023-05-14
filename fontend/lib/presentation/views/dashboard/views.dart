import 'package:study_sphere_frontend/presentation/views/dashboard/settings/settings_view.dart';

import 'board/board_view.dart';
import 'calendar/calendar_view.dart';
import 'chats/chats_view.dart';
import 'drive/drive_view.dart';
import 'home/home_view.dart';
import 'notifications/notifications_view.dart';

class ViewList {
  static const viewListDesktop = [
    HomeView(),
    ChatsView(),
    CalendarView(),
    NotificationsView(),
    BoardView(),
    DriveView(),
    SettingsView()
  ];
  static const viewListMobile = [
    HomeView(),
    ChatsView(),
    CalendarView(),
    BoardView(),
    DriveView(),
    SettingsView()
  ];
}
