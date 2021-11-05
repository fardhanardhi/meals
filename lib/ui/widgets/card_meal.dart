import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meals/data/blocs/set_fav/set_fav_cubit.dart';
import 'package:meals/data/db/database.dart';
import 'package:meals/data/repositories/meal_repository.dart';

class CardMeal extends StatefulWidget {
  const CardMeal({
    Key? key,
    required this.data,
    this.onFav,
  }) : super(key: key);

  final Meal data;
  final VoidCallback? onFav;

  @override
  State<CardMeal> createState() => _CardMealState();
}

class _CardMealState extends State<CardMeal> {
  late SetFavCubit _setFavCubit;

  @override
  void initState() {
    super.initState();
    _setFavCubit = SetFavCubit(widget.data, Modular.get<MealRepository>());
  }

  @override
  void dispose() {
    super.dispose();
    _setFavCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _setFavCubit,
      child: BlocBuilder<SetFavCubit, bool>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              elevation: 0,
              child: InkWell(
                onTap: () => Modular.to.pushNamed('/second'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(5),
                            ),
                            child: Image.network(
                              widget.data.thumb,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                            child: Text(
                              widget.data.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 22,
                          splashRadius: 25,
                          icon: Icon(
                            state ? Icons.favorite : Icons.favorite_outline,
                          ),
                          onPressed: () {
                            _setFavCubit.set(!state);
                            widget.onFav!();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
