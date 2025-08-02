import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:offline_first_notes/features/auth/cubit/auth_cubit.dart';
import 'package:offline_first_notes/features/home/cubit/tasks_cubit.dart';
import 'package:offline_first_notes/features/home/pages/home_page.dart';
import 'package:offline_first_notes/features/home/widgets/template_picker.dart';
import 'package:offline_first_notes/models/template_model.dart';

class AddNewTaskPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewTaskPage());
  const AddNewTaskPage({super.key});

  @override
  State<AddNewTaskPage> createState() => AddNewTaskPageState();
}

class AddNewTaskPageState extends State<AddNewTaskPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Color selectedColor = Colors.lime.shade300;
  final formKey = GlobalKey<FormState>();
  String picker = "templatePicker";
  TemplateModel? selectedTemplate;

  DateTime get combinedDateTime => DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );

  void createNewTask() async {
    if (formKey.currentState!.validate()) {
      AuthLoggedIn user = context.read<AuthCubit>().state as AuthLoggedIn;
      await context.read<TasksCubit>().createNewTask(
        uid: user.user.id,
        title: _titleController.text,
        description: _descriptionController.text,
        color: selectedTemplate?.color ?? selectedColor,
        token: user.user.token,
        dueAt: combinedDateTime,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Task!"),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 90)),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(DateFormat("MM/d/y").format(selectedDate)),
                ),
              ),

              GestureDetector(
                onTap: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(selectedTime.format(context)),
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<TasksCubit, TasksState>(
        listener: (context, state) {
          if (state is TasksError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar((SnackBar(content: Text(state.error))));
          } else if (state is AddNewTasksSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              (const SnackBar(content: Text("Task Added Succcessfully"))),
            );
            Navigator.pushAndRemoveUntil(
              context,
              HomePage.route(),
              (_) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 80),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: "Title"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Title Cannot Be Empty!";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(hintText: "Description"),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Description Cannot Be Empty!";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoSlidingSegmentedControl(
                        children: {
                          'templatePicker': Text(
                            "Choose Template",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          'colorPicker': Text(
                            "Choose Color",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        },
                        onValueChanged: (String? str) {
                          if (str != null) {
                            setState(() {
                              picker = str;
                            });
                          }
                        },
                        groupValue: picker,
                      ),
                    ),
                  ),
                  if (picker == 'colorPicker')
                    ColorPicker(
                      subheading: const Text("Select A Different Shade"),
                      onColorChanged: (Color color) {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      color: selectedColor,
                    ),
                  if (picker == 'templatePicker')
                    Expanded(
                      child: TemplatePicker(
                        onTemplateChanged: (TemplateModel template) {
                          setState(() {
                            selectedTemplate = template;
                          });
                        },
                        template: selectedTemplate,
                      ),
                    ),

                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      createNewTask();
                    },
                    child: const Text(
                      "ADD TASK",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
