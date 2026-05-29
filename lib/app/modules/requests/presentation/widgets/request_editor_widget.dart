import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hermes_api/app/core/ui/styles/text_styles.dart';

import '../../domain/enums/http_method_enum.dart';
import '../cubit/request_workbench_cubit.dart';
import '../cubit/request_workbench_state.dart';

class RequestEditorWidget extends StatefulWidget {
  const RequestEditorWidget({super.key});

  @override
  State<RequestEditorWidget> createState() => _RequestEditorWidgetState();
}

class _RequestEditorWidgetState extends State<RequestEditorWidget> {
  late final TextEditingController _urlController;
  late final TextEditingController _headersController;
  late final TextEditingController _queryParamsController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    final state = context.read<RequestWorkbenchCubit>().state;
    _urlController = TextEditingController(text: state.url);
    _headersController = TextEditingController(text: state.headersText);
    _queryParamsController = TextEditingController(text: state.queryParamsText);
    _bodyController = TextEditingController(text: state.body);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _headersController.dispose();
    _queryParamsController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RequestWorkbenchCubit, RequestWorkbenchState>(
      listenWhen: (previous, current) {
        return previous.url != current.url ||
            previous.headersText != current.headersText ||
            previous.queryParamsText != current.queryParamsText ||
            previous.body != current.body;
      },
      listener: (_, state) {
        _syncController(_urlController, state.url);
        _syncController(_headersController, state.headersText);
        _syncController(_queryParamsController, state.queryParamsText);
        _syncController(_bodyController, state.body);
      },
      child: BlocBuilder<RequestWorkbenchCubit, RequestWorkbenchState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 140,
                    child: DropdownButtonFormField<HttpMethodEnum>(
                      initialValue: state.method,
                      items: HttpMethodEnum.values
                          .map(
                            (method) => DropdownMenuItem<HttpMethodEnum>(
                              value: method,
                              child: Text(method.label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          context.read<RequestWorkbenchCubit>().updateMethod(
                            value,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _urlController,
                      onChanged: context
                          .read<RequestWorkbenchCubit>()
                          .updateUrl,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 14,
                        height: 1.45,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'URL',
                        hintText: 'https://api.example.com/users',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: state.isLoading
                        ? null
                        : context.read<RequestWorkbenchCubit>().execute,
                    icon: state.isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.play_arrow_rounded),
                    label: const Text('Send'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _LabeledField(
                        label: 'Headers',
                        hint: 'Authorization: Bearer token',
                        controller: _headersController,
                        onChanged: context
                            .read<RequestWorkbenchCubit>()
                            .updateHeaders,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _LabeledField(
                        label: 'Query Params',
                        hint: 'page=1',
                        controller: _queryParamsController,
                        onChanged: context
                            .read<RequestWorkbenchCubit>()
                            .updateQueryParams,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _LabeledField(
                  label: 'Body',
                  hint: '{\n  "name": "Hermes"\n}',
                  controller: _bodyController,
                  onChanged: context.read<RequestWorkbenchCubit>().updateBody,
                  expands: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text == value) {
      return;
    }

    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.expands = false,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool expands;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            expands: expands,
            minLines: expands ? null : 8,
            maxLines: expands ? null : 8,
            style: TextStyles.labelCaps,
            // style: GoogleFonts.jetBrainsMono(fontSize: 13, height: 1.55),
            decoration: InputDecoration(
              hintText: hint,
              alignLabelWithHint: true,
            ),
          ),
        ),
      ],
    );
  }
}
