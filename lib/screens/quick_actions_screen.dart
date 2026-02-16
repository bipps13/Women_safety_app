import 'package:flutter/material.dart';
import '../widgets/action_card.dart';
import 'share_location_screen.dart';
import 'trusted_contacts_screen.dart';
import 'safety_tips_screen.dart';
import 'fake_call_screen.dart';

class QuickActionsScreen extends StatelessWidget {
  const QuickActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      // 🔴 SOS BUTTON
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onLongPress: () {
          // TODO: call sendSOS()
        },
        child: Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Colors.red, Colors.redAccent],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.1),
                blurRadius: 20,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              "SOS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  ActionCard(
                    title: "Share Location",
                    subtitle: "Send live location",
                    icon: Icons.location_on,
                    gradientColors: const [Color(0xFF2193b0), Color(0xFF6dd5ed)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShareLocationScreen(),
                        ),
                      );
                    },
                  ),
                  ActionCard(
                    title: "Trusted Contacts",
                    subtitle: "Manage trusted people",
                    icon: Icons.shield,
                    gradientColors: const [Color(0xFF56ab2f), Color(0xFFa8e063)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TrustedContactsScreen(),
                        ),
                      );
                    },
                  ),
                  ActionCard(
                    title: "Fake Call",
                    subtitle: "Instant escape call",
                    icon: Icons.call,
                    gradientColors: const [Color(0xFF614385), Color(0xFF516395)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FakeCallScreen(),
                        ),
                      );
                    },
                  ),
                  ActionCard(
                    title: "Safety Tips",
                    subtitle: "Stay prepared",
                    icon: Icons.lightbulb,
                    gradientColors: const [Color(0xFFf7971e), Color(0xFFffd200)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SafetyTipsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
