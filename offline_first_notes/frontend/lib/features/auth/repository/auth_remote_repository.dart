import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:offline_first_notes/core/constants/constants.dart';
import 'package:offline_first_notes/core/services/sp_service.dart';
import 'package:offline_first_notes/features/auth/repository/auth_local_repository.dart';
import 'package:offline_first_notes/models/user_model.dart';

class AuthRemoteRepository {
  final spService = SpService();
  final authLocalRepositroy = AuthLocalRepository();

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['error'];
      }
      return UserModel.fromJson(res.body);
    } catch (e) {
      throw ("auth_remote_repository -> ${e.toString()} ");
    }
  }

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }

      return UserModel.fromJson(res.body);
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        return null;
      }
      final res = await http
          .post(
            Uri.parse('${Constants.backendUri}/auth/tokenIsValid'),
            headers: {
              'Content-Type': 'application/json',
              'x-auth-token': token,
            },
          )
          .timeout(Duration(milliseconds: 250));
      if (res.statusCode != 200 || jsonDecode(res.body) == false) {
        return null;
      }
      final userResponse = await http.get(
        Uri.parse("${Constants.backendUri}/auth"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );
      if (userResponse.statusCode != 200) {
        throw jsonDecode(userResponse.body)['error'];
      }
      return UserModel.fromJson(userResponse.body);
    } catch (e) {
      final user = await authLocalRepositroy.getUser();
      return user;
    }
  }
}
