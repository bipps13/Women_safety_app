import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class SosService {
  static const String trustedNumber = "9270864790"; // Replace with your number

  /// Sends SOS via SMS and auto-calls
  static Future<void> sendSOS() async {
    try {
      // 1️⃣ Request necessary permissions
      await _requestPermissions();

      // 2️⃣ Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String locationUrl =
          "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

      String message =
          "🚨 SOS ALERT!\nI am in danger.\n📍 My location:\n$locationUrl\nPlease call me immediately.";

      // 3️⃣ Send SMS
      final Uri smsUri = Uri(
        scheme: 'sms',
        path: trustedNumber,
        queryParameters: {'body': message},
      );

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        log("Could not launch SMS app");
      }

      // 4️⃣ Auto-call
      final Uri callUri = Uri(
        scheme: 'tel',
        path: trustedNumber,
      );

      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      } else {
        log("Could not launch phone app");
      }
    } catch (e, stack) {
      log("Error sending SOS: $e", stackTrace: stack);
    }
  }

  /// Helper to request permissions
  static Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.sms,
      Permission.location,
    ].request();

    // Optional: check if permissions were granted
    if (statuses[Permission.sms] != PermissionStatus.granted) {
      log("SMS permission denied");
    }
    if (statuses[Permission.location] != PermissionStatus.granted) {
      log("Location permission denied");
    }
  }
}
