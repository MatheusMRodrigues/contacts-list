import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technical/utils/palette.dart';
import 'package:technical/views/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: GetMaterialApp(
        title: 'THECHNICAL',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.pink,
            scaffoldBackgroundColor: Palette.lightYellow),
        home: const HomeView(),
      ),
    );
  }
}
