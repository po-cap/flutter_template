import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/pages/index.dart';

class TabReviewView extends GetView<MyProfileController> {
  const TabReviewView({super.key});
  
  @override
  String? get tag => Get.arguments['user'].id.toString();

  @override
  Widget build(BuildContext context) {
    return const Text("評價");
  }
}