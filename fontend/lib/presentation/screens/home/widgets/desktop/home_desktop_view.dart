import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/menu_provider.dart';
import 'package:study_sphere_frontend/presentation/views/dashboard/views.dart';

import '../../../../../config/theme/colors.dart';
import '../../../../common/desktop/drag_menu.dart';
import '../../../../desktop/widgets/window_buttons.dart';
import 'home_menu_lateral.dart';

class HomeDesktopView extends StatelessWidget {
  const HomeDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ChangeNotifierProvider(
      create: (context) => MenuProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const _CustomNavBar(),
              SizedBox(
                width: double.infinity,
                height: size.height - 50,
                child: Consumer<MenuProvider>(
                  builder: (context, ref, child) {
                    return Row(
                      children: [
                        SizedBox(
                          width: ref.menuSize,
                          child: const LateralMenu(),
                        ),
                        DragMenu(
                          thresholdActive: 200,
                          onOpen: () => ref.openMenu(),
                          onClose: () => ref.closeMenu(),
                        ),
                        Expanded(
                          child: ViewList.viewListDesktop[ref.currentIndex],
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomNavBar extends StatelessWidget {
  const _CustomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: MyColors.BORDER_GREY, width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Expanded(child: MoveWindow()),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => Provider.of<AuthProvider>(context, listen: false)
                .logout(context),
            child: const CircleAvatar(
              child: Text('Ab'),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
          ),
          const WindowButtons()
        ],
      ),
    );
  }
}
