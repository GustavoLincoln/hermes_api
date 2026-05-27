import 'package:fluent_ui/fluent_ui.dart';

class TitleBarSearchField extends StatelessWidget {
  const TitleBarSearchField({
    super.key,
    this.placeholder = 'Search requests, collections or environments',
  });

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return TextBox(
      placeholder: placeholder,
      style: const TextStyle(fontSize: 12, height: 1.0),
    );
  }
}
