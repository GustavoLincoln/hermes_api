import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/panel_card.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../domain/entities/api_request_entity.dart';
import '../../domain/enums/http_method_enum.dart';
import '../cubit/request_workbench_cubit.dart';
import '../cubit/request_workbench_state.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  late final TextEditingController _urlController;
  late final TextEditingController _headersController;
  late final TextEditingController _queryController;
  late final TextEditingController _bodyController;
  late final TextEditingController _curlController;

  @override
  void initState() {
    super.initState();
    final state = context.read<RequestWorkbenchCubit>().state;
    _urlController = TextEditingController(text: state.url);
    _headersController = TextEditingController(text: state.headersText);
    _queryController = TextEditingController(text: state.queryParamsText);
    _bodyController = TextEditingController(text: state.body);
    _curlController = TextEditingController(text: state.curlInput);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _headersController.dispose();
    _queryController.dispose();
    _bodyController.dispose();
    _curlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RequestWorkbenchCubit, RequestWorkbenchState>(
      listenWhen: (previous, current) =>
          previous.url != current.url ||
          previous.headersText != current.headersText ||
          previous.queryParamsText != current.queryParamsText ||
          previous.body != current.body ||
          previous.curlInput != current.curlInput,
      listener: (context, state) {
        _syncController(_urlController, state.url);
        _syncController(_headersController, state.headersText);
        _syncController(_queryController, state.queryParamsText);
        _syncController(_bodyController, state.body);
        _syncController(_curlController, state.curlInput);
      },
      child: BlocBuilder<RequestWorkbenchCubit, RequestWorkbenchState>(
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 1200;
              return Column(
                children: <Widget>[
                  Expanded(
                    child: stacked
                        ? Column(
                            children: <Widget>[
                              Expanded(child: _buildEditor(context, state)),
                              const SizedBox(height: 16),
                              Expanded(child: _buildResponse(context, state)),
                            ],
                          )
                        : Row(
                            children: <Widget>[
                              Expanded(child: _buildEditor(context, state)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildResponse(context, state)),
                            ],
                          ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 260,
                    child: Row(
                      children: <Widget>[
                        Expanded(child: _buildCurlTools(context, state)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildHistory(context, state)),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEditor(BuildContext context, RequestWorkbenchState state) {
    final cubit = context.read<RequestWorkbenchCubit>();

    return PanelCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionTitle(
            title: 'Request Editor',
            subtitle:
                'Compose HTTP requests with a desktop-first workbench inspired by Terminal and WinUI tools.',
          ),
          const SizedBox(height: 18),
          Row(
            children: <Widget>[
              SizedBox(
                width: 150,
                child: ComboBox<HttpMethodEnum>(
                  value: state.method,
                  items: HttpMethodEnum.values
                      .map(
                        (method) => ComboBoxItem<HttpMethodEnum>(
                          value: method,
                          child: Text(method.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      cubit.updateMethod(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextBox(
                  controller: _urlController,
                  placeholder: 'https://api.example.com/v1/users',
                  onChanged: cubit.updateUrl,
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: state.isLoading ? null : cubit.execute,
                child: state.isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: ProgressRing(strokeWidth: 2),
                      )
                    : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(FluentIcons.send, size: 14),
                          SizedBox(width: 8),
                          Text('Send'),
                        ],
                      ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _EditorField(
                    title: 'Headers',
                    placeholder: 'Authorization: Bearer token',
                    controller: _headersController,
                    onChanged: cubit.updateHeaders,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _EditorField(
                    title: 'Query Params',
                    placeholder: 'page=1',
                    controller: _queryController,
                    onChanged: cubit.updateQueryParams,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _EditorField(
              title: 'Body',
              placeholder: '{\n  "name": "Hermes"\n}',
              controller: _bodyController,
              onChanged: cubit.updateBody,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponse(BuildContext context, RequestWorkbenchState state) {
    final response = state.response;

    return PanelCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Expanded(
                child: SectionTitle(
                  title: 'Response Viewer',
                  subtitle:
                      'Inspect body, headers, status code and duration with a readable WinUI-style result panel.',
                ),
              ),
              if (response != null)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _MetricPill(label: 'Status', value: '${response.statusCode ?? '-'}'),
                    _MetricPill(label: 'Time', value: '${response.duration.inMilliseconds} ms'),
                    _MetricPill(label: 'Headers', value: '${response.headers.length}'),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 18),
          if (state.errorMessage != null)
            InfoBar(
              title: const Text('Request issue'),
              content: Text(state.errorMessage!),
              severity: InfoBarSeverity.error,
            ),
          if (state.errorMessage != null) const SizedBox(height: 12),
          if (response == null)
            const Expanded(
              child: Center(
                child: Text('Send a request to inspect status, headers and body.'),
              ),
            )
          else
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _CodePanel(
                      title: 'Body',
                      content: response.body.isEmpty ? 'No body returned.' : response.body,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _CodePanel(
                      title: 'Headers',
                      content: response.headers.entries
                          .map((entry) => '${entry.key}: ${entry.value}')
                          .join('\n'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCurlTools(BuildContext context, RequestWorkbenchState state) {
    final cubit = context.read<RequestWorkbenchCubit>();

    return PanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionTitle(
            title: 'cURL Import / Export',
            subtitle:
                'Paste a command to hydrate the request editor or generate a clean cURL command from the current request.',
          ),
          const SizedBox(height: 14),
          Expanded(
            child: TextBox(
              controller: _curlController,
              placeholder: "curl -X POST 'https://api.example.com' -H 'Content-Type: application/json'",
              onChanged: cubit.updateCurlInput,
              maxLines: null,
              expands: true,
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Button(
                onPressed: cubit.importCurl,
                child: const Text('Import cURL'),
              ),
              const SizedBox(width: 10),
              FilledButton(
                onPressed: cubit.refreshGeneratedCurl,
                child: const Text('Generate cURL'),
              ),
            ],
          ),
          if (state.generatedCurl.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            Expanded(
              child: _CodePanel(
                title: 'Generated',
                content: state.generatedCurl,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHistory(BuildContext context, RequestWorkbenchState state) {
    final cubit = context.read<RequestWorkbenchCubit>();

    return PanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionTitle(
            title: 'History',
            subtitle:
                'Recent local requests stored offline for quick reuse during desktop workflows.',
          ),
          const SizedBox(height: 14),
          Expanded(
            child: state.history.isEmpty
                ? const Center(
                    child: Text('No local history yet.'),
                  )
                : ListView.separated(
                    itemCount: state.history.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final request = state.history[index];
                      return _HistoryTile(
                        request: request,
                        onTap: () => cubit.loadFromHistory(request),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text == value) return;
    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }
}

class _EditorField extends StatelessWidget {
  const _EditorField({
    required this.title,
    required this.placeholder,
    required this.controller,
    required this.onChanged,
  });

  final String title;
  final String placeholder;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: FluentTheme.of(context).typography.subtitle,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TextBox(
            controller: controller,
            onChanged: onChanged,
            maxLines: null,
            expands: true,
            minLines: null,
            placeholder: placeholder,
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 12.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x331A1D21),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x443D434C)),
      ),
      child: Text(
        '$label: $value',
        style: FluentTheme.of(context).typography.caption?.copyWith(
              color: const Color(0xFFF3F5F7),
            ),
      ),
    );
  }
}

class _CodePanel extends StatelessWidget {
  const _CodePanel({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xAA0F1114),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x443D434C)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: FluentTheme.of(context).typography.subtitle,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(
                  content,
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 12.5,
                    color: Color(0xFFF3F5F7),
                    height: 1.55,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.request,
    required this.onTap,
  });

  final ApiRequestEntity request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _methodColor(request.method);

    return HoverButton(
      onPressed: onTap,
      builder: (context, states) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: states.contains(WidgetState.hovered)
                ? const Color(0x331A1D21)
                : const Color(0x22171A1F),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x443D434C)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: color.withValues(alpha: 0.48)),
                ),
                child: Text(
                  request.method.label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      request.url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.createdAt?.toLocal().toString() ?? 'No timestamp',
                      style: FluentTheme.of(context).typography.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _methodColor(HttpMethodEnum method) {
    switch (method) {
      case HttpMethodEnum.get:
        return const Color(0xFF6CCB5F);
      case HttpMethodEnum.post:
        return const Color(0xFFFFD700);
      case HttpMethodEnum.put:
        return const Color(0xFF5AA9FF);
      case HttpMethodEnum.patch:
        return const Color(0xFFC58CFF);
      case HttpMethodEnum.delete:
        return const Color(0xFFFF6B6B);
    }
  }
}
