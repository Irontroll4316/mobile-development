import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/providers/todo_provider.dart';

class CompletedTodo extends ConsumerWidget {
  const CompletedTodo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todoProvider);
    List<Todo> completedTodos = todos.where((todo) => todo.completed == true,). toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Completed Todos"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: completedTodos.length,
        itemBuilder: (context, index) {
          return Slidable(
            startActionPane: ActionPane(
              motion: ScrollMotion(), 
              children: [
                SlidableAction(
                  onPressed: (context) => ref.watch(todoProvider.notifier).deleteTodo(completedTodos[index].todoId), 
                  backgroundColor: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  icon: Icons.delete,
                )
              ]
            ),
            child: Container(
                margin: EdgeInsets.all(16),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              child:ListTile(
              title: Text(
                completedTodos[index].content,
                style: TextStyle(color: Colors.white),
                ),
              ),
            )
          );
        },
      ),
    );
  }
}