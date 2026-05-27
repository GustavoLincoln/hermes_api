import 'package:fluent_ui/fluent_ui.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.title,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final typography = FluentTheme.of(context).typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: typography.title?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (subtitle != null) ...<Widget>[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: typography.caption?.copyWith(
              fontSize: 13,
              color: const Color(0xFFB7BEC8),
            ),
          ),
        ],
      ],
    );
  }
}
