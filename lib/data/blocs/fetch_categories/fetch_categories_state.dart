part of 'fetch_categories_cubit.dart';

abstract class FetchCategoriesState extends Equatable {
  const FetchCategoriesState();

  @override
  List<Object> get props => [];
}

class FetchCategoriesInitial extends FetchCategoriesState {}

class FetchCategoriesLoading extends FetchCategoriesState {}

class FetchCategoriesSuccess extends FetchCategoriesState {
  const FetchCategoriesSuccess(this.data);

  final List<Category> data;

  @override
  List<Object> get props => [data];
}

class FetchCategoriesFailure extends FetchCategoriesState {
  const FetchCategoriesFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
