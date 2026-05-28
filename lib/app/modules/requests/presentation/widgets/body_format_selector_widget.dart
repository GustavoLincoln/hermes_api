import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:material_symbols_icons/symbols.dart';

enum BodyFormat {
  json('JSON', FluentIcons.code),
  xml('XML', Symbols.code_xml),
  html('HTML', FluentIcons.file_code),
  yaml('YAML', FluentIcons.bulleted_list),
  javascript('JavaScript', Symbols.javascript),
  markdown('Markdown', Symbols.markdown),
  raw('Raw', FluentIcons.text_document),
  hex('Hex', FluentIcons.calculator),
  base64('Base64', FluentIcons.password_field);

  const BodyFormat(this.label, this.icon);

  final String label;
  final IconData icon;
}

class BodyFormatSelectorWidget extends StatelessWidget {
  const BodyFormatSelectorWidget({
    required this.title,
    required this.lineCount,
    required this.selectedFormat,
    required this.onFormatChanged,
    super.key,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final int lineCount;
  final BodyFormat selectedFormat;
  final ValueChanged<BodyFormat> onFormatChanged;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  bool get _hasAction => actionLabel != null && onActionPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compactToolbar = constraints.maxWidth < 620;

        if (compactToolbar) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(title, style: theme.typography.subtitle),
                  const Spacer(),
                  Text(
                    '$lineCount lines',
                    style: theme.typography.caption?.copyWith(
                      color: const Color(0xFFB7BEC8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(child: _buildComboBox()),
                  if (_hasAction) ...<Widget>[
                    const SizedBox(width: 8),
                    Button(
                      onPressed: onActionPressed,
                      child: Text(actionLabel!),
                    ),
                  ],
                ],
              ),
            ],
          );
        }

        return Row(
          children: <Widget>[
            Text(title, style: theme.typography.subtitle),
            const Spacer(),
            Text(
              '$lineCount lines',
              style: theme.typography.caption?.copyWith(
                color: const Color(0xFFB7BEC8),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(width: 164, child: _buildComboBox()),
            if (_hasAction) ...<Widget>[
              const SizedBox(width: 8),
              Button(onPressed: onActionPressed, child: Text(actionLabel!)),
            ],
          ],
        );
      },
    );
  }

  Widget _buildComboBox() {
    return ComboBox<BodyFormat>(
      value: selectedFormat,
      items: BodyFormat.values
          .map(
            (format) => ComboBoxItem<BodyFormat>(
              value: format,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _FormatIcon(icon: format.icon),
                  const SizedBox(width: 8),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(format.label, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onFormatChanged(value);
        }
      },
    );
  }
}

class _FormatIcon extends StatelessWidget {
  const _FormatIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return material.Icon(
      icon,
      size: 14,
      color: IconTheme.of(context).color,
      fill: 1,
      weight: 500,
      opticalSize: 20,
    );
  }
}
