import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/landmark_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;
  String _status = "Getting location...";
  bool _loading = true;

  // Same landmarks list you used earlier
  final List<Map<String, dynamic>> _landmarks = [
    {"name": "KICC", "lat": -1.2921, "lng": 36.8219},
    {"name": "Westlands", "lat": -1.2676, "lng": 36.8103},
    {"name": "Karen", "lat": -1.3197, "lng": 36.6859},
    {"name": "Eastlands", "lat": -1.2841, "lng": 36.8913},
    {"name": "Thika Road", "lat": -1.2297, "lng": 36.8973},
  ];

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    setState(() {
      _loading = true;
      _status = "Checking location...";
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _status = "Location services disabled";
        _loading = false;
      });
      return;
    }

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
      setState(() {
        _status = "Location permission denied";
        _loading = false;
      });
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      setState(() {
        _currentPosition = pos;
        _status = "Location found";
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _status = "Error getting location";
        _loading = false;
      });
    }
  }

  double _distanceTo(Map<String, dynamic> lm) {
    if (_currentPosition == null) return 0.0;
    final d = Distance();
    final meters = d(LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        LatLng(lm['lat'], lm['lng']));
    return meters / 1000.0;
  }

  void _openDestination(Map<String, dynamic> lm) {
    // For demo: show simple dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lm['name']),
        content: Text('Open navigation or show details for ${lm['name']}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  void _openQuickAction(String action) {
    if (action == "Find Route") {
      // navigate to routes screen
      // Use Navigator.of(context).push if standalone page is desired
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Routes coming soon')));
    } else if (action == "Report") {
      // go to services (we placed services under Settings tab)
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open Services tab')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nairobi Traffic Navigator'),
        elevation: 0,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            onPressed: _fetchLocation,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh location',
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchLocation,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Welcome card
            Container(
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF3F51B5), Color(0xFF5E35B1)]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8)]),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.navigation, color: Colors.white)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Welcome back', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      const Text('Nairobi Traffic Navigator', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(_status, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            // Quick actions
            Row(children: [
              QuickActionCard(label: 'Find Route', icon: Icons.directions, color: Colors.teal, onTap: () => _openQuickAction('Find Route')),
              const SizedBox(width: 8),
              QuickActionCard(label: 'Report', icon: Icons.report_problem, color: Colors.redAccent, onTap: () => _openQuickAction('Report')),
            ]),
            const SizedBox(height: 18),

            // Nearby landmarks header
            const Text('Popular Destinations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Landmarks list
            for (var lm in _landmarks)
              LandmarkCard(
                name: lm['name'],
                subtitle: _currentPosition != null ? '${_distanceTo(lm).toStringAsFixed(1)} km away' : 'Enable location for distance',
                onTap: () => _openDestination(lm),
              ),

            const SizedBox(height: 12),

            // Mini widget: quick tips
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: Colors.indigo),
                    SizedBox(width: 10),
                    Expanded(child: Text('Tip: Use the Traffic tab to view live traffic markers. Tap a marker for details.')),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 36),
            Center(child: Text('End of Home • Pull down to refresh', style: TextStyle(color: Colors.grey[500]))),
          ],
        ),
      ),
    );
  }
}
