import 'package:ecommerce/features/user/data/model/image_model.dart';
import 'package:ecommerce/features/admin/presentation/screens/admin_panel_screen.dart';
import 'package:ecommerce/features/admin/presentation/screens/categories_controller_screen.dart';
import 'package:ecommerce/features/user/presentation/screens/cart_screen.dart';
import 'package:ecommerce/features/user/presentation/screens/check_out_screen.dart';
import 'package:ecommerce/features/user/presentation/screens/image_zoom_screen.dart';
import 'package:ecommerce/features/admin/presentation/screens/items_controller_screen.dart';
import 'package:ecommerce/features/admin/presentation/screens/orders_controller_screen.dart';
import 'package:ecommerce/features/admin/presentation/screens/users_controller_screen.dart';
import 'package:ecommerce/features/auth/presentation/screens/login_screen.dart';
import 'package:ecommerce/features/auth/presentation/screens/on_borading_screen.dart';
import 'package:ecommerce/features/auth/presentation/screens/verification_screen.dart';
import 'package:ecommerce/features/user/data/model/category_model.dart';
import 'package:ecommerce/features/user/presentation/screens/category_screen.dart';
import 'package:ecommerce/features/user/presentation/screens/home/home_screen.dart';
import 'package:ecommerce/features/user/presentation/screens/item_details_screen.dart';
import 'package:ecommerce/features/user/presentation/screens/orders_screen.dart';
import 'package:ecommerce/features/user/presentation/screens/payout_web_view_screen.dart';
import 'package:ecommerce/features/user/presentation/screens/search_screen.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRouter {

  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) =>   const LoginScreen());
      case verificationScreen:
        return MaterialPageRoute(builder: (_) =>  const VerificationScreen());
      case homeScreen:
        return MaterialPageRoute(builder: (_) =>  HomeScreen());
      case searchScreen:
        return MaterialPageRoute(builder: (_) =>  const SearchScreen());
      case itemDetailsScreen:
        return MaterialPageRoute(builder: (_) =>  ItemDetailsScreen(itemId: routeSettings.arguments as String));
      case categoryScreen:
        return MaterialPageRoute(builder: (_) =>  CategoryScreen(category: routeSettings.arguments as CategoryModel));
      case cartScreen:
        return MaterialPageRoute(builder: (_) =>   CartScreen());
      case checkoutScreen:
        return MaterialPageRoute(builder: (_) =>   CheckOutScreen());
      case ordersScreen:
        return MaterialPageRoute(builder: (_) =>   const OrdersScreen());
      case payoutWebViewScreen:
        return MaterialPageRoute(builder: (_) =>   PayoutWebViewScreen(url: routeSettings.arguments as String));

      case adminPanelScreen:
        return MaterialPageRoute(builder: (_) =>  const AdminPanelScreen());

      case itemsControllerScreen:
        return MaterialPageRoute(builder: (_) =>  ItemsControllerScreen());
        case catsControllerScreen:
        return MaterialPageRoute(builder: (_) =>  CategoriesControllerScreen());

      case ordersControllerScreen:
        return MaterialPageRoute(builder: (_) =>  OrdersControllerScreen());
      case usersControllerScreen:
        return MaterialPageRoute(builder: (_) =>  UsersControllerScreen());
      case imageZoomScreen:
        return MaterialPageRoute(builder: (_) =>  ImageZoomScreen(image: (routeSettings.arguments! as List)[0] as ImageModel, controller: (routeSettings.arguments as List).length > 1 ? (routeSettings.arguments as List)[1] : null));
    }
  }
}
