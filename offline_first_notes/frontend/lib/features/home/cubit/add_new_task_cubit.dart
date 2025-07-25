import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_notes/core/constants/utils.dart';
import 'package:offline_first_notes/features/home/repository/task_remote_repository.dart';
import 'package:offline_first_notes/models/task_model.dart';

part 'add_new_task_state.dart';

class AddNewTaskCubit extends Cubit<AddNewTaskState> {
  AddNewTaskCubit() : super(AddNewTasksInitial());
  final taskRemoteRepository = TaskRemoteRepository();

  Future<void> createNewTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required DateTime dueAt,
  }) async {
    try {
      emit(AddNewTasksLoading());
      final taskModel = await taskRemoteRepository.createTask(
        title: title,
        description: description,
        hexColor: rgbToHex(color),
        token: token,
        dueAt: dueAt,
      );
      emit(AddNewTasksSuccess(taskModel));
    } catch (e) {
      emit(AddNewTasksError(e.toString()));
    }
  }
}
