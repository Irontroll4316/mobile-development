import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_notes/core/constants/utils.dart';
import 'package:offline_first_notes/features/home/repository/task_local_repository.dart';
import 'package:offline_first_notes/features/home/repository/task_remote_repository.dart';
import 'package:offline_first_notes/models/task_model.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());
  final taskRemoteRepository = TaskRemoteRepository();
  final taskLocalRepository = TaskLocalRepository();

  Future<void> createNewTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required DateTime dueAt,
    required String uid,
  }) async {
    try {
      emit(TasksLoading());
      final taskModel = await taskRemoteRepository.createTask(
        uid: uid,
        title: title,
        description: description,
        hexColor: rgbToHex(color),
        token: token,
        dueAt: dueAt,
      );
      await taskLocalRepository.insertTask(taskModel);
      emit(AddNewTasksSuccess(taskModel));
    } catch (e) {
      emit(TasksError("tasks_cubit_createNewTask -> ${e.toString()}"));
    }
  }

  Future<void> getAllTasks({required String token}) async {
    try {
      emit(TasksLoading());
      final tasks = await taskRemoteRepository.getTasks(token: token);
      emit(GetTasksSuccess(tasks));
    } catch (e) {
      emit(TasksError("tasks_cubit.getAllTasks -> ${e.toString()}"));
    }
  }

  Future<void> syncTasks() async {
    final unsyncedTasks = await taskLocalRepository.getUnsycnedTasks();
    print(unsyncedTasks);
  }
}
