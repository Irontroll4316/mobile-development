import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:offline_first_notes/core/constants/constants.dart';
import 'package:offline_first_notes/core/constants/utils.dart';
import 'package:offline_first_notes/features/home/repository/template_local_repository.dart';
import 'package:offline_first_notes/models/template_model.dart';

class TemplateRemoteRepository {
  final templateLocalRepository = TemplateLocalRepository();

  Future<TemplateModel> createTemplate({
    required String name,
    required String color,
    required String token,
    required String uid,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse("${Constants.backendUri}/templates"),
            headers: {
              'Content-Type': 'application/json',
              'x-auth-token': token,
            },
            body: jsonEncode({'name': name, 'color': color}),
          )
          .timeout(Duration(milliseconds: 250));
      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }
      return TemplateModel.fromJson(res.body);
    } catch (e) {
      try {
        final templateModel = TemplateModel(
          name: name,
          color: hexToRgb(color),
          uid: uid,
          createdAt: DateTime.now(),
          lastUsed: DateTime.now(),
          isSynced: 0,
        );
        await templateLocalRepository.insertTemplate(templateModel);
        return templateModel;
      } catch (e) {
        throw ("template_remote_repository.createTemplate -> \n${e.toString()}");
      }
    }
  }

  Future<List<TemplateModel>> getTemplates({required String token}) async {
    try {
      final res = await http
          .get(
            Uri.parse("${Constants.backendUri}/templates"),
            headers: {
              'Content-Type': 'application/json',
              'x-auth-token': token,
            },
          )
          .timeout(Duration(milliseconds: 250));
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['error'];
      }
      final listOfTemplates = jsonDecode(res.body);
      List<TemplateModel> templatesList = [];
      for (var element in listOfTemplates) {
        templatesList.add(TemplateModel.fromMap(element));
      }
      await templateLocalRepository.insertTemplates(templatesList);
      return templatesList;
    } catch (e) {
      final templates = await templateLocalRepository.getTemplates();
      if (templates.isNotEmpty) {
        return templates;
      }
      throw ("template_remote_repository.getTemplates -> \n${e.toString()}");
    }
  }

  Future<bool> syncTemplates({
    required String token,
    required List<TemplateModel> templates,
  }) async {
    try {
      final templateListInMapFormat = [];
      for (final template in templates) {
        templateListInMapFormat.add(template.toMap());
      }
      final res = await http
          .post(
            Uri.parse("${Constants.backendUri}/templates/sync"),
            headers: {
              'Content-Type': 'application/json',
              'x-auth-token': token,
            },
            body: jsonEncode(templateListInMapFormat),
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

  Future<bool> useTemplate({
    required String token,
    required String name,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse("${Constants.backendUri}/templates/use"),
            headers: {
              'Content-Type': 'application/json',
              'x-auth-token': token,
            },
            body: jsonEncode({'name': name}),
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
