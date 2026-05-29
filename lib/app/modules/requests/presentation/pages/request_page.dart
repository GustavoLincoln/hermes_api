import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hermes_api/app/core/ui/styles/text_styles.dart';
import 'package:hermes_api/app/modules/requests/presentation/widgets/status_code_pill_widget.dart';

import '../../../../shared/widgets/panel_card.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../../../shared/widgets/tab_bar_widget.dart';
import '../../domain/entities/api_request_entity.dart';
import '../../domain/enums/http_method_enum.dart';
import '../cubit/request_workbench_cubit.dart';
import '../cubit/request_workbench_state.dart';
import '../widgets/body_format_selector_widget.dart';
import '../widgets/query_params_table_widget.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  late final TextEditingController _urlController;
  late final TextEditingController _headersController;
  late final TextEditingController _bodyController;
  late final TextEditingController _curlController;
  BodyFormat _bodyFormat = BodyFormat.json;
  BodyFormat _responseBodyFormat = BodyFormat.json;

  @override
  void initState() {
    super.initState();
    final state = context.read<RequestWorkbenchCubit>().state;
    _urlController = TextEditingController(text: state.url);
    _headersController = TextEditingController(text: state.headersText);
    _bodyController = TextEditingController(text: state.body);
    _curlController = TextEditingController(text: state.curlInput);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _headersController.dispose();
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
          previous.body != current.body ||
          previous.curlInput != current.curlInput,
      listener: (context, state) {
        _syncController(_urlController, state.url);
        _syncController(_headersController, state.headersText);
        _syncController(_bodyController, state.body);
        _syncController(_curlController, state.curlInput);
      },
      child: BlocBuilder<RequestWorkbenchCubit, RequestWorkbenchState>(
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 1200;
              final compactBottomSection = constraints.maxWidth < 980;
              final requiresPageScroll =
                  constraints.maxHeight <
                  (stacked || compactBottomSection ? 980 : 720);

              if (requiresPageScroll) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      children: <Widget>[
                        if (stacked)
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: 520,
                                child: _buildEditor(context, state),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 360,
                                child: _buildResponse(context, state),
                              ),
                            ],
                          )
                        else
                          SizedBox(
                            height: 520,
                            child: Row(
                              children: <Widget>[
                                Expanded(child: _buildEditor(context, state)),
                                const SizedBox(width: 16),
                                Expanded(child: _buildResponse(context, state)),
                              ],
                            ),
                          ),
                        const SizedBox(height: 16),
                        if (compactBottomSection)
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: 260,
                                child: _buildCurlTools(context, state),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 260,
                                child: _buildHistory(context, state),
                              ),
                            ],
                          )
                        else
                          SizedBox(
                            height: 260,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: _buildCurlTools(context, state),
                                ),
                                const SizedBox(width: 16),
                                Expanded(child: _buildHistory(context, state)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }

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
                    height: compactBottomSection ? 536 : 260,
                    child: compactBottomSection
                        ? Column(
                            children: <Widget>[
                              Expanded(child: _buildCurlTools(context, state)),
                              const SizedBox(height: 16),
                              Expanded(child: _buildHistory(context, state)),
                            ],
                          )
                        : Row(
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compactHeader = constraints.maxWidth < 560;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SectionTitle(
                title: 'Request Editor',
                subtitle:
                    'Compose HTTP requests with a desktop-first workbench inspired by Terminal and WinUI tools.',
              ),
              const SizedBox(height: 18),
              _RequestHeaderBar(
                compact: compactHeader,
                state: state,
                urlController: _urlController,
                onMethodChanged: cubit.updateMethod,
                onUrlChanged: cubit.updateUrl,
                onExecute: cubit.execute,
              ),
              const SizedBox(height: 18),
              Expanded(
                child: TabBarWidget(
                  items: <TabBarItem>[
                    TabBarItem(
                      label: 'Headers',
                      child: _EditorField(
                        title: 'Headers',
                        placeholder: 'Authorization: Bearer token',
                        controller: _headersController,
                        onChanged: cubit.updateHeaders,
                      ),
                    ),
                    TabBarItem(
                      label: 'Query Params',
                      child: QueryParamsTableWidget(
                        value: state.queryParamsText,
                        onChanged: cubit.updateQueryParams,
                      ),
                    ),
                    TabBarItem(
                      label: 'Body',
                      child: _BodyEditorField(
                        controller: _bodyController,
                        onChanged: cubit.updateBody,
                        selectedFormat: _bodyFormat,
                        onFormatChanged: (format) {
                          setState(() {
                            _bodyFormat = format;
                          });
                        },
                        onFormatPressed: () {
                          final formattedBody = _tryFormatBody(
                            _bodyController.text,
                            _bodyFormat,
                          );
                          _bodyController.value = _bodyController.value
                              .copyWith(
                                text: formattedBody,
                                selection: TextSelection.collapsed(
                                  offset: formattedBody.length,
                                ),
                                composing: TextRange.empty,
                              );
                          cubit.updateBody(formattedBody);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
                    StatusCodePillWidget(statusCode: response.statusCode),
                    _MetricPill(
                      label: 'Time',
                      value: '${response.duration.inMilliseconds} ms',
                    ),
                    _MetricPill(
                      label: 'Headers',
                      value: '${response.headers.length}',
                    ),
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
                child: Text(
                  'Send a request to inspect status, headers and body.',
                ),
              ),
            )
          else
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _ResponseBodyPanel(
                      content: response.body.isEmpty
                          ? 'No body returned.'
                          : response.body,
                      selectedFormat: _responseBodyFormat,
                      onFormatChanged: (format) {
                        setState(() {
                          _responseBodyFormat = format;
                        });
                      },
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
              placeholder:
                  "curl -X POST 'https://api.example.com' -H 'Content-Type: application/json'",
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
                ? const Center(child: Text('No local history yet.'))
                : ListView.separated(
                    itemCount: state.history.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
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

class _RequestHeaderBar extends StatelessWidget {
  const _RequestHeaderBar({
    required this.compact,
    required this.state,
    required this.urlController,
    required this.onMethodChanged,
    required this.onUrlChanged,
    required this.onExecute,
  });

  final bool compact;
  final RequestWorkbenchState state;
  final TextEditingController urlController;
  final ValueChanged<HttpMethodEnum> onMethodChanged;
  final ValueChanged<String> onUrlChanged;
  final Future<void> Function() onExecute;

  @override
  Widget build(BuildContext context) {
    final methodPicker = SizedBox(
      width: compact ? double.infinity : 150,
      child: ComboBox<HttpMethodEnum>(
        value: state.method,
        items: HttpMethodEnum.values
            .map(
              (method) => ComboBoxItem<HttpMethodEnum>(
                value: method,
                child: Text(
                  method.label,
                  style: TextStyles.labelCaps.copyWith(color: method.color),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            onMethodChanged(value);
          }
        },
      ),
    );

    final urlField = TextBox(
      controller: urlController,
      placeholder: 'https://api.example.com/v1/users',
      onChanged: onUrlChanged,
      style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 13),
    );

    final sendButton = FilledButton(
      onPressed: state.isLoading ? null : onExecute,
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
    );

    if (compact) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: methodPicker),
              const SizedBox(width: 12),
              Expanded(child: sendButton),
            ],
          ),
          const SizedBox(height: 12),
          urlField,
        ],
      );
    }

    return Row(
      children: <Widget>[
        methodPicker,
        const SizedBox(width: 12),
        Expanded(child: urlField),
        const SizedBox(width: 12),
        sendButton,
      ],
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
    final textBox = TextBox(
      controller: controller,
      onChanged: onChanged,
      maxLines: null,
      expands: true,
      minLines: null,
      placeholder: placeholder,
      style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12.5),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: FluentTheme.of(context).typography.subtitle),
        const SizedBox(height: 8),
        Expanded(child: textBox),
      ],
    );
  }
}

