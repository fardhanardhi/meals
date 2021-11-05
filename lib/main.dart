import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meals/api/api_client.dart';
import 'package:meals/data/blocs/coba_db/coba_db_cubit.dart';
import 'package:meals/data/blocs/fetch_categories/fetch_categories_cubit.dart';
import 'package:meals/data/db/database.dart';
import 'package:meals/data/repositories/category_repository.dart';

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

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchCategoriesCubit = Modular.get<FetchCategoriesCubit>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => fetchCategoriesCubit),
      ],
      child: BlocConsumer<FetchCategoriesCubit, FetchCategoriesState>(
        listener: (context, state) {
          late String msg;
          if (state is FetchCategoriesSuccess) {
            msg = 'Sukses';
          }
          if (state is FetchCategoriesFailure) {
            msg = 'Gagal';
          }
          if (state is FetchCategoriesSuccess ||
              state is FetchCategoriesFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(msg),
                  backgroundColor:
                      state is FetchCategoriesFailure ? Colors.red : null,
                ),
              );
          }
          if (state is FetchCategoriesFailure) {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Home Page')),
            body: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => Modular.to.pushNamed('/second'),
                    child: const Text('Navigate to Second Page'),
                  ),
                  ElevatedButton(
                    onPressed: () => fetchCategoriesCubit.load(),
                    child: const Text('Load'),
                  ),
                  if (state is FetchCategoriesLoading)
                    const CircularProgressIndicator(),
                  if (state is FetchCategoriesSuccess)
                    Text(
                      state.data.map((e) => e.name).join(', '),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

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
