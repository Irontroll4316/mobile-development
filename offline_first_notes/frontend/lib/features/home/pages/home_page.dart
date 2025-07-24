import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offline_first_notes/features/home/pages/add_new_task_page.dart';
import 'package:offline_first_notes/features/home/widgets/date_selector.dart';
import 'package:offline_first_notes/features/home/widgets/task_card.dart';

class HomePage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("My Tasks"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewTaskPage.route());
            },
            icon: const Icon(CupertinoIcons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          DateSelector(),
          Row(
            children: [
              Expanded(
                child: TaskCard(
                  color: Colors.lime.shade200,
                  header: "Hello",
                  descriptionText:
                      "this is the descriptionthis is the descriptionthis is the descriptionthis is the descriptionthis is the descriptionthis is the descriptionthis is the descriptionthis is the description",
                ),
              ),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  shape: BoxShape.circle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('10:00 AM', style: TextStyle(fontSize: 17)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
