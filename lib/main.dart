import 'dart:developer';
import 'package:e_porter/data/repositories/transaction_repository_impl.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '_core/service/transaction_expiry_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  final transactionRepo = Get.put(TransactionRepositoryImpl());
  TransactionExpiryService().initialize(transactionRepo);

  log("Firebase Initialized Successfully!");
  runApp(MyApp(initialRoute: Routes.SPLASH));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 917),
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: true,
          initialRoute: initialRoute,
          getPages: AppRoutes.routes,
        );
      },
    );
  }
}
