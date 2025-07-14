import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'colors.dart';

/// 主题
class AppTheme {
  /////////////////////////////////////////////////
  /// 自定义颜色
  /////////////////////////////////////////////////

  static const primary = Color(0xFF5F84FF);
  static const secondary = Color(0xFFFF6969);
  static const success = Color(0xFF23A757);
  static const warning = Color(0xFFFF1843);
  static const error = Color(0xFFDA1414);
  static const info = Color(0xFF2E5AAC);

  /////////////////////////////////////////////////
  /// 系统样式
  /////////////////////////////////////////////////

    /// 系统样式
  static SystemUiOverlayStyle get systemStyle => const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // 状态栏颜色
        statusBarBrightness: Brightness.light, // 状态栏亮度
        statusBarIconBrightness: Brightness.dark, // 状态栏图标亮度
        systemNavigationBarDividerColor: Colors.transparent, // 系统导航栏分隔线颜色
        systemNavigationBarColor: Colors.white, // 系统导航栏颜色
        systemNavigationBarIconBrightness: Brightness.dark, // 系统导航栏图标亮度
      );

  /// 亮色系统样式
  static SystemUiOverlayStyle get systemStyleLight => systemStyle.copyWith(
        statusBarBrightness: Brightness.light, // 状态栏亮度
        statusBarIconBrightness: Brightness.dark, // 状态栏图标亮度
        systemNavigationBarIconBrightness: Brightness.dark, // 系统导航栏图标亮度
      );

  /// 暗色系统样式
  static SystemUiOverlayStyle get systemStyleDark => systemStyle.copyWith(
        statusBarBrightness: Brightness.dark, // 状态栏亮度
        statusBarIconBrightness: Brightness.light, // 状态栏图标亮度
        systemNavigationBarColor: const Color(0xFF0D0D0D), // 系统导航栏颜色
        systemNavigationBarIconBrightness: Brightness.light, // 系统导航栏图标亮度
      );


  /////////////////////////////////////////////////
  /// 主题
  /////////////////////////////////////////////////

  /// 亮色主题
  static ThemeData get light {
    ColorScheme scheme = MaterialTheme.lightScheme();
    return _getTheme(scheme);
  }

  /// 暗色主题
  static ThemeData get dark {
    ColorScheme scheme = MaterialTheme.darkScheme();
    return _getTheme(scheme);
  }

  /// 获取主题
  static ThemeData _getTheme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: false,
      colorScheme: scheme,
      fontFamily: "NotoSansTC",

      // 导航栏
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface, // 背景色
        scrolledUnderElevation: 0, // 滚动阴影
        elevation: 0, // 阴影
        centerTitle: true, // 标题居中
        toolbarHeight: 56, // 高度
        iconTheme: IconThemeData(
          color: scheme.onSurface, // 图标颜色
          size: 22, // 图标大小
        ),
        titleTextStyle: TextStyle(
          color: scheme.onSurface, // 字体颜色
          fontSize: 24, // 字体大小
          fontWeight: FontWeight.w600, // 字体粗细
          height: 1.2, // 行高
        ),
        toolbarTextStyle: TextStyle(
          color: scheme.onSurface, // 字体颜色
          fontSize: 22, // 字体大小
          fontWeight: FontWeight.w600, // 字体粗细
          height: 1.2, // 行高
        ),
      ),
    );
  }

  static void setSystemStyle() {
    // 获取系统亮度
    Brightness platformBrightness = Get.context?.theme.brightness ?? Brightness.light;

    // 获取当前模式
    ThemeMode mode = Get.isDarkMode ? ThemeMode.dark : ThemeMode.light;

    switch (mode) {
      case ThemeMode.system:
        if (platformBrightness == Brightness.dark) {
          // 暗色模式
          SystemChrome.setSystemUIOverlayStyle(systemStyleDark);
        } else {
          // 亮色模式
          SystemChrome.setSystemUIOverlayStyle(systemStyleLight);
        }
        break;
      case ThemeMode.light:
        // 亮色模式
        SystemChrome.setSystemUIOverlayStyle(systemStyleLight);
        break;
      case ThemeMode.dark:
        // 暗色模式
        SystemChrome.setSystemUIOverlayStyle(systemStyleDark);
        break;
    }
  }

  
}
