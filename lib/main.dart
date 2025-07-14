import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/common/index.dart';

import 'global.dart';


void main() async {
  await Global.init();

  // TODO: 測試用
  clearAllSharedPrefs();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(

      // 样式
      light: AppTheme.light, // 亮色主题
      dark: AppTheme.dark, // 暗色主题
      initial: ConfigService.to.themeMode, // 初始主题
      debugShowFloatingThemeButton: true, // 显示主题按钮

      builder: (theme, darkTheme) => GetMaterialApp(
        // 标题
        title: 'Flutter Demo',
      
        // 主题
        theme: theme,
        darkTheme: darkTheme,

        // 路由
        initialRoute: RouteNames.systemSplash,
        getPages: RoutePages.list,   
        navigatorObservers: [RoutePages.observers], 
      
        // 多语言
        translations: Translation(), // 词典
        localizationsDelegates:Translation.localizationsDelegates, // 代理
        supportedLocales: Translation.supportedLocales, // 支持的语言种类
        locale: ConfigService.to.locale, // 当前语言种类
        fallbackLocale: Translation.fallbackLocale, // 默认语言种类
      
      
        // builder
        builder: (context, widget) {
            
          // EasyLoading 初始化
          widget = EasyLoading.init()(context, widget);
          
          // 不随系统字体缩放比例
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: widget,
          );
        },

        // 隐藏 debug 标志
        debugShowCheckedModeBanner: false,
        
      ),
    );
  }
}

// 清除所有 SharedPreferences 資料（測試用）
Future<void> clearAllSharedPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}