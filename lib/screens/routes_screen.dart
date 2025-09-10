import 'package:flutter/material.dart';

class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Routes'), backgroundColor: Colors.indigo),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Planned Routes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.work, color: Colors.deepPurple),
              title: const Text('Home → Work'),
              subtitle: const Text('Standard commute; estimated 22 min'),
              trailing: ElevatedButton(onPressed: () {}, child: const Text('Start')),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.orange),
              title: const Text('Sarit Centre → Village Market'),
              subtitle: const Text('Shopping route; avoid rush hours'),
              trailing: ElevatedButton(onPressed: () {}, child: const Text('Start')),
            ),
          ),
          const SizedBox(height: 18),
          const Text('Route Tools', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.map), label: const Text('Open in Map')),
          const SizedBox(height: 8),
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.share), label: const Text('Share route')),
        ]),
      ),
    );
  }
}
