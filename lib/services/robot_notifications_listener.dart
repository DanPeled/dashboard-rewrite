import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dot_cast/dot_cast.dart';
import 'package:elastic_dashboard/services/nt_connection.dart';

/// Listens to robot notifications from NetworkTables (NT) and triggers notifications
/// through the provided [onNotification] callback.
class RobotNotificationsListener {
  bool _alertFirstRun = true;
  final NTConnection ntConnection;
  final Function(String title, String description, Icon icon) onNotification;

  /// Constructs a [RobotNotificationsListener] instance.
  ///
  /// Requires an [NTConnection] instance for subscribing to notifications
  /// and a callback [onNotification] to handle received notifications.
  RobotNotificationsListener({
    required this.ntConnection,
    required this.onNotification,
  });

  /// Starts listening to robot notifications.
  void listen() {
    var notifications =
        ntConnection.subscribeAll('/Elastic/RobotNotifications', 0.2);
    notifications.listen((alertData, alertTimestamp) {
      if (alertData == null) {
        return;
      }
      _onAlert(alertData, alertTimestamp);
    });

    ntConnection.addDisconnectedListener(() => _alertFirstRun = true);
  }

  /// Handles incoming robot notification data.
  void _onAlert(Object alertData, int timestamp) {
    // Prevent showing a notification when we connect to NT for the first time
    if (_alertFirstRun) {
      _alertFirstRun = false;

      // If the alert existed 3 or more seconds before the client connected, ignore it
      Duration serverTime = Duration(microseconds: ntConnection.serverTime);
      Duration alertTime = Duration(microseconds: timestamp);

      // In theory if you had high enough latency and there was no existing data,
      // this would not work as intended. However, if you find yourself with 3
      // seconds of latency you have a much more serious issue to deal with as you
      // cannot control your robot with that much network latency, not to mention
      // that this code wouldn't even be executing since the RTT timestamp delay
      // would be so high that it would automatically disconnect from NT
      if ((serverTime - alertTime).inSeconds > 3) {
        return;
      }
    }

    Map<String, dynamic> data;
    try {
      data = jsonDecode(alertData.toString());
    } catch (e) {
      return;
    }

    if (!data.containsKey('level')) {
<<<<<<< HEAD
      // Invalid data format, do nothing
=======
>>>>>>> 8d8667119a03e9f68a44f6d693542ab070c13126
      return;
    }

    Icon icon;

    // Determine the icon based on the alert level
    if (data['level'] == 'INFO') {
      icon = const Icon(Icons.info);
    } else if (data['level'] == 'WARNING') {
      icon = const Icon(
        Icons.warning_amber,
        color: Colors.orange,
      );
    } else if (data['level'] == 'ERROR') {
      icon = const Icon(
        Icons.error,
        color: Colors.red,
      );
    } else {
      icon = const Icon(Icons.question_mark);
    }

    // Extract title and description from data
    String? title = tryCast(data['title']);
    String? description = tryCast(data['description']);

    if (title == null || description == null) {
      // If title or description is missing, do not process further
      return;
    }

    // Trigger the notification callback with the parsed data
    onNotification(title, description, icon);
  }
}
