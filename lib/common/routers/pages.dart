
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';

import 'observers.dart';

class RoutePages {

  // 歷史紀錄
  static List<String> history = [];

  // 觀察者
  static RouteObservers observers = RouteObservers();

  // 列表
  static List<GetPage> list = [    

      GetPage(
        name: RouteNames.stylesButtons,
        page: () => const ButtonsPage(),
      ),
      GetPage(
        name: RouteNames.stylesIcon,
        page: () => const IconPage(),
      ),
      GetPage(
        name: RouteNames.stylesImage,
        page: () => const ImagePage(),
      ),
      GetPage(
        name: RouteNames.stylesInputs,
        page: () => const InputsPage(),
      ),
      GetPage(
        name: RouteNames.stylesStylesIndex,
        page: () => const StylesIndexPage(),
      ),
      GetPage(
        name: RouteNames.stylesText,
        page: () => const TextPage(),
      ),
      GetPage(
        name: RouteNames.stylesTextForm,
        page: () => const TextFormPage(),
      ),
      GetPage(
        name: RouteNames.systemLogin,
        page: () => const LoginPage(),
      ),
      GetPage(
        name: RouteNames.systemSplash,
        page: () => const SplashPage(),
      ),
  ];
}
