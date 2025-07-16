import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/pages/add.dart';
import 'package:todo_app/pages/completed.dart';
import 'package:todo_app/providers/todo_provider.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todoProvider);
    List<Todo> activeTodos = todos.where((todo) => todo.completed == false,).toList();
    List<Todo> completedTodos = todos.where((todo) => todo.completed == true,). toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: activeTodos.length + 1,
        itemBuilder: (context, index) {
          if (todos.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 350),
              child: Center(
                child: Text(
                  "Add a Todo using the button below!",
                  style: TextStyle(fontSize: 22)  
                ),
              )
            );
          }
          if (index == activeTodos.length) {
            if (completedTodos.isEmpty) {return Container();}
            else {
              return Center(
                child: TextButton(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 350),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Text(
                        "Completed Todos",
                        style: TextStyle(color: Colors.white)  
                      ),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CompletedTodo())),
                  ),
                );
            }
          } else {
            return Slidable(
              key: ValueKey(todos[index].todoId.toString()),
              startActionPane: ActionPane(
                motion: ScrollMotion(), 
                children: [
                  SlidableAction(
                  key: ValueKey("${todos[index].todoId}delete"),
                  onPressed: (context) => ref.watch(todoProvider.notifier).deleteTodo(activeTodos[index].todoId), 
                  backgroundColor: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    icon: Icons.delete,
                  )
                ]
              ),
              endActionPane: ActionPane(
                motion: ScrollMotion(), 
                children: [
                  SlidableAction(
                    onPressed: (context) => ref.watch(todoProvider.notifier).completeTodo(activeTodos[index].todoId), 
                    backgroundColor: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    icon: Icons.check,
                  )
               ]
              ),
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: ListTile(
                  title: Text(
                    activeTodos[index].content,
                    style: TextStyle(color: Colors.white),
                    )
                  ),
              ),
            );
          }
        },
      ),
     floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddTodo()));
        },
        tooltip: 'Increment',
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}