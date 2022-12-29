import 'package:flutter/material.dart';
import 'views/check_auth_page.dart';
import 'views/check_group_page.dart';
import 'views/cuz_page.dart';
import 'views/group_choose.dart';
import 'views/group_create.dart';
import 'views/hatim_page.dart';
import 'views/login_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case CheckAuthPage.routeName:
        return MaterialPageRoute(
          builder: (context) => const CheckAuthPage(),
        );

      case CheckGroupPage.routeName:
        return MaterialPageRoute(
          builder: (context) => const CheckGroupPage(),
        );

      case GroupChoosePage.routeName:
        return MaterialPageRoute(
          builder: (context) => const GroupChoosePage(),
        );

      case GroupCreatePage.routeName:
        return MaterialPageRoute(
          builder: (context) => const GroupCreatePage(),
        );

      case LoginPage.routeName:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
        );

      case HatimPage.routeName:
        return MaterialPageRoute(
          builder: (context) => const HatimPage(),
        );

      case CuzPage.routeName:
        final args = settings.arguments as Map<String, dynamic>;
        final hatimId = args['hatimId'];
        final userName = args['userName'];
        return MaterialPageRoute(
          builder: (context) => CuzPage(hatimId: hatimId, userName: userName),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Sayfa bulunamadı!')),
          ),
        );
    }
  }
}
