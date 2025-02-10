import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  print("Firebase Initialized Successfully!");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 917),
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: true,
          home: Scaffold(
            appBar: AppBar(title: Text('Firebase Setup Done!')),
            body: Center(child: Text('Firebase Initialized')),
          ),
        );
      },
    );
  }
}
