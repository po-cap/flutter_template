import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

class MyAddAddressController extends GetxController with GetSingleTickerProviderStateMixin {
  MyAddAddressController();

  // tab 控制器
  late TabController tabController;

    // tab 控制器
  int tabIndex = 0;

  List<CityModel> cities = [];

  CityModel? selectedCity;

  DistrictModel? selectedDistrict;

  final receiverController = TextEditingController();

  final phoneController = TextEditingController();

  final streetController = TextEditingController();

  final storeController = TextEditingController();

  _initData() async {
    cities = await Address.load();
    update(["my_add_address"]);
  }

  // 切换 tab
  void onTapBarTap(int index) {
    tabIndex = index;
    tabController.animateTo(index);
    update(["my_add_address"]);
  }

  void onSelectCity(CityModel? city) {
    selectedCity = city;
    selectedDistrict = null;
    update(["my_add_address"]);
  }

  void onSelectDistrict(DistrictModel? district) {
    selectedDistrict = district;
    update(["my_add_address"]);
  }

  void onSubmit() {

    Loading.show();

    try{
      final address = AddressModel(
        receiver: receiverController.text,
        phone: phoneController.text,
        city: selectedCity!.name, 
        district: selectedDistrict!.name, 
        street: streetController.text, 
        zipCode: selectedDistrict!.zipCode, 
        type: tabIndex == 0 ? 'home' : tabIndex == 1 ? 'seven' : 'family', 
        store: storeController.text
      );

      final addresses = UserService.to.addresses;
      UserService.to.setAddresses(
        addresses..add(address)
      );
      Get.back();
      update(["my_add_address"]);
    }
    finally {
      Loading.dismiss();
    }
  }

  @override
  void onInit() {
    super.onInit();
    // 初始化 tab 控制器
    tabController = TabController(length: 3, vsync: this);

    // 监听 tab 切换
    tabController.addListener(() {
      tabIndex = tabController.index;
    update(["my_add_address"]);
    });
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
    receiverController.dispose();
    phoneController.dispose();
    streetController.dispose();
    storeController.dispose();
  }
}
