import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:study_sphere_frontend/presentation/desktop/widgets/window_buttons.dart';

import '../common/login_logo.dart';
import '../common/login_view.dart';
import '../mobile/login_mobile_view.dart';

class DesktopView extends StatelessWidget {
  const DesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ResponsiveBuilder(
          builder: (context, sizingInformation) {
            if (sizingInformation.deviceScreenType == DeviceScreenType.mobile ||
                sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
              return const MobileView();
            }
            return const _DesktopBody();
          },
        ),
        const _WindowsBar(),
      ],
    );
  }
}

class _WindowsBar extends StatelessWidget {
  const _WindowsBar();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      top: 0,
      child: SizedBox(
        width: size.width,
        height: 50,
        child: Row(
          children: [
            // Expanded(
            //   child: MoveWindow(child: const SizedBox()),
            // ),
            const WindowButtons(),
          ],
        ),
      ),
    );
  }
}

class _DesktopBody extends StatelessWidget {
  const _DesktopBody();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.circle),
                        const SizedBox(width: 10),
                        Text(
                          'StudySphere',
                          style: textStyle.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ),
                      child: const LoginView(
                        mainAxisAlignment: MainAxisAlignment.start,
                        showLogo: false,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 10),
                    child: Text(
                      '@ Abian 2023',
                      textAlign: TextAlign.start,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xfff4f5f9),
              child: const Center(
                child: Logo(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
