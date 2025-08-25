import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/pages/index.dart';

class TabKnowHowView extends GetView<MyProfileController> {
  const TabKnowHowView({super.key});
  
  @override
  String? get tag => Get.arguments['user'].id.toString();

  @override
  Widget build(BuildContext context) {
    return const Text("文章");
  }
}
