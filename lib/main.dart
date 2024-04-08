import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarthealthcare/Models/Strings/app.dart';
import 'package:smarthealthcare/Models/Utils/Colors.dart';
import 'package:smarthealthcare/Views/Init/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  initializeNotifications();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  runApp(MyApp());
}

void initializeNotifications() {
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'emergency_smarthealthcare_group',
            channelKey: 'emergency_smarthealthcare',
            channelName: 'smarthealthcare notifications',
            channelDescription: 'Notification from smarthealthcare',
            defaultColor: colorPrimary,
            ledColor: color7)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'emergency_smarthealthcare_group',
            channelGroupName: 'smarthealthcare group')
      ],
      debug: true);
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: colorPrimary,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: colorDarkBg,
        statusBarIconBrightness: Brightness.light));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: app_name,
      theme: ThemeData(
        fontFamily: 'Raleway-Medium',
        primarySwatch: MaterialColor(0xFF030303, color),
        unselectedWidgetColor: color7,
      ),
      home: const SplashScreen(),
    );
  }

  Map<int, Color> color = {
    50: color3,
    100: color3,
    200: color3,
    300: color3,
    400: color3,
    500: color3,
    600: color3,
    700: color3,
    800: color3,
    900: color3,
  };
}
