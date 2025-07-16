import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/providers/todo_provider.dart';

void main() {
  late ProviderContainer container;
  late TodoListNotifier notifier;
  setUp(() {
    container = ProviderContainer();
    notifier = container.read(todoProvider.notifier);
  });


  test('todo list start empty', () {
    expect(notifier.state ,[]);
  });

  test('add todo', () {
    notifier.addTodo("record video");
    expect(notifier.state[0].content, "record video");
  });

  test('delete todo', () {
    notifier.addTodo("record video");
    expect(notifier.state[0].content, "record video");

    notifier.deleteTodo(0);
    expect(notifier.state, []);
  });

  test('complete todo', () {
    notifier.addTodo("record video");
    expect(notifier.state[0].content, "record video");
    expect(notifier.state[0].completed, false);

    notifier.completeTodo(0);
    expect(notifier.state[0].completed, true);
  });  
}