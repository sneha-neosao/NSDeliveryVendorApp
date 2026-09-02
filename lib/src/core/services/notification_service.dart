import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:nsdelivery_vendor_app/src/core/session/session_manager.dart';

class NoficationService {
  // ============================================================
  // CHANNEL IDS
  // ============================================================

  /// 🔔 Special channel - ONLY this channel rings the bell repeatedly
  static const String bellChannelId = '1001';
  static const String bellChannelName = 'Order Assignments';

  /// 🔕 Normal channel - all other notifications
  static const String generalChannelId = 'general_channel';
  static const String generalChannelName = 'General';

  // ============================================================
  // STREAMS
  // ============================================================

  static final StreamController<RemoteMessage>
  _onMessageStreamController =
  StreamController<RemoteMessage>.broadcast();

  static Stream<RemoteMessage> get onMessageStream =>
      _onMessageStreamController.stream;

  static final StreamController<String>
  _onTokenRefreshStreamController =
  StreamController<String>.broadcast();

  static Stream<String> get onTokenRefreshStream =>
      _onTokenRefreshStreamController.stream;

  // ============================================================
  // LOCAL NOTIFICATION PLUGIN
  // ============================================================

  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // ============================================================
  // REQUEST PERMISSION
  // ============================================================

  static Future<void> requestNotificationPermission() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final NotificationSettings settings =
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // ============================================================
  // GET FCM TOKEN
  // ============================================================

