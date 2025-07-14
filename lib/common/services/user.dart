
import 'dart:convert';

import 'package:get/get.dart';
import 'package:template/common/index.dart';

class UserService extends GetxService {
  
  static UserService get to => Get.find();

  // 是否登入
  final _isLogin = false.obs;

  // 用戶的資料
  final _profile = UserProfileModel().obs;

  // Access Token
  String accessToken = '';

  // Refresh Token
  String refreshToken = '';

  // 是否登入
  bool get isLogin => _isLogin.value;

  // 用戶 profile
  UserProfileModel get profile => _profile.value;

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
  }

  Future<void> setToken(UserTokenModel token) async {
    await Storage().setString(Constants.storageAccessToken, token.accessToken);
    await Storage().setString(Constants.storageRefreshToken, token.refreshToken);
    accessToken  = token.accessToken;
    refreshToken = token.refreshToken;
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
    _profile(profile);
    Storage().setString(Constants.storageProfile, jsonEncode(profile));
  }

  // 登出
  Future<void> logout() async {
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