import 'package:flutter/material.dart';

class SafetyTipsScreen extends StatelessWidget {
  const SafetyTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      {
        "icon": Icons.visibility,
        "title": "Stay Alert",
        "description":
        "Always be aware of your surroundings. Avoid distractions like using your phone while walking alone."
      },
      {
        "icon": Icons.share_location,
        "title": "Share Location",
        "description":
        "Keep your trusted contacts informed about your location when going out."
      },
      {
        "icon": Icons.backpack,
        "title": "Carry Essentials",
        "description":
        "Carry essentials like pepper spray, whistle, or personal alarm in your bag."
      },
      {
        "icon": Icons.phone,
        "title": "Emergency Contacts",
        "description":
        "Keep a list of trusted contacts and local helpline numbers for quick access."
      },
      {
        "icon": Icons.lightbulb,
        "title": "Trust Your Instincts",
        "description":
        "If something feels wrong, trust your gut and remove yourself from the situation."
      },
      {
        "icon": Icons.health_and_safety,
        "title": "Health & Menstrual Safety",
        "description":
        "Carry sanitary essentials and maintain hygiene. Know local women's health resources."
      },
      {
        "icon": Icons.directions_walk,
        "title": "Safe Routes",
        "description":
        "Plan your route ahead. Stick to well-lit and populated streets at night."
      },
      {
        "icon": Icons.warning,
        "title": "Avoid Risky Areas",
        "description":
        "Stay away from isolated areas, shortcuts, and places with poor lighting."
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Safety Tips"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: tips
              .map(
                (tip) => Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.deepPurple.withAlpha(50),
                      child: Icon(
                        tip["icon"] as IconData,
                        color: Colors.deepPurple,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tip["title"] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tip["description"] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}