  static Future<String?> getToken() async {
    try {
      final FirebaseMessaging messaging =
          FirebaseMessaging.instance;

      final String? token = await messaging.getToken();

      print('FCM Token: $token');

      return token;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  // ============================================================
  // INITIALIZE LOCAL NOTIFICATIONS
  // ============================================================

  static Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings
    androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('🔔 Local notification tapped with payload: ${response.payload}');
        // Stop ringing sound immediately on notification tap
        cancelAll();

        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final Map<String, dynamic> data =
            Map<String, dynamic>.from(jsonDecode(response.payload!));
            _onMessageStreamController.add(RemoteMessage(data: data));
          } catch (_) {
            _onMessageStreamController.add(
              RemoteMessage(data: {'payload': response.payload}),
            );
          }
        }
      },
    );

    // ==========================================================
    // 🔔 CHANNEL 1001 - BELL CHANNEL (REPEATED RINGING)
    // ==========================================================

    const AndroidNotificationChannel bellChannel =
    AndroidNotificationChannel(
      bellChannelId,
      bellChannelName,
      description:
      'Critical notifications that play the notification bell repeatedly',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(
        'notification_bell',
      ),
      enableVibration: true,
      enableLights: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    // ==========================================================
    // 🔕 GENERAL CHANNEL - NO CUSTOM BELL
    // ==========================================================

    const AndroidNotificationChannel generalChannel =
    AndroidNotificationChannel(
      generalChannelId,
      generalChannelName,
      description: 'General application notifications',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    final AndroidFlutterLocalNotificationsPlugin?
    androidPlugin =
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // Create / update channels
    await androidPlugin?.createNotificationChannel(
      bellChannel,
    );

    await androidPlugin?.createNotificationChannel(
      generalChannel,
    );

    print('========================================');
    print('Notification channels initialized');
    print('🔔 Bell Channel ID: $bellChannelId (Insistent Alarm Sound)');
    print('🔕 General Channel ID: $generalChannelId');
    print('========================================');
  }

  // ============================================================
  // CANCEL ALL NOTIFICATIONS (STOPS RINGING)
  // ============================================================

  static Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();

    print('🔔 All notifications cancelled.');
  }

  // ============================================================
  // SHOW LOCAL NOTIFICATION
  // ============================================================

  static Future<void> showLocalNotification(
      RemoteMessage message,
      ) async {
    // Skip manual local notification on iOS
    if (Platform.isIOS) {
      return;
    }

    final Map<String, dynamic> data = message.data;

    // Support both notification payload and data-only messages
    final String title = message.notification?.title ??
        data['title']?.toString() ??
        'New Order Assignment';
    final String body = message.notification?.body ??
        data['body']?.toString() ??
        data['message']?.toString() ??
        'You have a new order assignment';

    // ==========================================================
    // GET CHANNEL ID FROM FCM DATA & DETECT ORDER ASSIGNMENT
    // ==========================================================

    final String incomingChannelId =
        data['channel_id']?.toString() ??
            message.notification?.android?.channelId ??
            '';

    final String msgType = (data['type'] ?? data['notification_type'] ?? data['status'] ?? '').toString().toLowerCase();
    final String msgTitle = title.toLowerCase();

    final bool isAssignmentType =
        msgType == 'order_assignment' ||
            msgType == 'assigned' ||
            msgType == 'order_assigned' ||
            msgType == 'new_order' ||
            msgType == 'assignment' ||
            msgTitle.contains('assigned') ||
            msgTitle.contains('assignment') ||
            msgTitle.contains('new order') ||
            msgTitle.contains('new task');

    final bool shouldRingBell =
        incomingChannelId == bellChannelId || isAssignmentType;

    print('========================================');
    print('📩 Incoming Notification Display');
    print('🔔 Title: $title');
    print('📝 Body: $body');
    print('📦 Data: $data');
    print('📢 Incoming Channel ID: $incomingChannelId');
    print(
      shouldRingBell
          ? '🔔 ORDER ASSIGNMENT DETECTED → REPEATED BELL RINGING ACTIVE'
          : '🔕 GENERAL CHANNEL → NORMAL NOTIFICATION',
    );
    print('========================================');

    // ==========================================================
    // IMAGE
    // ==========================================================

    final String? imageUrl =
        message.notification?.android?.imageUrl ??
            message.notification?.apple?.imageUrl ??
            data['image']?.toString() ??
            data['image_url']?.toString();

    BigPictureStyleInformation? bigPictureStyleInformation;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final String filePath = await _downloadAndSaveImage(
          imageUrl,
          'notif_img_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(filePath),
          contentTitle: title,
          summaryText: body,
        );
      } catch (e) {
        print('❌ Failed to download notification image: $e');
      }
    }

    // ==========================================================
    // SELECT CHANNEL & SOUND
    // ==========================================================

    String channelId;
    String channelName;
    AndroidNotificationSound? customSound;

    if (shouldRingBell) {
      // 🔔 CHANNEL 1001
      channelId = bellChannelId;
      channelName = bellChannelName;
      customSound = const RawResourceAndroidNotificationSound(
        'notification_bell',
      );
    } else {
      // 🔕 GENERAL CHANNEL
      channelId = generalChannelId;
      channelName = generalChannelName;
      customSound = null;
    }

    // ==========================================================
    // ANDROID NOTIFICATION DETAILS
    // ==========================================================

    final AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: 'Channel for $channelName',

      // Max importance & priority for heads-up alert
      importance: shouldRingBell ? Importance.max : Importance.high,
      priority: shouldRingBell ? Priority.max : Priority.defaultPriority,

      // 🔔 Custom bell sound for channel 1001
      sound: customSound,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      color: const Color(0xFFFA6624),

      // 🔔 Alarm category & audio attributes ensure insistent looping
      category: shouldRingBell
          ? AndroidNotificationCategory.alarm
          : AndroidNotificationCategory.status,
      audioAttributesUsage: shouldRingBell
          ? AudioAttributesUsage.alarm
          : AudioAttributesUsage.notification,

      // 🔔 FLAG_INSISTENT (4) repeats audio until user dismisses or taps
      additionalFlags: shouldRingBell ? Int32List.fromList([4]) : null,

      autoCancel: true,
      ongoing: false,
      fullScreenIntent: shouldRingBell,

      styleInformation: bigPictureStyleInformation ??
          const DefaultStyleInformation(
            true,
            true,
          ),
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    // ==========================================================
    // SHOW NOTIFICATION
    // ==========================================================

    String? payloadString;
    try {
      payloadString = jsonEncode(data);
    } catch (_) {
      payloadString = data['payload']?.toString();
    }

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      platformDetails,
      payload: payloadString,
    );
  }

  // ============================================================
  // NOTIFICATION LISTENER
  // ============================================================

  static void initNotificationListener() {
    // ==========================================================
    // 1. TERMINATED STATE (App opened via notification tap)
    // ==========================================================

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('📲 App launched from terminated state via notification: ${message.data}');
        cancelAll();
        _onMessageStreamController.add(message);
      }
    }).catchError((e) {
      print('⚠️ Error checking initial FCM message: $e');
    });

    // ==========================================================
    // 2. FOREGROUND STATE
    // ==========================================================

    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {
        print('📩 Foreground FCM message received: ${message.messageId}');
        print('🔔 Title: ${message.notification?.title ?? message.data['title']}');
        print('📦 Data: ${message.data}');

        // Show local notification with repeated sound / banner
        showLocalNotification(message);

        // Notify UI subscribers
        _onMessageStreamController.add(message);
      },
    );

    // ==========================================================
    // 3. BACKGROUND STATE (Notification clicked / opened)
    // ==========================================================

    FirebaseMessaging.onMessageOpenedApp.listen(
          (RemoteMessage message) {
        print('📲 Notification opened by user: ${message.data}');
        cancelAll();
        _onMessageStreamController.add(message);
      },
    );

    // ==========================================================
    // 4. TOKEN REFRESH LISTENER
    // ==========================================================

    FirebaseMessaging.instance.onTokenRefresh.listen((String newToken) async {
      print('🔄 FCM Token refreshed: $newToken');
      await SessionManager.saveFirebaseToken(newToken);
      _onTokenRefreshStreamController.add(newToken);
    });
  }

  // ============================================================
  // DOWNLOAD NOTIFICATION IMAGE
  // ============================================================

  static Future<String> _downloadAndSaveImage(
      String url,
      String fileName,
      ) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';

    final http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to download image: ${response.statusCode}',
      );
    }

    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    return filePath;
  }
}