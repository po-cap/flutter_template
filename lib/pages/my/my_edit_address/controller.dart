import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

class MyEditAddressController extends GetxController {
  MyEditAddressController({
    required this.address,
  });

  AddressModel address;

  List<CityModel> cities = [];

  CityModel? selectedCity;

  DistrictModel? selectedDistrict;

  late bool isFirst;

  final receiverController = TextEditingController();

  final phoneController = TextEditingController();

  final streetController = TextEditingController();

  final storeController = TextEditingController();

  _initData() async {
    receiverController.text = address.receiver;
    phoneController.text = address.phone;
    streetController.text = address.street;
    storeController.text = address.store ?? '';

    cities = await Address.load();

    selectedCity = cities.firstWhere((element) => element.name == address.city);
    selectedDistrict = selectedCity!.districts.firstWhere((element) => element.name == address.district);

    update(["my_edit_address"]);
  }

  void onSelectCity(CityModel? city) {
    selectedCity = city;
    selectedDistrict = null;
    update(["my_edit_address"]);
  }

  void onSelectDistrict(DistrictModel? district) {
    selectedDistrict = district;
    update(["my_edit_address"]);
  }

  void onDeleteAddress() {
    final addresses = UserService.to.addresses;
    addresses.remove(address);
    UserService.to.setAddresses(addresses);
    Get.back();
  }

  void onSetDefaultAddress() async {
    final addresses = UserService.to.addresses;
    addresses.remove(address);
    addresses.insert(0, address);
    UserService.to.setAddresses(addresses);
    update(["my_edit_address"]);
  }

  @override
  void onInit() {
    super.onInit();
    isFirst = UserService.to.addresses.first == address;
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    receiverController.dispose();
    phoneController.dispose();
    streetController.dispose();
    storeController.dispose();
  }
}
