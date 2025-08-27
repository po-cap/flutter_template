import 'package:get/get.dart';

class MyEditAddressController extends GetxController {
  MyEditAddressController();

  _initData() {
    update(["my_edit_address"]);
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
