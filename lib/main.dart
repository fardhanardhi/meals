import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meals/api/api_client.dart';
import 'package:meals/data/blocs/coba_db/coba_db_cubit.dart';
import 'package:meals/data/blocs/fetch_categories/fetch_categories_cubit.dart';
import 'package:meals/data/blocs/fetch_meals/fetch_meals_cubit.dart';
import 'package:meals/data/blocs/set_fav/set_fav_cubit.dart';
import 'package:meals/data/db/database.dart';
import 'package:meals/data/repositories/category_repository.dart';
import 'package:meals/data/repositories/meal_repository.dart';
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
  @override
  List<Bind> get binds => [
        Bind.factory((i) => Client()),
        Bind.factory((i) => CategoryRepository(i<Client>().init(), i())),
        Bind.factory((i) => MealRepository(i<Client>().init(), i())),
        Bind.singleton((i) => FetchCategoriesCubit(i(), i())..load()),
        Bind.singleton((i) => Database()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const HomePage()),
        ChildRoute(
          '/second',
          child: (context, args) => const SecondPage(),
          transition: TransitionType.custom,
          customTransition: CustomTransition(
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
          ),
        ),
      ];
}

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final fetchCategoriesCubit = Modular.get<FetchCategoriesCubit>();
//     final fetchMealsCubit = Modular.get<FetchMealsCubit>();

//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => fetchCategoriesCubit),
//         BlocProvider(create: (_) => fetchMealsCubit),
//       ],
//       child: BlocConsumer<FetchCategoriesCubit, FetchCategoriesState>(
//         listener: (context, state) {
//           late String msg;
//           if (state is FetchCategoriesSuccess) {
//             if (state.data.isNotEmpty) {
//               fetchMealsCubit.load(state.data.first);
//             }
//             msg = 'Sukses';
//           }
//           if (state is FetchCategoriesFailure) {
//             msg = 'Gagal';
//           }
//           if (state is FetchCategoriesSuccess ||
//               state is FetchCategoriesFailure) {
//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(
//                 SnackBar(
//                   content: Text(msg),
//                   backgroundColor:
//                       state is FetchCategoriesFailure ? Colors.red : null,
//                 ),
//               );
//           }
//           if (state is FetchCategoriesFailure) {
//             showDialog(
//               context: context,
//               builder: (context) => Dialog(
//                 child: Text(state.message),
//               ),
//             );
//           }
//         },
//         builder: (context, catState) {
//           return BlocBuilder<FetchMealsCubit, FetchMealsState>(
//             builder: (context, mealState) {
//               return Scaffold(
//                 appBar: AppBar(title: const Text('Home Page')),
//                 body: Center(
//                   child: Column(
//                     children: [
//                       ElevatedButton(
//                         onPressed: () => fetchCategoriesCubit.load(),
//                         child: const Text('Load'),
//                       ),
//                       if (catState is FetchCategoriesLoading)
//                         const CircularProgressIndicator(),
//                       if (catState is FetchCategoriesSuccess)
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: [
//                               for (var item in catState.data)
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     fetchMealsCubit.load(item);
//                                   },
//                                   child: Text(item.name),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       if (mealState is FetchMealsLoading)
//                         const CircularProgressIndicator(),
//                       if (mealState is FetchMealsSuccess)
//                         Expanded(
//                           child: ListView.separated(
//                             itemBuilder: (context, id) =>
//                                 MealItem(data: mealState.data[id]),
//                             separatorBuilder: (_, __) => const Divider(),
//                             itemCount: mealState.data.length,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class MealItem extends StatefulWidget {
//   const MealItem({
//     Key? key,
//     required this.data,
//   }) : super(key: key);

//   final Meal data;

//   @override
//   State<MealItem> createState() => _MealItemState();
// }

// class _MealItemState extends State<MealItem> {
//   late SetFavCubit _setFavCubit;

//   @override
//   void initState() {
//     super.initState();
//     _setFavCubit = SetFavCubit(widget.data, Modular.get<MealRepository>());
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _setFavCubit.close();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => _setFavCubit,
//       child: BlocBuilder<SetFavCubit, bool>(
//         builder: (context, state) {
//           return ListTile(
//             title: Text(widget.data.name),
//             onTap: () => Modular.to.pushNamed('/second'),
//             trailing: IconButton(
//               onPressed: () => _setFavCubit.set(!state),
//               icon: Icon(
//                 state ? Icons.favorite : Icons.favorite_outline,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Modular.to.pop(),
          child: const Text('Back to Home'),
        ),
      ),
    );
  }
}
