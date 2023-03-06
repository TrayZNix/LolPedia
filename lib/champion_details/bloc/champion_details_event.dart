part of 'champion_details_bloc.dart';

@immutable
abstract class ChampionDetailsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadChampionDetails extends ChampionDetailsEvent {}
