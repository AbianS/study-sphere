import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:study_sphere_frontend/domain/entity/simple_user.dart';
import 'package:study_sphere_frontend/presentation/common/common/profile_avatar.dart';
import 'package:study_sphere_frontend/presentation/providers/clase_provider.dart';

class PeopleView extends StatelessWidget {
  const PeopleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClaseProvider>(
      builder: (context, ref, child) {
        return SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInUp(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profesores',
                        style: TextStyle(fontSize: 3.sh),
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      ShowPeople(user: ref.clase!.teacher),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alumnos',
                        style: TextStyle(fontSize: 3.sh),
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      ...ref.clase!.students
                          .map(
                            (student) => Column(
                              children: [
                                ShowPeople(
                                  user: student,
                                ),
                                const SizedBox(height: 20)
                              ],
                            ),
                          )
                          .toList()
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
        ;
      },
    );
  }
}

class ShowPeople extends StatelessWidget {
  final SimpleUser user;

  const ShowPeople({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(name: user.name, avatarUrl: user.avatar),
        const SizedBox(width: 10),
        Text(user.name),
      ],
    );
  }
}