class _BodyEditorField extends StatelessWidget {
  const _BodyEditorField({
    required this.controller,
    required this.onChanged,
    required this.selectedFormat,
    required this.onFormatChanged,
    required this.onFormatPressed,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final BodyFormat selectedFormat;
  final ValueChanged<BodyFormat> onFormatChanged;
  final VoidCallback onFormatPressed;

  @override
  Widget build(BuildContext context) {
    final lineCount = _countLines(controller.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BodyFormatSelectorWidget(
          title: 'Body',
          lineCount: lineCount,
          selectedFormat: selectedFormat,
          onFormatChanged: onFormatChanged,
          actionLabel: 'Format',
          onActionPressed: onFormatPressed,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _LineNumberedTextBox(
            controller: controller,
            onChanged: onChanged,
            placeholder: '{\n  "name": "Hermes"\n}',
          ),
        ),
      ],
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.label, required this.value});

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
        style: FluentTheme.of(
          context,
        ).typography.caption?.copyWith(color: const Color(0xFFF3F5F7)),
      ),
    );
  }
}

int _countLines(String value) {
  if (value.isEmpty) {
    return 1;
  }
  return '\n'.allMatches(value).length + 1;
}

String _tryFormatBody(String value, BodyFormat format) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return value;
  }

  try {
    switch (format) {
      case BodyFormat.json:
      case BodyFormat.javascript:
        final decoded = jsonDecode(value);
        return const JsonEncoder.withIndent('  ').convert(decoded);
      case BodyFormat.base64:
        final decoded = utf8.decode(base64Decode(trimmed));
        try {
          return _tryFormatBody(decoded, BodyFormat.json);
        } catch (_) {
          return decoded;
        }
      case BodyFormat.hex:
        final decoded = utf8.decode(_decodeHex(trimmed));
        return decoded;
      case BodyFormat.xml:
      case BodyFormat.html:
        return _formatMarkup(trimmed);
      case BodyFormat.yaml:
        return _normalizeIndentedLines(trimmed);
      case BodyFormat.markdown:
      case BodyFormat.raw:
        return value;
    }
  } catch (_) {
    return value;
  }
}

