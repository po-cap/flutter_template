import 'package:get/get.dart';

class MyEditItemController extends GetxController {
  MyEditItemController();

  _initData() {
    update(["my_edit_item"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
