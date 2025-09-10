import 'package:flutter/material.dart';
import '../services/report_service.dart';
import 'package:geolocator/geolocator.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  bool _sending = false;
  Position? _pos;

  @override
  void initState() {
    super.initState();
    _tryGetLocation();
  }

  Future<void> _tryGetLocation() async {
    try {
      final p = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() => _pos = p);
    } catch (e) {
      // ignore
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _sending = true);
    final ok = await ReportService.sendIncident(
      title: _title,
      description: _description,
      lat: _pos?.latitude,
      lng: _pos?.longitude,
    );
    setState(() => _sending = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report submitted ✔')));
      _formKey.currentState!.reset();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to submit report')));
    }
  }

  void _openTrafficCams() {
    // For demo, open a dialog with some useful links
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Traffic Camera Links'),
        content: Column(mainAxisSize: MainAxisSize.min, children: const [
          Text('• JKIA Camera - (demo link)'),
          Text('• Thika Road Camera - (demo link)'),
          SizedBox(height: 8),
          Text('These are placeholders. Replace with real camera feeds when available.'),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Services & Settings'), backgroundColor: Colors.indigo),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.report_problem, color: Colors.red),
            title: const Text('Report an incident'),
            subtitle: const Text('Send a quick report to authorities / admin'),
            trailing: ElevatedButton(onPressed: () => _openReportModal(), child: const Text('Report')),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.orange),
            title: const Text('Traffic cameras'),
            subtitle: const Text('Open live camera feeds (demo)'),
            trailing: ElevatedButton(onPressed: _openTrafficCams, child: const Text('Open')),
          ),
        ),
        const SizedBox(height: 18),
        const Text('App', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            subtitle: const Text('Nairobi Traffic App — demo prototype'),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Send feedback'),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feedback form coming soon'))),
          ),
        ),
      ]),
    );
  }

  void _openReportModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Wrap(children: [
              const Text('Report Incident', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Title required' : null,
                onSaved: (v) => _title = v!.trim(),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 4,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Description required' : null,
                onSaved: (v) => _description = v!.trim(),
              ),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sending ? null : () async {
                    await _submitReport();
                    if (mounted) Navigator.pop(context);
                  },
                  child: _sending ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Send'),
                ),
              ])
            ]),
          ),
        ),
      ),
    );
  }
}
