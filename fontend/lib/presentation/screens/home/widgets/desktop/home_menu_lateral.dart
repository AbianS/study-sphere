import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/presentation/providers/menu_provider.dart';

import '../../../../../config/theme/colors.dart';
import '../../../../desktop/widgets/custom_button.dart';

class LateralMenu extends StatelessWidget {
  const LateralMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth == 50) {
          return Container(
            color: Colors.white,
            child: const _Menus(isExpanded: false),
          );
        }

        return Container(
          color: Colors.white,
          child: const _Menus(isExpanded: true),
        );
      },
    );
  }
}

class _Menus extends StatelessWidget {
  final bool isExpanded;
  const _Menus({
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, ref, child) {
        return Column(
          children: [
            const SizedBox(height: 20),
            Builder(builder: (context) {
              final textStyle = Theme.of(context).textTheme;
              if (isExpanded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: MyColors.PRIMARY_COLOR,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('Study Sphere', style: textStyle.titleLarge),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_vert,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                );
              }
              return Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.PRIMARY_COLOR,
                ),
              );
            }),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            CustomWindowButton(
              label: 'Home',
              isExpanded: isExpanded,
              cursor: SystemMouseCursors.click,
              colorHover: MyColors.BORDER_GREY,
              icon: const HeroIcon(HeroIcons.home),
              height: 50,
              onPressed: () {
                ref.changeCurrentIndex(0);
              },
              isActive: (ref.currentIndex == 0) ? true : false,
            ),
            CustomWindowButton(
              label: 'Chat',
              isExpanded: isExpanded,
              cursor: SystemMouseCursors.click,
              colorHover: MyColors.BORDER_GREY,
              icon: const HeroIcon(
                HeroIcons.chatBubbleOvalLeft,
              ),
              height: 50,
              onPressed: () {
                ref.changeCurrentIndex(1);
              },
              isActive: (ref.currentIndex == 1) ? true : false,
            ),
            CustomWindowButton(
              label: 'Calendar',
              isExpanded: isExpanded,
              cursor: SystemMouseCursors.click,
              colorHover: MyColors.BORDER_GREY,
              icon: const HeroIcon(HeroIcons.calendar),
              height: 50,
              onPressed: () {
                ref.changeCurrentIndex(2);
              },
              isActive: (ref.currentIndex == 2) ? true : false,
            ),
            CustomWindowButton(
              label: 'Notifications',
              isExpanded: isExpanded,
              cursor: SystemMouseCursors.click,
              colorHover: MyColors.BORDER_GREY,
              icon: const HeroIcon(HeroIcons.inbox),
              height: 50,
              onPressed: () {
                ref.changeCurrentIndex(3);
              },
              isActive: (ref.currentIndex == 3) ? true : false,
            ),
            CustomWindowButton(
              label: 'Board',
              isExpanded: isExpanded,
              cursor: SystemMouseCursors.click,
              colorHover: MyColors.BORDER_GREY,
              icon: const HeroIcon(HeroIcons.pencilSquare),
              height: 50,
              onPressed: () {
                ref.changeCurrentIndex(4);
              },
              isActive: (ref.currentIndex == 4) ? true : false,
            ),
            CustomWindowButton(
              label: 'Drive',
              isExpanded: isExpanded,
              cursor: SystemMouseCursors.click,
              colorHover: MyColors.BORDER_GREY,
              icon: const HeroIcon(HeroIcons.folder),
              height: 50,
              isActive: (ref.currentIndex == 5) ? true : false,
              onPressed: () {
                ref.changeCurrentIndex(5);
              },
            ),
            const Spacer(),
            CustomWindowButton(
              label: 'Settings',
              isExpanded: isExpanded,
              cursor: SystemMouseCursors.click,
              colorHover: MyColors.BORDER_GREY,
              icon: const HeroIcon(HeroIcons.cog6Tooth),
              height: 50,
              onPressed: () {
                ref.changeCurrentIndex(6);
              },
              isActive: (ref.currentIndex == 6) ? true : false,
            ),
            CustomWindowButton(
              cursor: SystemMouseCursors.click,
              colorHover: MyColors.BORDER_GREY,
              icon: (ref.menuSize == 50)
                  ? const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                    )
                  : const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 15,
                    ),
              height: 50,
              onPressed: () => ref.toggleMenu(),
            )
          ],
        );
      },
    );
  }
}
