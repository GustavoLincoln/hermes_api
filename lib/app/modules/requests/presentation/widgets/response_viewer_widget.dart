import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/panel_card.dart';
import '../../../../shared/widgets/section_title.dart';
import '../cubit/request_workbench_state.dart';
import '../cubit/request_workbench_cubit.dart';

class ResponseViewerWidget extends StatelessWidget {
  const ResponseViewerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestWorkbenchCubit, RequestWorkbenchState>(
      builder: (context, state) {
        final response = state.response;
        final textTheme = Theme.of(context).textTheme;

        return PanelCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Expanded(
                    child: SectionTitle(
                      title: 'Response Viewer',
                      subtitle: 'Status, tempo, headers e corpo formatado para inspeção rápida.',
                    ),
                  ),
                  if (response != null)
                    Wrap(
                      spacing: 10,
                      children: <Widget>[
                        _MetricChip(label: 'Status', value: '${response.statusCode ?? '-'}'),
                        _MetricChip(label: 'Time', value: '${response.duration.inMilliseconds} ms'),
                        _MetricChip(label: 'Headers', value: '${response.headers.length}'),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 18),
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    state.errorMessage!,
                    style: textTheme.bodyMedium?.copyWith(color: const Color(0xFFFCA5A5)),
                  ),
                ),
              if (response == null)
                Expanded(
                  child: Center(
                    child: Text(
                      'Execute uma requisição para visualizar resposta, status code, headers e tempo.',
                      style: textTheme.bodyLarge?.copyWith(color: const Color(0xFF94A3B8)),
                    ),
                  ),
                )
              else
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _ScrollableCodePanel(
                          title: 'Body',
                          content: response.body.isEmpty ? 'Sem conteúdo.' : response.body,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _ScrollableCodePanel(
                          title: 'Headers',
                          content: response.headers.entries.map((entry) => '${entry.key}: ${entry.value}').join('\n'),
                        ),
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
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label: $value'));
  }
}

class _ScrollableCodePanel extends StatelessWidget {
  const _ScrollableCodePanel({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1524),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF243047)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: SelectableText(
                content,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  height: 1.55,
                  color: const Color(0xFFE5E2E1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
