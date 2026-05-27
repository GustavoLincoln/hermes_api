import 'package:fluent_ui/fluent_ui.dart';

class TitleBarMenuButton extends StatelessWidget {
  const TitleBarMenuButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: Button(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return const Color(0x331A1D21);
            }
            if (states.contains(WidgetState.hovered)) {
              return const Color(0x221A1D21);
            }
            return Colors.transparent;
          }),
        ),
        child: const Center(
          child: Icon(FluentIcons.global_nav_button, size: 14),
        ),
      ),
    );
  }
}
