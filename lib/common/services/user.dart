
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
  Future<void> onInit() async {
    super.onInit();

    // 讀取 access token 和 refresh token
    accessToken  = await Storage().getString(Constants.storageAccessToken);
    refreshToken = await Storage().getString(Constants.storageRefreshToken);
    
    // 判斷是否登入
    _isLogin.value = accessToken.isNotEmpty;

    // 讀取用戶 profile
    final profileMap = await Storage().getJson(Constants.storageProfile);
    if(profileMap.isNotEmpty) {
      _profile(UserProfileModel.fromJson(profileMap));
    } else {
      _profile(UserProfileModel());
    }

    // 讀取用戶地址
    final addressesStr = await Storage().getString(Constants.storageAddresses);
    if(addressesStr.isNotEmpty) {
      final addresses = (jsonDecode(addressesStr) as List).map((e) => AddressModel.fromJson(e)).toList();
      _addresses.addAll(addresses);
    }
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

    //_addresses.clear();
    //_addresses.addAll(addresses);

    Storage().setString(
      Constants.storageAddresses, 
      jsonEncode(addresses)
    );
  }

  // 獲取用戶 profile
  Future<void> getProfile() async {
    // 如果 access token 為空，表示尚未登入，
    // 為登入就不能取得用戶訊息，所以，不做任何操作
    if(accessToken.isEmpty) return;

    // 設定 obs 變數，是否登入為：登入
    _isLogin.value = true;
    
    // 獲取伺服器上用戶訊息
    final profile = await UserApi.profile();
    
    // 設定本地用戶訊息
    _profile(profile);

    // 儲存本地用戶訊息
    await Storage().setString(Constants.storageProfile, jsonEncode(profile));
  }

  // 設置用戶 profile
  Future<void> setProfile(UserProfileModel profile) async {
    // 如果 access token 為空，表示尚未登入，
    // 為登入就不能取得用戶訊息，所以，不做任何操作
    if (accessToken.isEmpty) return;

    // 設定 obs 變數，是否登入為：登入
    _isLogin.value = true;

    // 變更服務器上用戶資料
    await UserApi.editProfile(profile: profile);
    
    // 變更本地用戶資料
    _profile(profile);

    // 儲存本地用戶訊息
    Storage().setJson(
      Constants.storageAddresses, 
      profile
    );
  }

  // 登出
  Future<void> logout() async {

    // TODO 
    debugPrint('----------------------------------------------');
    debugPrint('登出');
    debugPrint('----------------------------------------------');

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