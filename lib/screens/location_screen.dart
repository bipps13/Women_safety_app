import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final Location _location = Location();
  LocationData? _currentLocation;
  bool _loading = true;

  // 🔹 Dummy trusted contacts (later Firebase/DB)
  final List<Map<String, String>> trustedContacts = [
    {"name": "Mom", "phone": "+91 8788572485"},
    {"name": "Best Friend", "phone": "+91 9028363017"},
    {"name": "Sister", "phone": "+91 99270864790"},
  ];

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  // 📍 Fetch live location safely
  Future<void> _fetchLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
        if (permission != PermissionStatus.granted) return;
      }

      final loc = await _location.getLocation();
      setState(() {
        _currentLocation = loc;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _showSnack("Failed to get location");
    }
  }

  // 📤 Share location (UI logic only)
  void _shareLocation(String name) {
    if (_currentLocation == null) {
      _showSnack("Location not available yet");
      return;
    }

    final lat = _currentLocation!.latitude;
    final lng = _currentLocation!.longitude;

    _showSnack("📍 Location shared with $name");

    // 🔥 FUTURE:
    // SMS API
    // WhatsApp deep link
    // Firebase trigger
    // Google Maps link:
    // https://www.google.com/maps?q=$lat,$lng
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Share Live Location"),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 LOCATION CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on,
                      color: Color(0xFF6A1B9A)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _loading
                        ? const Text("Fetching location...")
                        : Text(
                      "Latitude: ${_currentLocation?.latitude}\nLongitude: ${_currentLocation?.longitude}",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _fetchLocation,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Trusted Contacts",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
              ),
            ),
            const SizedBox(height: 12),

            // 🔹 CONTACT LIST
            Expanded(
              child: ListView.builder(
                itemCount: trustedContacts.length,
                itemBuilder: (context, index) {
                  final contact = trustedContacts[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFF6A1B9A),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(contact["name"]!),
                      subtitle: Text(contact["phone"]!),
                      trailing: IconButton(
                        icon: const Icon(Icons.send, color: Colors.green),
                        onPressed: () =>
                            _shareLocation(contact["name"]!),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
