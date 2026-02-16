import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> allContacts = [];
  List<Contact> trustedContacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final permission = await Permission.contacts.request();
    if (!permission.isGranted) return;

    final contacts = await ContactsService.getContacts();
    setState(() => allContacts = contacts.toList());
  }

  void _toggleTrusted(Contact contact) {
    if (trustedContacts.contains(contact)) {
      trustedContacts.remove(contact);
    } else {
      if (trustedContacts.length >= 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Max 5 trusted contacts allowed")),
        );
        return;
      }
      trustedContacts.add(contact);
    }
    setState(() {});
  }

  void _showActions(Contact contact) {
    final phone = contact.phones!.isNotEmpty
        ? contact.phones!.first.value!
        : "No number";

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              phone,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _actionIcon(Icons.call, "Call", () {
                  launchUrl(Uri.parse("tel:$phone"));
                }),
                _actionIcon(Icons.message, "Text", () {
                  launchUrl(Uri.parse("sms:$phone"));
                }),
                _actionIcon(Icons.location_on, "Location", () async {
                  final pos = await Geolocator.getCurrentPosition();
                  final url =
                      "https://maps.google.com/?q=${pos.latitude},${pos.longitude}";
                  launchUrl(Uri.parse("sms:$phone?body=$url"));
                }),
                _actionIcon(Icons.history, "History", () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("History coming soon")),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionIcon(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.deepPurple),
          iconSize: 30,
          onPressed: onTap,
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _contactTile(Contact c, {bool trusted = false}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: trusted ? Colors.green : Colors.deepPurple,
        child: Text(
          c.initials(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(c.displayName ?? "No Name"),
      subtitle: Text(
        c.phones!.isNotEmpty ? c.phones!.first.value! : "No number",
      ),
      trailing: trusted
          ? const Icon(Icons.verified, color: Colors.green)
          : IconButton(
        icon: const Icon(Icons.star_border),
        onPressed: () => _toggleTrusted(c),
      ),
      onTap: () => _showActions(c),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contacts")),
      body: ListView(
        children: [
          if (trustedContacts.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Trusted Contacts (Max 5)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...trustedContacts.map(
                  (c) => _contactTile(c, trusted: true),
            ),
            const Divider(),
          ],
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "All Contacts",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ...allContacts.map(_contactTile),
        ],
      ),
    );
  }
}
