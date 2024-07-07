import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  static final String serverKey = 'AIzaSyDanG5nODR1XMJE9vcmX5WKw8TP6E1XOSQ'; // Replace with your FCM server key

  static Future<void> sendNotificationToUser(String token) async {
    final data = {
      'to': token,
      'notification': {
        'title': "You have New Message",
        'body': "Hello, Someone contacted You ! Do Check, and get your Partner",
      },
    };

    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification');
      print('Status Code: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  }
}