List<int> _decodeHex(String value) {
  final sanitized = value
      .replaceAll(' ', '')
      .replaceAll('\n', '')
      .replaceAll('\r', '')
      .replaceAll('\t', '');
  if (sanitized.length.isOdd) {
    throw const FormatException('Invalid hex length');
  }

  return <int>[
    for (int i = 0; i < sanitized.length; i += 2)
      int.parse(sanitized.substring(i, i + 2), radix: 16),
  ];
}

String _normalizeIndentedLines(String value) {
  return value.split('\n').map((line) => line.trimRight()).join('\n');
}

String _formatMarkup(String value) {
  final tokens = value
      .replaceAll('><', '>\n<')
      .split('\n')
      .map((token) => token.trim())
      .where((token) => token.isNotEmpty);

  final buffer = StringBuffer();
  var indent = 0;

  for (final token in tokens) {
    final isClosingTag = token.startsWith('</');
    final isDeclaration = token.startsWith('<?') || token.startsWith('<!');
    final isSelfClosingTag =
        token.endsWith('/>') || !token.startsWith('<') || token.contains('</');

    if (isClosingTag && indent > 0) {
      indent--;
    }

    buffer.writeln('${'  ' * indent}$token');

    if (!isClosingTag &&
        !isDeclaration &&
        !isSelfClosingTag &&
        token.startsWith('<')) {
      indent++;
    }
  }

  return buffer.toString().trimRight();
}

class _CodePanel extends StatelessWidget {
  const _CodePanel({required this.title, required this.content});

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
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Text(title, style: FluentTheme.of(context).typography.subtitle),
            const SizedBox(height: 10),
            SelectableText(
              content,
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12.5,
                color: Color(0xFFF3F5F7),
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResponseBodyPanel extends StatelessWidget {
  const _ResponseBodyPanel({
    required this.content,
    required this.selectedFormat,
    required this.onFormatChanged,
  });

  final String content;
  final BodyFormat selectedFormat;
  final ValueChanged<BodyFormat> onFormatChanged;

  @override
  Widget build(BuildContext context) {
    final formattedContent = _tryFormatBody(content, selectedFormat);
    final lineCount = _countLines(formattedContent);

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
            BodyFormatSelectorWidget(
              title: 'Body',
              lineCount: lineCount,
              selectedFormat: selectedFormat,
              onFormatChanged: onFormatChanged,
            ),
            const SizedBox(height: 10),
            Expanded(child: _LineNumberedCodeView(content: formattedContent)),
          ],
        ),
      ),
    );
  }
}

