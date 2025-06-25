import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final List<String> segments;

  PieChartWidget({required this.segments});

  @override
  Widget build(BuildContext context) {
    if (segments.isNotEmpty) {
      return GridView.count(
        crossAxisCount: segments.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: segments.map((segment) => Image.asset(segment, scale: 0.33)).toList(),
      );
    }

    return const SizedBox();
  }
}
