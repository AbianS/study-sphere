import 'package:flutter/material.dart';
import 'package:study_sphere_frontend/domain/entity/material.dart';
import 'package:study_sphere_frontend/presentation/common/common/message_field_box.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/utils.dart';

class MaterialScreen extends StatelessWidget {
  final MaterialEntity material;

  const MaterialScreen({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.title,
                    style: textStyle.titleLarge,
                  ),
                  const Divider(),
                  Text(material.description ?? "hola buenos dias"),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Archivos Adjuntos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 150,
                    child: _ShowFilesContainer(
                      material: material,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShowFilesContainer extends StatelessWidget {
  final MaterialEntity material;

  const _ShowFilesContainer({required this.material});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final List<String> files = material.files;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];

            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async => await launchUrl(Uri.parse(file)),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 100,
                      width: 200,
                      child: Utils.getFileExtension(file) == 'jpg'
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                image: NetworkImage(file),
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Text(
                                Utils.getFileExtension(file),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(
                      file.split("/").last,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
