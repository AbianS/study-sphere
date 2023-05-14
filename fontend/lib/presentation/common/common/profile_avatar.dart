import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? name;
  final String? avatarUrl;
  final double? size;

  const ProfileAvatar({
    super.key,
    required this.name,
    this.avatarUrl,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
      child: avatarUrl == null
          ? Text(name != null ? name!.substring(0, 1).toUpperCase() : 'A')
          : null,
    );
  }
}