class _LineNumberedTextBox extends StatefulWidget {
  const _LineNumberedTextBox({
    required this.controller,
    required this.onChanged,
    required this.placeholder,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String placeholder;

  @override
  State<_LineNumberedTextBox> createState() => _LineNumberedTextBoxState();
}

class _LineNumberedTextBoxState extends State<_LineNumberedTextBox> {
  final ScrollController _textScrollController = ScrollController();
  final ScrollController _gutterScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _textScrollController.addListener(_syncGutter);
  }

  @override
  void dispose() {
    _textScrollController
      ..removeListener(_syncGutter)
      ..dispose();
    _gutterScrollController.dispose();
    super.dispose();
  }

  void _syncGutter() {
    if (!_gutterScrollController.hasClients) {
      return;
    }

    final offset = _textScrollController.offset.clamp(
      0.0,
      _gutterScrollController.position.maxScrollExtent,
    );

    if ((_gutterScrollController.offset - offset).abs() > 0.5) {
      _gutterScrollController.jumpTo(offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _LineNumberedEditorFrame(
      lineCount: _countLines(widget.controller.text),
      gutterController: _gutterScrollController,
      child: TextBox(
        controller: widget.controller,
        onChanged: widget.onChanged,
        maxLines: null,
        expands: true,
        minLines: null,
        placeholder: widget.placeholder,
        scrollController: _textScrollController,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        style: const TextStyle(
          fontFamily: 'JetBrains Mono',
          fontSize: 12.5,
          height: 1.55,
        ),
      ),
    );
  }
}

class _LineNumberedCodeView extends StatefulWidget {
  const _LineNumberedCodeView({required this.content});

  final String content;

  @override
  State<_LineNumberedCodeView> createState() => _LineNumberedCodeViewState();
}

class _LineNumberedCodeViewState extends State<_LineNumberedCodeView> {
  final ScrollController _contentScrollController = ScrollController();
  final ScrollController _gutterScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _contentScrollController.addListener(_syncGutter);
  }

  @override
  void dispose() {
    _contentScrollController
      ..removeListener(_syncGutter)
      ..dispose();
    _gutterScrollController.dispose();
    super.dispose();
  }

  void _syncGutter() {
    if (!_gutterScrollController.hasClients) {
      return;
    }

    final offset = _contentScrollController.offset.clamp(
      0.0,
      _gutterScrollController.position.maxScrollExtent,
    );

    if ((_gutterScrollController.offset - offset).abs() > 0.5) {
      _gutterScrollController.jumpTo(offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _LineNumberedEditorFrame(
      lineCount: _countLines(widget.content),
      gutterController: _gutterScrollController,
      child: SingleChildScrollView(
        controller: _contentScrollController,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: SelectableText(
          widget.content,
          style: const TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 12.5,
            color: Color(0xFFF3F5F7),
            height: 1.55,
          ),
        ),
      ),
    );
  }
}

class _LineNumberedEditorFrame extends StatelessWidget {
  const _LineNumberedEditorFrame({
    required this.lineCount,
    required this.gutterController,
    required this.child,
  });

  final int lineCount;
  final ScrollController gutterController;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2228),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x443D434C)),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 46,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Color(0xFF171A1F),
                border: Border(right: BorderSide(color: Color(0x443D434C))),
              ),
              child: ListView.builder(
                controller: gutterController,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: lineCount,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 19.4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          '${index + 1}',
                          style: FluentTheme.of(context).typography.caption
                              ?.copyWith(
                                fontFamily: 'JetBrains Mono',
                                color: const Color(0xFF7E8794),
                              ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.request, required this.onTap});

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
