import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/services/local_notification/local_notification_service.dart';
import 'package:flutter_chatapp/views/screens/add_room/add_room_screen.dart';
import 'package:flutter_chatapp/views/screens/home/components/user_setting_button.dart';
import 'package:flutter_chatapp/views/screens/home/home_body.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static String routeName = "/home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    LocalNotificationService.initialize(context);

    // give message on which user taps and it opened the app from terminated state (app close)
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];
        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });

    // just in foreground (app must open)
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
      }

      LocalNotificationService.display(message);
    });

    // this just work when app in background (app not open) and user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];
      Navigator.of(context).pushNamed(routeFromMessage);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: const UserSettingButton(),
        centerTitle: true,
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_rounded, size: 22),
            splashRadius: 16,
            onPressed: () {
              Navigator.of(context).pushNamed(AddRoomScreen.routeName);
            },
          ),
        ],
      ),
      body: const HomeBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddRoomScreen.routeName);
        },
        child: const Icon(Icons.add_comment_rounded),
      ),
    );
  }
}
