import 'package:flutter/material.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _confirmSOS(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm SOS"),
        content: const Text(
          "Are you sure you want to send an emergency SOS?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              _showSnack(context, "🚨 SOS Sent to trusted contacts!");
            },
            child: const Text("SEND SOS"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Safety"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🚨 SOS CARD
          Card(
            color: Colors.red.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.warning_rounded,
                    size: 56,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Emergency SOS",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tap the button below to alert your trusted contacts.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => _confirmSOS(context),
                    icon: const Icon(Icons.sos),
                    label: const Text("SEND SOS"),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 🛡️ SAFETY TOOLS
          const Text(
            "Safety Tools",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          _safetyTile(
            context,
            icon: Icons.call,
            title: "Fake Call",
            subtitle: "Simulate an incoming call",
            message: "📞 Fake call activated",
          ),
          _safetyTile(
            context,
            icon: Icons.location_on,
            title: "Share Live Location",
            subtitle: "Send location to contacts",
            message: "📍 Location shared",
          ),
          _safetyTile(
            context,
            icon: Icons.volume_up,
            title: "Loud Siren",
            subtitle: "Attract attention nearby",
            message: "🔊 Siren started",
          ),

          const SizedBox(height: 24),

          // 📞 EMERGENCY NUMBERS
          const Text(
            "Emergency Numbers",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          _emergencyNumber(context, "Police", "100"),
          _emergencyNumber(context, "Women Helpline", "181"),
          _emergencyNumber(context, "Ambulance", "108"),
        ],
      ),
    );
  }

  Widget _safetyTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required String message,
      }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _showSnack(context, message),
      ),
    );
  }

  Widget _emergencyNumber(
      BuildContext context,
      String title,
      String number,
      ) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.phone, color: Colors.red),
        title: Text(title),
        subtitle: Text(number),
        onTap: () => _showSnack(
          context,
          "📞 Calling $title ($number)",
        ),
      ),
    );
  }
}
