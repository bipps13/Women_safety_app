import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.onThemeChanged,
    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool darkMode = false;
  bool fakeCall = false;
  bool shareLocation = false;
  String language = "English";
  String userName = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      darkMode = prefs.getBool('darkMode') ?? false;
      fakeCall = prefs.getBool('fakeCall') ?? false;
      shareLocation = prefs.getBool('shareLocation') ?? false;
      language = prefs.getString('language') ?? "English";
      userName = prefs.getString('userName') ?? "User";
      phone = prefs.getString('phone') ?? "";
    });
  }

  Future<void> _save(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) await prefs.setBool(key, value);
    if (value is String) await prefs.setString(key, value);
  }

  void _editProfile() async {
    final nameCtrl = TextEditingController(text: userName);
    final phoneCtrl = TextEditingController(text: phone);

    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty) return;
              Navigator.pop(context, true);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );

    if (saved == true) {
      setState(() {
        userName = nameCtrl.text;
        phone = phoneCtrl.text;
      });
      _save('userName', userName);
      _save('phone', phone);
    }
  }

  void _selectLanguage() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("Select Language"),
        children: ["English", "Hindi", "Bengali", "Marathi"]
            .map(
              (l) => SimpleDialogOption(
            child: Text(l),
            onPressed: () => Navigator.pop(context, l),
          ),
        )
            .toList(),
      ),
    );

    if (selected != null) {
      setState(() => language = selected);
      _save('language', selected);
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', false);
      widget.onLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 45,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 10),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(phone),
                TextButton(
                  onPressed: _editProfile,
                  child: const Text("Edit Profile"),
                ),
              ],
            ),
          ),

          const Divider(height: 32),

          SwitchListTile(
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode),
            value: darkMode,
            onChanged: (val) {
              setState(() => darkMode = val);
              _save('darkMode', val);
              widget.onThemeChanged(val);
            },
          ),

          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            subtitle: Text(language),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _selectLanguage,
          ),

          SwitchListTile(
            title: const Text("Fake Call Shortcut"),
            secondary: const Icon(Icons.call),
            value: fakeCall,
            onChanged: (val) {
              setState(() => fakeCall = val);
              _save('fakeCall', val);
            },
          ),

          SwitchListTile(
            title: const Text("Share Location Shortcut"),
            secondary: const Icon(Icons.location_on),
            value: shareLocation,
            onChanged: (val) {
              setState(() => shareLocation = val);
              _save('shareLocation', val);
            },
          ),

          const SizedBox(height: 24),

          TextButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
