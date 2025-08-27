import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';



class MyAddressController extends GetxController 
  with GetSingleTickerProviderStateMixin {
  MyAddressController();

  // tab 控制器
  late TabController tabController;

    // tab 控制器
  int tabIndex = 0;

  List<CityModel> cities = [];

  CityModel? selectedCity;

  DistrictModel? selectedDistrict;

  _initData() async {
    cities = await Address.load();
    update(["my_address"]);
  }

  // 切换 tab
  void onTapBarTap(int index) {
    tabIndex = index;
    tabController.animateTo(index);
    update(["my_address"]);
  }

  void onSelectCity(CityModel? city) {
    selectedCity = city;
    selectedDistrict = null;
    update(["my_address"]);
  }

  void onSelectDistrict(DistrictModel? district) {
    selectedDistrict = district;
    update(["my_address"]);
  }

  @override
  void onInit() {
    super.onInit();
    // 初始化 tab 控制器
    tabController = TabController(length: 3, vsync: this);

    // 监听 tab 切换
    tabController.addListener(() {
      tabIndex = tabController.index;
      update(['profile_tab']);
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
  }
}
