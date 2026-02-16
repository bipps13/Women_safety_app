import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../utils/sos_service.dart';
import '../screens/fake_call_screen.dart';
import '../screens/location_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final VoidCallback onLogout;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLogout,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double lastX = 0, lastY = 0, lastZ = 0;
  int shakeCount = 0;
  late StreamSubscription accelerometerSub;

  @override
  void initState() {
    super.initState();

    // 🔥 SHAKE TO SEND SOS
    accelerometerSub = accelerometerEvents.listen((event) {
      final delta =
          (event.x - lastX).abs() +
              (event.y - lastY).abs() +
              (event.z - lastZ).abs();

      if (delta > 30) {
        shakeCount++;
        if (shakeCount >= 2) {
          _sendSOS("Shake detected");
          shakeCount = 0;
        }
      }

      lastX = event.x;
      lastY = event.y;
      lastZ = event.z;
    });
  }

  @override
  void dispose() {
    accelerometerSub.cancel();
    super.dispose();
  }

  Future<void> _sendSOS(String source) async {
    await SosService.sendSOS();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🚨 SOS sent ($source)"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _triggerFakeCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("📞 Fake call in 5 seconds...")),
    );

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FakeCallScreen()),
      );
    });
  }

  void _comingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$feature coming soon 🚧")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stree Raksha"),
        actions: [
          // 🌙 Dark Mode Toggle
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
          ),

          // 🚪 Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onLogout,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3E8FF), Color(0xFFE1BEE7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _card(
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/illustrations/woman_safety.svg',
                        height: 150,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "You are not alone 💜",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6A1B9A),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                _card(
                  child: Column(
                    children: [
                      const Text(
                        "Emergency SOS",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onLongPress: () => _sendSOS("Long press"),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                            child: Text(
                              "HOLD TO SEND SOS",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text("Shake phone or long-press"),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                const Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
                const SizedBox(height: 16),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    ActionCard(
                      lottieAsset: 'assets/lottie/location.json',
                      title: "Share Location",
                      icon: Icons.location_on,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LocationScreen(),
                          ),
                        );
                      },
                    ),
                    ActionCard(
                      lottieAsset: 'assets/lottie/call.json',
                      title: "Fake Call",
                      icon: Icons.call,
                      onTap: _triggerFakeCall,
                    ),
                    ActionCard(
                      lottieAsset: 'assets/lottie/safety.json',
                      title: "Safety Tips",
                      icon: Icons.shield,
                      onTap: () => _comingSoon("Safety tips"),
                    ),
                    ActionCard(
                      lottieAsset: 'assets/lottie/contacts.json',
                      title: "Trusted Contacts",
                      icon: Icons.people,
                      onTap: () => _comingSoon("Trusted contacts"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: child,
    );
  }
}

// 🔹 ACTION CARD
class ActionCard extends StatelessWidget {
  final String lottieAsset;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.lottieAsset,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
              child: Lottie.asset(
                lottieAsset,
                errorBuilder: (_, __, ___) =>
                    Icon(icon, size: 32, color: Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
