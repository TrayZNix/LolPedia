part of 'homepage_bloc.dart';

@immutable
abstract class HomepageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadChampions extends HomepageEvent {}

class LoadLigas extends HomepageEvent {}

class FilterLoadedChampions extends HomepageEvent {}

class FilterLoadedLigas extends HomepageEvent {}

class FilterLigas extends HomepageEvent {}
