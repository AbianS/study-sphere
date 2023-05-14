import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_sphere_frontend/domain/entity/simple_user.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';

import '../../../config/theme/colors.dart';

class AttendanceScreen extends StatefulWidget {
  final List<SimpleUser> students;

  const AttendanceScreen({super.key, required this.students});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<bool> _checkBoxValues = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.students.length; i++) {
      _checkBoxValues.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_checkBoxValues);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pasa lista'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        actions: [
          _PublishButton(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: widget.students.length,
        itemBuilder: (context, index) {
          final student = widget.students[index];
          return ListTile(
            title: Text(student.name),
            subtitle: Text(student.email!),
            leading: CircleAvatar(
              child: Text(
                student.name.substring(0, 1).toUpperCase(),
              ),
            ),
            trailing: Checkbox(
              value: _checkBoxValues[index],
              onChanged: (value) {
                print(value);
                _checkBoxValues[index] = value!;
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }
}

class _PublishButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        context.pop();
        Utils.showToast('Lista pasada correctamente');
      },
      child: Container(
        width: 100,
        height: 35,
        decoration: BoxDecoration(
          color: MyColors.PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            'Pasar lista',
            style: textStyle.titleMedium!.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
