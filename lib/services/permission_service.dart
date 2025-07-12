import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> requestNotificationPermission() async {
    // Notification permission ka status check karte hain
    PermissionStatus status = await Permission.notification.status;

    // Agar permission granted nahi hai, toh request karte hain
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }
}
