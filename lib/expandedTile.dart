import 'package:flutter/material.dart';

class Expandedtile extends StatelessWidget {
  final Text subtitle;
  final int weekNum;
  final List<Widget> children;

  const Expandedtile({super.key, required this.subtitle, required this.weekNum, required this.children});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Week $weekNum"),
      subtitle: subtitle,
      collapsedBackgroundColor: const Color.fromARGB(255, 197, 197, 197),
      children: children,
    );
  }
}