import 'package:equatable/equatable.dart';

import '../../../../core/common/entity/ltp.dart';

abstract class HomeCubitState extends Equatable {}

class HomePageLoadingState extends HomeCubitState {
  @override
  List<Object?> get props => [];
}

class HomePageLoadedState extends HomeCubitState {
  final List<Ltp> instruments;

  HomePageLoadedState({required this.instruments});
  @override
  List<Object?> get props => instruments;
}

class HomePageErrorState extends HomeCubitState {
  final String message;

  HomePageErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
