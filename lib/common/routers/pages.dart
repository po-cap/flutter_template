
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';
import 'package:template/pages/system/main/binding.dart';

import 'observers.dart';

class RoutePages {

  // 歷史紀錄
  static List<String> history = [];

  // 觀察者
  static RouteObservers observers = RouteObservers();

  // 列表
  static List<GetPage> list = [    

      GetPage(
        name: RouteNames.cartCartIndex,
        page: () => const CartIndexPage(),
      ),
      GetPage(
        name: RouteNames.goodsHome,
        page: () => const HomePage(),
      ),
      GetPage(
        name: RouteNames.msgMsgIndex,
        page: () => const MsgIndexPage(),
      ),
      GetPage(
        name: RouteNames.myMyIndex,
        page: () => const MyIndexPage(),
      ),
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
        name: RouteNames.systemLoginWithLine,
        page: () => const LoginWithLinePage(),
      ),
      GetPage(
        name: RouteNames.systemMain,
        page: () => const MainPage(),
        binding: MainBinding()
      ),
      GetPage(
        name: RouteNames.systemSplash,
        page: () => const SplashPage(),
      ),
      GetPage(
        name: RouteNames.systemWelcome,
        page: () => const WelcomePage(),
      ),
  ];
}
