import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_notes/features/auth/cubit/auth_cubit.dart';
import 'package:offline_first_notes/features/home/cubit/template_cubit.dart';
import 'package:offline_first_notes/features/home/widgets/template_card.dart';
import 'package:offline_first_notes/models/template_model.dart';

class TemplatePicker extends StatefulWidget {
  final TemplateModel? template;
  final Function(TemplateModel) onTemplateChanged;
  const TemplatePicker({
    super.key,
    required this.template,
    required this.onTemplateChanged,
  });

  @override
  State<TemplatePicker> createState() => _TemplatePickerState();
}

class _TemplatePickerState extends State<TemplatePicker> {
  String picker = 'userTemplates';

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    context.read<TemplateCubit>().getAllTemplates(token: user.user.token);
    Connectivity().onConnectivityChanged.listen((data) async {
      if (data.contains(ConnectivityResult.wifi)) {
        await context.read<TemplateCubit>().syncTemplates(user.user.token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TemplateCubit, TemplateState>(
      listener: (context, state) {
        if (state is TemplateError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar((SnackBar(content: Text(state.error))));
        }
        if (state is AddNewTemplateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            (const SnackBar(content: Text("Template Added Succcessfully"))),
          );
        }
        setState(() {
          picker = 'userTemplates';
        });
      },
      builder: (context, state) {
        if (state is TemplateLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TemplateError) {
          return Center(child: Text('template_picker -> ${state.error}'));
        }
        if (state is GetTemplatesSuccess) {
          final templates = state.templates;

          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(16),
                  child: CupertinoSlidingSegmentedControl(
                    children: {
                      'userTemplates': Text(
                        "Your Templates",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      'addTemplate': Text(
                        "Add Template",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    },
                    onValueChanged: (String? str) {
                      if (str != null) {
                        setState(() {
                          picker = str;
                        });
                      }
                    },
                    groupValue: picker,
                  ),
                ),
              ),
              if (picker == 'userTemplates')
                Expanded(
                  child: ListView.builder(
                    itemCount: (templates.length / 2.0).ceil(),
                    itemBuilder: (context, index) {
                      final index1 = index * 2;
                      final index2 = index1 + 1;
                      final template1 = templates[index1];
                      TemplateModel? template2;
                      if (index2 < templates.length) {
                        template2 = templates[index2];
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => widget.onTemplateChanged(template1),
                              child: TemplateCard(
                                name: template1.name,
                                color: template1.color,
                                selected: widget.template?.name ?? '',
                              ),
                            ),
                          ),
                          Expanded(
                            child: (template2 != null)
                                ? GestureDetector(
                                    onTap: () =>
                                        widget.onTemplateChanged(template2!),
                                    child: TemplateCard(
                                      color: template2.color,
                                      name: template2.name,
                                      selected: widget.template?.name ?? '',
                                    ),
                                  )
                                : SizedBox(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              if (picker == 'addTemplate') Text("Hi There"),
            ],
          );
        } else {
          return Center(child: Text("You aren't supposed to see this :("));
        }
      },
    );
  }
}
