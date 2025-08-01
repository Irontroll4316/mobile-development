import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:offline_first_notes/core/constants/constants.dart';
import 'package:offline_first_notes/core/constants/utils.dart';
import 'package:offline_first_notes/features/home/repository/task_local_repository.dart';
import 'package:offline_first_notes/models/task_model.dart';
import 'package:uuid/uuid.dart';

class TaskRemoteRepository {
  final taskLocalRepository = TaskLocalRepository();

  Future<TaskModel> createTask({
    required String title,
    required String description,
    required String color,
    required String token,
    required String uid,
    required DateTime dueAt,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse("${Constants.backendUri}/tasks"),
            headers: {
              'Content-Type': 'application/json',
              'x-auth-token': token,
            },
            body: jsonEncode({
              'title': title,
              'description': description,
              'color': color,
              'dueAt': dueAt.toIso8601String(),
            }),
          )
          .timeout(Duration(milliseconds: 250));
      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }
      return TaskModel.fromJson(res.body);
    } catch (e) {
      try {
        final taskModel = TaskModel(
          id: const Uuid().v4(),
          uid: uid,
          title: title,
          description: description,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          dueAt: dueAt,
          color: hexToRgb(color),
          isSynced: 0,
        );
        await taskLocalRepository.insertTask(taskModel);
        return taskModel;
      } catch (e) {
        throw ("task_remote_repository.createTask -> \n${e.toString()}");
      }
    }
  }

  Future<List<TaskModel>> getTasks({required String token}) async {
    try {
      final res = await http
          .get(
            Uri.parse("${Constants.backendUri}/tasks"),
            headers: {
              'Content-Type': 'application/json',
              'x-auth-token': token,
            },
          )
          .timeout(Duration(milliseconds: 250));
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['error'];
      }
      final listOfTasks = jsonDecode(res.body);
      List<TaskModel> tasksList = [];
      for (var element in listOfTasks) {
        tasksList.add(TaskModel.fromMap(element));
      }
      await taskLocalRepository.insertTasks(tasksList);
      return tasksList;
    } catch (e) {
      final tasks = await taskLocalRepository.getTasks();
      if (tasks.isNotEmpty) {
        return tasks;
      }
      throw ("task_remote_repository.getTasks -> \n${e.toString()}");
    }
  }

  Future<bool> syncTasks({
    required String token,
    required List<TaskModel> tasks,
  }) async {
    try {
      final taskListInMapFormat = [];
      for (final task in tasks) {
        taskListInMapFormat.add(task.toMap());
      }
      final res = await http
          .post(
            Uri.parse("${Constants.backendUri}/tasks/sync"),
            headers: {
              'Content-Type': 'application/json',
              'x-auth-token': token,
            },
            body: jsonEncode(taskListInMapFormat),
          )
          .timeout(Duration(milliseconds: 250));
      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> completeTask({
    required String token,
    required String id,
    required int completed,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse("${Constants.backendUri}/tasks/complete"),
            headers: {
              'Content-Type': 'application/json',
              'x-auth-token': token,
            },
            body: jsonEncode({'id': id, 'completed': completed}),
          )
          .timeout(Duration(milliseconds: 250));
      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }
      if (jsonDecode(res.body)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
