import 'package:get/get.dart';
import 'package:template/common/index.dart';

class MyAddressesController extends GetxController {
  MyAddressesController();

  _initData() {
    update(["my_addresses"]);
  }

  void onAddAddress() {
    Get.toNamed(RouteNames.myMyAddAddress);
  }

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
