import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meals/api/api_client.dart';
import 'package:meals/data/blocs/fav_meals/fav_meals_cubit.dart';
import 'package:meals/data/blocs/fetch_categories/fetch_categories_cubit.dart';
import 'package:meals/data/db/database.dart';
import 'package:meals/data/repositories/category_repository.dart';
import 'package:meals/data/repositories/meal_repository.dart';
import 'package:meals/ui/screens/detail_screen.dart';
import 'package:meals/ui/screens/favorite_screen.dart';
import 'package:meals/ui/screens/home_page.dart';

void main() {
  return runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Smart App',
      theme: ThemeData(primarySwatch: Colors.blue),
    ).modular(); //added by extension
  }
}

class AppModule extends Module {
  CustomTransition trans = CustomTransition(
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: anim1,
            curve: Curves.fastOutSlowIn,
            reverseCurve: Curves.easeOutQuad,
          ),
        ),
        child: child,
      );
    },
  );

  @override
  List<Bind> get binds => [
        Bind.factory((i) => Client()),
        Bind.factory((i) => CategoryRepository(i<Client>().init(), i())),
        Bind.factory((i) => MealRepository(i<Client>().init(), i())),
        Bind.singleton((i) => FetchCategoriesCubit(i(), i())..load()),
        Bind.singleton((i) => FavMealsCubit(i())),
        Bind.singleton((i) => Database()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const HomePage()),
        ChildRoute(
          '/second',
          child: (context, args) => const DetailScreen(),
          transition: TransitionType.custom,
          customTransition: trans,
        ),
        ChildRoute(
          '/favorite',
          child: (context, args) => const FavoriteScreen(),
          transition: TransitionType.custom,
          customTransition: trans,
        ),
      ];
}
