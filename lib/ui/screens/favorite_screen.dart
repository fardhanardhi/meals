import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meals/data/blocs/fav_meals/fav_meals_cubit.dart';
import 'package:meals/data/blocs/fetch_meals/fetch_meals_cubit.dart';
import 'package:meals/data/db/database.dart';
import 'package:meals/ui/widgets/card_meal.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late FavMealsCubit favMealsCubit;

  @override
  void initState() {
    super.initState();
    favMealsCubit = FavMealsCubit(Modular.get<Database>())..load();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => favMealsCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorite Meals'),
        ),
        body: BlocBuilder<FavMealsCubit, FavMealsState>(
          builder: (context, state) {
            if (state is FavMealsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is FavMealsSuccess) {
              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 13,
                  crossAxisSpacing: 13,
                ),
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 60),
                itemCount: state.data.length,
                itemBuilder: (BuildContext context, int id) => CardMeal(
                  data: state.data[id],
                  onFav: () => favMealsCubit.load(),
                ),
              );
            }
            return const Center(child: Text('Oops'));
          },
        ),
      ),
    );
  }
}
