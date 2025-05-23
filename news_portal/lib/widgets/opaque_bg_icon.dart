import 'package:flutter/material.dart';

class OpaqueBgIcon extends StatelessWidget {
  final IconData icon;
  const OpaqueBgIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.6), shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Icon(icon, size: 30, color: theme.colorScheme.onBackground),
        ));
  }
}
