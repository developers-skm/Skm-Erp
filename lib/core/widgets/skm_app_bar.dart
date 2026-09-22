import 'package:flutter/material.dart';

/// Standard SKM Egg app bar. Use across feature screens instead of raw
/// [AppBar] so title styling, back-button behavior, and trailing actions
/// stay consistent.
class SkmAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SkmAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          if (subtitle != null)
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(subtitle == null ? kToolbarHeight : kToolbarHeight + 12);
}
