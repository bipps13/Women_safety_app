import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationHistoryScreen extends StatefulWidget {
  const LocationHistoryScreen({super.key});

  @override
  State<LocationHistoryScreen> createState() => _LocationHistoryScreenState();
}

class _LocationHistoryScreenState extends State<LocationHistoryScreen> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> data =
        prefs.getStringList('location_history') ?? [];

    final List<Map<String, dynamic>> loadedHistory = data
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();

    if (!mounted) return;
    setState(() {
      history = loadedHistory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location History"),
        centerTitle: true,
      ),
      body: history.isEmpty
          ? const Center(
        child: Text(
          "No location shared yet 📍",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final h = history[index];

          return ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(
              h['name'] ?? 'Unknown Contact',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              h['time'] ?? '',
            ),
          );
        },
      ),
    );
  }
}
