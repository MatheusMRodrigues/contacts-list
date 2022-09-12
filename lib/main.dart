import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:technical/app.dart';
import 'package:technical/utils/notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationApi.init(initScheduled: true);
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  runApp(const App());
}
