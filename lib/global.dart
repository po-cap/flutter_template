import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common/index.dart';

class Global {
  static Future<void> init() async {
    // 插件初始化
    WidgetsFlutterBinding.ensureInitialized();

    // 工具类
    await Storage().init();

    // 加載動畫
    Loading();

    // 初始化服务
    Get.put<ConfigService>(ConfigService());
    Get.put<WPHttpService>(WPHttpService());
    Get.put<UserService>(UserService());
    Get.put<ChatService>(ChatService());
    Get.put<LocalDataService>(LocalDataService());

    // API
    Get.lazyPut<MessageRepo>(() => MessageRepoImpl(), fenix: true);
    Get.lazyPut<ChatroomRepo>(() => ChatroomRepoImpl(), fenix: true);

    // 初始化配置
    await ConfigService.to.init();

    // TODO: 測試用
    //await LocalDataService.to.delete();
  }
}

