import 'package:flutter/material.dart';

class LandmarkCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final VoidCallback onTap;

  const LandmarkCard({super.key, required this.name, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.place, color: Colors.deepPurple),
        title: Text(name),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
