import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: getValueForScreenType<CrossAxisAlignment>(
        context: context,
        mobile: CrossAxisAlignment.center,
        desktop: CrossAxisAlignment.start,
        tablet: CrossAxisAlignment.center,
      ),
      children: [
        Text(
          'Welcome back',
          style: textStyle.titleLarge!.copyWith(
            fontSize: getValueForScreenType<double>(
              context: context,
              mobile: 20,
              desktop: 45,
            ),
          ),
        ),
        SizedBox(
          height: getValueForScreenType<double>(
            context: context,
            mobile: 0,
            desktop: 10,
          ),
        ),
        Text(
          'Welcome back!, Please enter your details',
          style: textStyle.bodyMedium!.copyWith(
            fontSize: getValueForScreenType<double>(
              context: context,
              mobile: 14,
            ),
          ),
        ),
      ],
    );
  }
}
