import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestStoragePermission() async {
    try {
      PermissionStatus status;

      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;

        if (androidInfo.version.sdkInt >= 30) {
          status = await Permission.manageExternalStorage.status;
          if (status.isDenied || status.isRestricted || status.isLimited) {
            status = await Permission.manageExternalStorage.request();
          }
        } else {
          status = await Permission.storage.status;
          if (status.isDenied || status.isRestricted || status.isLimited) {
            status = await Permission.storage.request();
          }
        }
      } else {
        status = await Permission.storage.status;
        if (status.isDenied || status.isRestricted || status.isLimited) {
          status = await Permission.storage.request();
        }
      }

      log('Final storage permission status: $status');

      if (status.isGranted) {
        return true; // Permission granted
      } else if (status.isPermanentlyDenied) {
        Get.snackbar(
          'Permission Denied',
          'Storage permission is required to download files. Please enable it in the settings.',
          mainButton: TextButton(
            onPressed: () async {
              bool opened = await openAppSettings();
              if (!opened) {
                Get.snackbar(
                  'Settings Unavailable',
                  'Could not open settings. Please enable the permission manually.',
                  snackPosition: SnackPosition.TOP,
                );
              }
            },
            child: Text('Open Settings'),
          ),
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Permission Denied',
          'Storage permission is required to download files.',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      log('Error checking permissions: $e');
    }
    return false;
  }
}
