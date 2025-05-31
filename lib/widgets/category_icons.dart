import 'package:flutter/material.dart';

class CategoryIcons extends StatelessWidget {
  const CategoryIcons({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': Icons.smoking_rooms, 'label': 'Pods'},
      {'icon': Icons.cloud, 'label': 'E-Liquids'},
      {'icon': Icons.bolt, 'label': 'Disposables'},
      {'icon': Icons.settings, 'label': 'Accessories'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: categories.map((cat) {
        return Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red.shade50,
              child: Icon(cat['icon'] as IconData, color: Colors.red),
            ),
            const SizedBox(height: 4),
            Text(cat['label'] as String),
          ],
        );
      }).toList(),
    );
  }
}
