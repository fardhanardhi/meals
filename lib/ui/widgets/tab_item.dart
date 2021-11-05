import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meals/data/blocs/fetch_meals/fetch_meals_cubit.dart';
import 'package:meals/data/db/database.dart';
import 'package:meals/data/repositories/meal_repository.dart';
import 'package:meals/ui/widgets/card_meal.dart';

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
              itemCount: mealState.data.length,
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
