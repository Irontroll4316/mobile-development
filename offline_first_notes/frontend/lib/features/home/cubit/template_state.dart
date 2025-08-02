part of 'template_cubit.dart';

sealed class TemplateState {
  const TemplateState();
}

final class TemplateLoading extends TemplateState {}

final class TemplateInitial extends TemplateState {}

final class TemplateError extends TemplateState {
  final String error;
  const TemplateError(this.error);
}

final class AddNewTemplateSuccess extends TemplateState {
  final TemplateModel templateModel;
  const AddNewTemplateSuccess(this.templateModel);
}

final class GetTemplatesSuccess extends TemplateState {
  final List<TemplateModel> templates;
  const GetTemplatesSuccess(this.templates);
}
