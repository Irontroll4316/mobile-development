part of 'add_new_task_cubit.dart';

sealed class AddNewTaskState {
  const AddNewTaskState();
}

final class AddNewTasksLoading extends AddNewTaskState {}

final class AddNewTasksInitial extends AddNewTaskState {}

final class AddNewTasksError extends AddNewTaskState {
  final String error;
  const AddNewTasksError(this.error);
}

final class AddNewTasksSuccess extends AddNewTaskState {
  final TaskModel taskModel;
  const AddNewTasksSuccess(this.taskModel);
}
