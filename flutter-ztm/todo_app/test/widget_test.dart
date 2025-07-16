import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/pages/completed.dart';
import 'package:todo_app/pages/home.dart';
import 'package:todo_app/providers/todo_provider.dart';

void main() {
  testWidgets('default state', (WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(child: const MyApp()));

    Finder defaultText = find.text("Add a Todo using the button below!");

    expect(defaultText, findsOneWidget);
  });

  testWidgets("completed todos show u on completed page", (tester) async {
    TodoListNotifier notifier = TodoListNotifier(
      <Todo>[Todo(todoId: 0, content: 'record video', completed: true)],
    );
    await tester.pumpWidget(ProviderScope(
      overrides: [todoProvider.overrideWith((ref) => notifier)],      
      child: const MaterialApp(home: CompletedTodo())
      ));
    
    Finder completedText = find.text("record video");

    expect(completedText, findsOneWidget);
  });

  testWidgets("slide and complete a todo", (tester) async {
    TodoListNotifier notifier = TodoListNotifier(
      <Todo>[Todo(todoId: 0, content: 'record video', completed: false)],
    );
    await tester.pumpWidget(ProviderScope(
      overrides: [todoProvider.overrideWith((ref) => notifier)],      
      child: const MaterialApp(home: MyHomePage())
      ));

    Finder draggableWidget = find.byKey(ValueKey("0"));
    Finder deleteButton = find.byKey(ValueKey("0delete"));
    
    await tester.timedDrag(
      draggableWidget, const Offset(200, 0), const Duration(seconds: 1));
      await tester.pump();
      await tester.tap(deleteButton);
      await tester.pump();
      Finder defaultText = find.text("Add a Todo using the button below!");
      expect(defaultText, findsOneWidget);
  });
 
}
