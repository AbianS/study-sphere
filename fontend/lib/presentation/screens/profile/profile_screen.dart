import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/domain/dtos/update_user_dto.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';

import '../../../config/theme/colors.dart';
import '../common/widgets/text_form_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String surname = "";
  String phone = "";

  @override
  void deactivate() {
    Provider.of<AuthProvider>(context, listen: false).modifyProfilePicture =
        null;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ProgressHUD(
        child: Consumer<AuthProvider>(
          builder: (context, ref, child) {
            ref.progressHUD = ProgressHUD.of(context);
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _ProfilePicture(),
                          const SizedBox(height: 10),
                          Text(
                            '${ref.user?.name} ${ref.user?.surname}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '${ref.user?.email}',
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nombre', style: textStyle.bodyLarge),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width: ((size.width / 2) - 25),
                                    child: CustomTextFormField(
                                      initialValue: ref.user?.name,
                                      hint: 'Escribe tu Nombre',
                                      onChanged: (p0) {
                                        setState(() {
                                          name = p0;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Apellidos', style: textStyle.bodyLarge),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width: ((size.width / 2) - 25),
                                    child: CustomTextFormField(
                                      initialValue: ref.user?.surname,
                                      hint: 'Escribe tus Apellidos',
                                      onChanged: (p0) {
                                        setState(() {
                                          surname = p0;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email', style: textStyle.bodyLarge),
                              const SizedBox(height: 5),
                              CustomTextFormField(
                                initialValue: ref.user?.email,
                                readOnly: true,
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Phone', style: textStyle.bodyLarge),
                              const SizedBox(height: 5),
                              CustomTextFormField(
                                initialValue: ref.user?.phone,
                                onChanged: (p0) {
                                  setState(() {
                                    phone = p0;
                                  });
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap: () async {
                              final updateUserDTO = UpdateUserDTO(
                                name: name,
                                phone: phone,
                                surname: surname,
                              );

                              await ref.updateUser(updateUserDTO);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: MyColors.PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: (1 < 0)
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        'Actualizar',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Provider.of<AuthProvider>(context,
                                    listen: false)
                                .logout(context),
                            child: const Text('Cerrar sessión'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfilePicture extends StatelessWidget {
  const _ProfilePicture();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, ref, child) {
        return GestureDetector(
          onTap: () async {
            final XFile? image =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (image != null) ref.saveTempImage(image);
          },
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: ref.modifyProfilePicture != null
                    ? FileImage(
                        File.fromUri(
                          Uri.parse(ref.modifyProfilePicture!.path),
                        ),
                      )
                    : ref.user!.avatar != null
                        ? NetworkImage(ref.user!.avatar!) as ImageProvider
                        : null,
                child:
                    ref.modifyProfilePicture == null && ref.user?.avatar == null
                        ? Text(
                            ref.user?.name != null
                                ? ref.user!.name.substring(0, 2).toUpperCase()
                                : 'A',
                          )
                        : null,
              ),
              Positioned(
                bottom: 0,
                right: 5,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.edit_outlined,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
