part of 'match_bloc.dart';

abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object> get props => [];
}

class LoadMatchEvent extends MatchEvent {}
