import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:study_sphere_frontend/config/theme/colors.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/create_todo_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/todo_provider.dart';
import 'package:study_sphere_frontend/presentation/screens/common/widgets/text_form_field.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../domain/entity/todo.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final token =
        Provider.of<AuthProvider>(context, listen: false).user?.token ?? '';

    return ChangeNotifierProvider(
      create: (context) => TodoProvider()..init(token),
      child: Scaffold(
        appBar: AppBar(
          title: FadeIn(
            child: const Text('Todo'),
          ),
          actions: [
            _TopCalendar(),
          ],
        ),
        body: _Body(),
      ),
    );
  }
}

class _TopCalendar extends StatelessWidget {
  const _TopCalendar();

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, ref, child) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            children: [
              Text(Utils.todoDate(ref.markedDay)),
              const SizedBox(width: 5),
              IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () => ref.changeCalendarFormat(),
              )
            ],
          ),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final token =
        Provider.of<AuthProvider>(context, listen: false).user?.token ?? '';

    return Consumer<TodoProvider>(
      builder: (context, ref, child) {
        return Column(
          children: [
            FadeInLeft(
              delay: const Duration(milliseconds: 200),
              child: TableCalendar(
                eventLoader: ref.loadEvents,
                focusedDay: ref.markedDay,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                calendarFormat: ref.calendarFormat,
                headerStyle: HeaderStyle(
                  rightChevronVisible: false,
                  leftChevronVisible: false,
                  formatButtonVisible: false,
                  headerPadding: const EdgeInsets.symmetric(horizontal: 10),
                  titleTextFormatter: (date, locale) => "",
                ),
                onDaySelected: ref.changeMarkedDay,
                currentDay: ref.markedDay,
              ),
            ),
            Flexible(
              child: ref.currentTodos.isEmpty
                  ? FadeInDown(
                      child: const _NotTodo(),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ListView.builder(
                        itemCount: ref.currentTodos.length,
                        itemBuilder: (context, index) {
                          final todo = ref.currentTodos[index];
                          return FadeInDown(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15)
                                      .copyWith(bottom: 10),
                              child: Dismissible(
                                key: UniqueKey(),
                                onDismissed: (_) =>
                                    ref.dismissed(token, todo.id),
                                confirmDismiss:
                                    (DismissDirection direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirmar"),
                                        content: const Text(
                                            "¿Estas seguro de que quieres eliminar este todo?"),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text("Borrar")),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text("Cancelar"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    border: Border.all(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: const [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                child: _TodoCard(todo),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: const _TodoButton(),
            )
          ],
        );
      },
    );
  }
}

class _TodoCard extends StatelessWidget {
  final Todo todo;

  const _TodoCard(this.todo);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<bool>(
          isScrollControlled: true,
          context: context,
          builder: (context) => ChangeNotifierProvider(
            create: (context) => CreateTodoProvider()
              ..init(
                  todoId: todo.id,
                  title: todo.title,
                  executeHour: todo.executeDay,
                  executeTime: todo.executeDay),
            child: const _TodoSheet(),
          ),
        );
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: todo.completed ? Colors.green.shade200 : Colors.black12,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(
                Icons.check_circle_outline_outlined,
                color: todo.completed ? Colors.green : Colors.grey.shade500,
                size: 30,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    todo.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  todo.completed
                      ? const SizedBox.shrink()
                      : Text(Utils.formatHour(todo.executeDay))
                ],
              ),
              const Spacer(),
              todo.completed
                  ? SizedBox.fromSize()
                  : Icon(
                      Icons.notifications,
                      color: Colors.grey.shade500,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodoButton extends StatelessWidget {
  const _TodoButton();

  @override
  Widget build(BuildContext context) {
    final token =
        Provider.of<AuthProvider>(context, listen: false).user?.token ?? "";

    final size = MediaQuery.of(context).size;
    return Consumer<TodoProvider>(
      builder: (context, ref, child) {
        return GestureDetector(
          onTap: () async {
            final bool? result = await showModalBottomSheet<bool>(
              isScrollControlled: true,
              context: context,
              builder: (context) => ChangeNotifierProvider(
                create: (context) => CreateTodoProvider()..init(),
                child: const _TodoSheet(),
              ),
            );

            if (result == null) return;

            if (result) {
              ref.init(token);
            }
          },
          child: SizedBox(
            height: 90,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.black26,
                  ),
                ),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Añadir una tarea'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TodoSheet extends StatelessWidget {
  const _TodoSheet();

  @override
  Widget build(BuildContext context) {
    final token =
        Provider.of<AuthProvider>(context, listen: false).user?.token ?? "";

    return Consumer<CreateTodoProvider>(
      builder: (context, ref, child) {
        return SizedBox(
          height: 650,
          child: DraggableScrollableSheet(
            initialChildSize: 1,
            minChildSize: 1,
            expand: true,
            builder: (context, scrollController) => Container(
              height: 900,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          CustomTextFormField(
                            focusNode: ref.focusNode,
                            onChanged: ref.changeTitle,
                            initialValue: ref.title,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.alarm),
                              const SizedBox(width: 10),
                              Text(ref.executeTimeisActive
                                  ? Utils.formatDateWithHours(ref.executeTime)
                                  : 'Sin Fecha'),
                              const Spacer(),
                              CupertinoSwitch(
                                value: ref.executeTimeisActive,
                                onChanged: ref.changeExecuteTimeIsActive,
                              ),
                            ],
                          ),
                          ref.executeTimeisActive
                              ? SizedBox(
                                  height: 200,
                                  child: ScrollDatePicker(
                                    maximumDate: DateTime.utc(2100, 1, 1),
                                    selectedDate: ref.executeTime,
                                    onDateTimeChanged: ref.changeExecuteTime,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const Divider(),
                          Row(
                            children: [
                              const Icon(Icons.access_time),
                              const SizedBox(width: 10),
                              Text(ref.executeTimeisActive
                                  ? Utils.formatHour(ref.executeHour)
                                  : 'Sin Hora'),
                              const Spacer(),
                              CupertinoSwitch(
                                value: ref.executeHourIsActive,
                                onChanged: ref.changeExecuteHourIsActive,
                              ),
                            ],
                          ),
                          ref.executeHourIsActive
                              ? SizedBox(
                                  height: 150,
                                  child: TimePickerSpinner(
                                    itemHeight: 40,
                                    normalTextStyle:
                                        const TextStyle(fontSize: 20),
                                    highlightedTextStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    is24HourMode: false,
                                    time: ref.executeHour,
                                    onTimeChange: ref.changeExecuteHour,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const Divider(),
                          Row(
                            children: const [
                              Icon(Icons.notifications),
                              SizedBox(width: 10),
                              Text('Recordarme')
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: SizedBox(
                              height: 30,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  _NotificationButton(
                                    text: '1 hora antes',
                                    checkNumber: ref.notificationIndex,
                                    currentNumber: 0,
                                    onPress: () =>
                                        ref.changeNotificationIndex(0),
                                  ),
                                  const SizedBox(width: 10),
                                  _NotificationButton(
                                      checkNumber: ref.notificationIndex,
                                      text: '30 min antes',
                                      currentNumber: 1,
                                      onPress: () =>
                                          ref.changeNotificationIndex(1)),
                                  const SizedBox(width: 10),
                                  _NotificationButton(
                                    text: '15 min antes',
                                    checkNumber: ref.notificationIndex,
                                    currentNumber: 2,
                                    onPress: () =>
                                        ref.changeNotificationIndex(2),
                                  ),
                                  const SizedBox(width: 10),
                                  _NotificationButton(
                                    text: '5 min antes',
                                    checkNumber: ref.notificationIndex,
                                    currentNumber: 3,
                                    onPress: () =>
                                        ref.changeNotificationIndex(3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Consumer<CreateTodoProvider>(
                      builder: (context, ref, child) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: GestureDetector(
                            onTap: () => ref.createTodo(token, context),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: MyColors.PRIMARY_COLOR,
                              ),
                              child: const Center(
                                child: Text(
                                  'Crear tarea',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final String text;
  final int currentNumber;
  final int checkNumber;
  final VoidCallback onPress;

  const _NotificationButton({
    required this.currentNumber,
    required this.text,
    required this.checkNumber,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(),
      child: Container(
        height: 25,
        decoration: BoxDecoration(
          color: currentNumber == checkNumber
              ? MyColors.PRIMARY_COLOR
              : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotTodo extends StatelessWidget {
  const _NotTodo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/images/not-todo.svg', height: 200),
        const SizedBox(height: 20),
        const Text('No tienes Tareas')
      ],
    );
  }
}
