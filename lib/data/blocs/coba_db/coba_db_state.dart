part of 'coba_db_cubit.dart';

abstract class CobaDbState extends Equatable {
  const CobaDbState();

  @override
  List<Object> get props => [];
}

class CobaDbInitial extends CobaDbState {}

class CobaDbLoading extends CobaDbState {}

class CobaDbSuccess extends CobaDbState {
  // const CobaDbSuccess(this.data);

  // final List<Todo> data;

  // @override
  // List<Object> get props => [data];
}

class CobaDbFailure extends CobaDbState {
  const CobaDbFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
