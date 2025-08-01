import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_notes/core/services/sp_service.dart';
import 'package:offline_first_notes/features/auth/repository/auth_local_repository.dart';
import 'package:offline_first_notes/features/auth/repository/auth_remote_repository.dart';
import 'package:offline_first_notes/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final authRemoteRepository = AuthRemoteRepository();
  final authLocalRepository = AuthLocalRepository();
  final spService = SpService();

  void signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      await authRemoteRepository.signUp(
        name: name,
        email: email,
        password: password,
      );
      emit(AuthSignUp());
    } catch (e) {
      emit(AuthError("auth_cubit signup -> ${e.toString()}"));
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final userModel = await authRemoteRepository.login(
        email: email,
        password: password,
      );
      if (userModel.token.isNotEmpty) {
        await spService.setToken(userModel.token);
      }
      await authLocalRepository.insertUser(userModel);
      emit(AuthLoggedIn(userModel));
    } catch (e) {
      emit(AuthError("auth_cubit login -> ${e.toString()}"));
    }
  }

  void getUserData() async {
    try {
      emit(AuthLoading());
      final userModel = await authRemoteRepository.getUserData();
      if (userModel != null) {
        await authLocalRepository.insertUser(userModel);
        emit(AuthLoggedIn(userModel));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }
}
