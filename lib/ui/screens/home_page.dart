import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meals/data/blocs/fetch_categories/fetch_categories_cubit.dart';
import 'package:meals/data/blocs/fetch_meals/fetch_meals_cubit.dart';
import 'package:meals/data/db/database.dart';
import 'package:meals/data/repositories/meal_repository.dart';
import 'package:meals/ui/widgets/card_meal.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchCategoriesCubit = Modular.get<FetchCategoriesCubit>();
    // final fetchMealsCubit = Modular.get<FetchMealsCubit>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => fetchCategoriesCubit),
        // BlocProvider(create: (_) => fetchMealsCubit),
      ],
      child: BlocConsumer<FetchCategoriesCubit, FetchCategoriesState>(
        listener: (context, state) {
          late String msg;
          if (state is FetchCategoriesSuccess) {
            // if (state.data.isNotEmpty) {
            //   fetchMealsCubit.load(state.data.first);
            // }
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
        builder: (context, catState) {
          return DefaultTabController(
            length:
                catState is FetchCategoriesSuccess ? catState.data.length : 0,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Home Page'),
                bottom: catState is FetchCategoriesSuccess
                    ? TabBar(
                        isScrollable: true,
                        tabs: List.generate(
                            catState.data.length,
                            (index) => Tab(
                                  text: catState.data[index].name,
                                )))
                    : const PreferredSize(
                        child: LinearProgressIndicator(),
                        preferredSize: Size(double.infinity, 10),
                      ),
              ),
              body: catState is FetchCategoriesSuccess
                  ? TabBarView(
                      children: List.generate(catState.data.length, (index) {
                        return TabItem(category: catState.data[index]);
                      }),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          );
        },
      ),
    );
  }
}

class TabItem extends StatefulWidget {
  const TabItem({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;

  @override
  State<TabItem> createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> {
  late FetchMealsCubit _fetchMealsCubit;

  @override
  void initState() {
    super.initState();
    _fetchMealsCubit = FetchMealsCubit(
      Modular.get<MealRepository>(),
      Modular.get<Database>(),
    )..load(widget.category);
  }

  @override
  void dispose() {
    _fetchMealsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _fetchMealsCubit,
      child: BlocBuilder<FetchMealsCubit, FetchMealsState>(
        builder: (context, mealState) {
          if (mealState is FetchMealsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (mealState is FetchMealsSuccess) {
            return GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 13,
                crossAxisSpacing: 13,
              ),
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 60),
              itemCount: 10,
              itemBuilder: (BuildContext context, int id) => CardMeal(
                data: mealState.data[id],
              ),
            );
          }
          return const Center(
            child: Text("Oops"),
          );
        },
      ),
    );
  }
}
