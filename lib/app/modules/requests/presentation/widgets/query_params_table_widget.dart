import 'package:fluent_ui/fluent_ui.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/styles/radius_app.dart';
import '../../../../core/ui/styles/text_styles.dart';
import '../../../../shared/entities/key_value_entry.dart';

class QueryParamsTableWidget extends StatefulWidget {
  const QueryParamsTableWidget({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<QueryParamsTableWidget> createState() => _QueryParamsTableWidgetState();
}

class _QueryParamsTableWidgetState extends State<QueryParamsTableWidget> {
  late List<_QueryParamRowState> _rows;
  late String _lastSyncedValue;

  @override
  void initState() {
    super.initState();
    _lastSyncedValue = widget.value;
    _rows = _buildRows(widget.value);
  }

  @override
  void didUpdateWidget(covariant QueryParamsTableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _lastSyncedValue) {
      _disposeRows();
      _lastSyncedValue = widget.value;
      _rows = _buildRows(widget.value);
    }
  }

  @override
  void dispose() {
    _disposeRows();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Query Params',
          style: FluentTheme.of(context).typography.subtitle,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceLowest,
              borderRadius: BorderRadius.circular(RadiusApp.base),
              border: Border.all(color: AppTheme.outlineVariant),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppTheme.outlineVariant),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 34),
                      Expanded(
                        child: Text('Name', style: TextStyles.labelCaps),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('Value', style: TextStyles.labelCaps),
                      ),
                      const SizedBox(width: 32),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _rows.length,
                    itemBuilder: (context, index) {
                      final row = _rows[index];
                      final isLast = index == _rows.length - 1;

                      return Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isLast
                                  ? Colors.transparent
                                  : AppTheme.outlineVariant.withValues(
                                      alpha: 0.35,
                                    ),
                            ),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 34,
                              child: Checkbox(
                                checked: row.enabled,
                                onChanged: (checked) {
                                  setState(() {
                                    row.enabled = checked ?? true;
                                  });
                                  _notifyChanged();
                                },
                              ),
                            ),
                            Expanded(
                              child: _TableCellTextBox(
                                controller: row.keyController,
                                placeholder: 'Name',
                                onChanged: (_) => _onRowEdited(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _TableCellTextBox(
                                controller: row.valueController,
                                placeholder: 'Value',
                                onChanged: (_) => _onRowEdited(),
                              ),
                            ),
                            SizedBox(
                              width: 32,
                              child: row.isEffectivelyEmpty
                                  ? const SizedBox.shrink()
                                  : IconButton(
                                      icon: const Icon(
                                        FluentIcons.delete,
                                        size: 12,
                                      ),
                                      onPressed: () => _removeRow(index),
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onRowEdited() {
    setState(() {
      _ensureTrailingEmptyRow();
    });
    _notifyChanged();
  }

  void _removeRow(int index) {
    final row = _rows.removeAt(index);
    row.dispose();
    setState(_ensureTrailingEmptyRow);
    _notifyChanged();
  }

  void _notifyChanged() {
    final entries = _rows
        .where((row) => row.enabled && !row.isEffectivelyEmpty)
        .map(
          (row) => KeyValueEntry(
            key: row.keyController.text.trim(),
            value: row.valueController.text.trim(),
          ),
        )
        .toList();

    final text =
        entries.map((entry) => '${entry.key}=${entry.value}').join('\n');
    _lastSyncedValue = text;
    widget.onChanged(text);
  }

  List<_QueryParamRowState> _buildRows(String value) {
    final lines = value
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty);

    final rows = lines.map((line) {
      final separator = line.indexOf('=');
      if (separator == -1) {
        return _QueryParamRowState(key: line, value: '');
      }
      return _QueryParamRowState(
        key: line.substring(0, separator).trim(),
        value: line.substring(separator + 1).trim(),
      );
    }).toList();

    rows.add(_QueryParamRowState.empty());
    return rows;
  }

  void _ensureTrailingEmptyRow() {
    _rows.removeWhere((row) => row != _rows.last && row.isEffectivelyEmpty);
    if (_rows.isEmpty || !_rows.last.isEffectivelyEmpty) {
      _rows.add(_QueryParamRowState.empty());
    }
  }

  void _disposeRows() {
    for (final row in _rows) {
      row.dispose();
    }
  }
}

class _TableCellTextBox extends StatelessWidget {
  const _TableCellTextBox({
    required this.controller,
    required this.placeholder,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextBox(
      controller: controller,
      onChanged: onChanged,
      placeholder: placeholder,
      style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12.5),
      decoration: WidgetStatePropertyAll(
        BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(0),
          border: Border.all(color: Colors.transparent),
        ),
      ),
    );
  }
}

class _QueryParamRowState {
  _QueryParamRowState({required String key, required String value})
      : keyController = TextEditingController(text: key),
        enabled = true,
        valueController = TextEditingController(text: value);

  _QueryParamRowState.empty()
      : enabled = true,
        keyController = TextEditingController(),
        valueController = TextEditingController();

  final TextEditingController keyController;
  final TextEditingController valueController;
  bool enabled;

  bool get isEffectivelyEmpty =>
      keyController.text.trim().isEmpty && valueController.text.trim().isEmpty;

  void dispose() {
    keyController.dispose();
    valueController.dispose();
  }
}
