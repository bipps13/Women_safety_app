import 'package:flutter/material.dart';

class FakeCallScreen extends StatelessWidget {
  const FakeCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 40),

            Column(
              children: const [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  "Mom ❤️",
                  style: TextStyle(color: Colors.white, fontSize: 26),
                ),
                SizedBox(height: 6),
                Text(
                  "Incoming call...",
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ❌ Reject
                  FloatingActionButton(
                    heroTag: "reject",
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.call_end),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  // ✅ Accept (still fake)
                  FloatingActionButton(
                    heroTag: "accept",
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.call),
                    onPressed: () {
                      Navigator.pop(context);
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
