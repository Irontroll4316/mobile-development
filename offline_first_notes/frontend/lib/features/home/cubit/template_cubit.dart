import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_notes/core/constants/utils.dart';
import 'package:offline_first_notes/features/home/repository/template_local_repository.dart';
import 'package:offline_first_notes/features/home/repository/template_remote_repository.dart';
import 'package:offline_first_notes/models/template_model.dart';

part 'template_state.dart';

class TemplateCubit extends Cubit<TemplateState> {
  TemplateCubit() : super(TemplateInitial());
  final templateRemoteRepository = TemplateRemoteRepository();
  final templateLocalRepository = TemplateLocalRepository();

  Future<void> createNewTemplate({
    required String name,
    required Color color,
    required String uid,
    required String token,
  }) async {
    try {
      emit(TemplateLoading());
      final templateModel = await templateRemoteRepository.createTemplate(
        name: name,
        color: rgbToHex(color),
        token: token,
        uid: uid,
      );
      await templateLocalRepository.insertTemplate(templateModel);
      emit(AddNewTemplateSuccess(templateModel));
    } catch (e) {
      emit(
        TemplateError("template_cubit_createNewTemplate -> ${e.toString()}"),
      );
    }
  }

  Future<void> getAllTemplates({required String token}) async {
    try {
      emit(TemplateLoading());
      final templates = await templateRemoteRepository.getTemplates(
        token: token,
      );
      emit(GetTemplatesSuccess(templates));
    } catch (e) {
      emit(TemplateError("template_cubit.getAllTemplates -> ${e.toString()}"));
    }
  }

  Future<void> syncTemplates(String token) async {
    final unsyncedtemplates = await templateLocalRepository
        .getUnsycnedTemplates();
    if (unsyncedtemplates.isEmpty) return;
    final isSynced = await templateRemoteRepository.syncTemplates(
      token: token,
      templates: unsyncedtemplates,
    );
    if (isSynced) {
      for (final template in unsyncedtemplates) {
        templateLocalRepository.updateisSynced(template.name, 1);
      }
    }
  }

  Future<void> useTemplate(String token, String name) async {
    try {
      templateRemoteRepository.useTemplate(name: name, token: token);
    } catch (e) {
      emit(TemplateError("template_cubit.useTemplate -> ${e.toString()}"));
    }
  }
}
