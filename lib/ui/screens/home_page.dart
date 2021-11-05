import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meals/data/blocs/fetch_categories/fetch_categories_cubit.dart';
import 'package:meals/ui/widgets/tab_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchCategoriesCubit = Modular.get<FetchCategoriesCubit>();

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
                title: const Text('Meals'),
                actions: [
                  IconButton(
                    onPressed: () => Modular.to.pushNamed('/favorite'),
                    icon: const Icon(Icons.favorite),
                  ),
                ],
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
