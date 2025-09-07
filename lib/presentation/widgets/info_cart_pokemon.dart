import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.icon,
    required this.mainText,
    required this.subText,
  });

  final IconData icon;
  final String mainText;
  final String subText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 48),
        Text(mainText, style: Theme.of(context).textTheme.headlineMedium),
        Text(
          subText,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
      ],
    );
  }
}
