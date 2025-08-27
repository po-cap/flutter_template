
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

class UserService extends GetxService {
  
  static UserService get to => Get.find();

  // 是否登入
  final _isLogin = false.obs;

  // 用戶的資料
  final _profile = UserProfileModel().obs;

  // 用戶的地址
  final _addresses = <AddressModel>[].obs;

  // Access Token
  String accessToken = '';

  // Refresh Token
  String refreshToken = '';

  // 是否登入
  bool get isLogin => _isLogin.value;

  // 用戶 profile
  UserProfileModel get profile => _profile.value;

  // 用戶地址
  List<AddressModel> get addresses => _addresses;

  // 用戶是否有 access token
  bool get hasToken => accessToken.isNotEmpty;

  @override
  void onInit() {
    super.onInit();

    accessToken  = Storage().getString(Constants.storageAccessToken);
    refreshToken = Storage().getString(Constants.storageRefreshToken);
    

    var profileOffline = Storage().getString(Constants.storageProfile);
    if(profileOffline.isNotEmpty) {
      _profile(UserProfileModel.fromJson(jsonDecode(profileOffline)));
    }

    var addresses = Storage().getString(Constants.storageAddresses);
    if(addresses.isNotEmpty) {
      final addressesMap = jsonDecode(addresses);
      for (var address in addressesMap) {
        _addresses.add(AddressModel.fromJson(address)); 
      }
    }
    
    _isLogin.value = accessToken.isNotEmpty;
  }

  Future<void> setToken(UserTokenModel token) async {
    await Storage().setString(Constants.storageAccessToken, token.accessToken);
    await Storage().setString(Constants.storageRefreshToken, token.refreshToken);
    accessToken  = token.accessToken;
    refreshToken = token.refreshToken;
  }

  // 設置用戶 addresses
  Future<void> setAddresses(List<AddressModel> addresses) async {
    if (accessToken.isEmpty) return;
    Storage().setString(Constants.storageAddresses, jsonEncode(addresses));
  }

  // 獲取用戶 profile
  Future<void> getProfile() async {
    if(accessToken.isEmpty) return;
    
    final profile = await UserApi.profile();
    _profile(profile);
    _isLogin.value = true;

    await Storage().setString(Constants.storageProfile, jsonEncode(profile));
  }

  // 設置用戶 profile
  Future<void> setProfile(UserProfileModel profile) async {
    if (accessToken.isEmpty) return;
    _isLogin.value = true;
    await UserApi.editProfile(profile: profile);
    _profile(profile);
    Storage().setString(Constants.storageProfile, jsonEncode(profile));
  }

  // 登出
  Future<void> logout() async {

    // TODO 
    debugPrint('----------------------------------------------');
    debugPrint('登出');
    debugPrint('----------------------------------------------');

    // if (_isLogin.value) await UserAPIs.logout();
    await Storage().remove(Constants.storageAccessToken);
    await Storage().remove(Constants.storageRefreshToken);
    _profile(UserProfileModel());
    _isLogin.value = false;
    accessToken = '';
    refreshToken = '';
  }

  // 檢查是否登入
  Future<bool> checkIsLogin() async {
    if (_isLogin.value == false) {
      await Get.toNamed(RouteNames.systemLogin);
      return false;
    }
    return true;
  }
}