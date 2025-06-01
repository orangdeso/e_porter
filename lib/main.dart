import 'dart:developer';
import 'package:e_porter/domain/bindings/app_binding.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  log("Firebase Initialized Successfully!");
  log(">>> Firebase project: ${Firebase.app().options.projectId}");
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
          initialBinding: AppBinding(),
          getPages: AppRoutes.routes,
        );
      },
    );
  }
}

// @override
//   void initState() {
//     super.initState();
//     _initDynamicLinks();
//   }

//   void _initDynamicLinks() async {
//     final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
//     _handleLink(data);

//     FirebaseDynamicLinks.instance.onLink.listen((data) {
//       _handleLink(data);
//     }).onError((e) {
//       // ignore
//     });
//   }

//   void _handleLink(PendingDynamicLinkData? data) {
//     final Uri? deepLink = data?.link;
//     if (deepLink == null) return;

//     final mode = deepLink.queryParameters['mode'];
//     final oobCode = deepLink.queryParameters['oobCode'];
//     if (mode == 'verifyEmail' && oobCode != null) {
//       FirebaseAuth.instance.applyActionCode(oobCode).then((_) async {
//         // 1) informasikan sukses
//         Get.snackbar("Sukses", "Email baru Anda telah terverifikasi.");

//         // 2) reload profile agar UI dan prefs ter-update
//         final profilC = Get.find<ProfilController>();
//         await profilC.reloadProfile();

//         // 3) (opsional) kembali ke layar Informasi Biodata
//         if (Get.currentRoute != Routes.INFORMATIONS) {
//           Get.toNamed(Routes.INFORMATIONS);
//         }
//       }).catchError((err) {
//         Get.snackbar("Gagal Verifikasi", err.toString());
//       });
//     }
//   }