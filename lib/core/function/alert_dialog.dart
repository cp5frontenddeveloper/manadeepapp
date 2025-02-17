import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool>alertExitapp() async {
  bool exitApp = false;
  await Get.defaultDialog(
      title: "100".tr,
      middleText: "101".tr,
      actions: [
        ElevatedButton(onPressed: () {
          exitApp = true;
          exit(0);
        }, child: Text("102".tr)),
        ElevatedButton(
          onPressed: () {
            exitApp = false;
            Get.back();
          },
          child: Text("103".tr),
        )
      ]);
  return exitApp;
}
