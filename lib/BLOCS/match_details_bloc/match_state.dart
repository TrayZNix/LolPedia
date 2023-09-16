part of 'match_bloc.dart';

class MatchState extends Equatable {
  const MatchState();

  @override
  List<Object> get props => [];
}

class MatchDataState extends MatchState {
  final MatchDataInterface? matchDetails;
  final bool loaded;
  const MatchDataState({this.loaded = false, this.matchDetails});

  @override
  List<Object> get props => [matchDetails ?? "", loaded];

  MatchDataState copyWith({MatchDataInterface? matchDetails, bool? loaded}) {
    return MatchDataState(
        matchDetails: matchDetails ?? this.matchDetails,
        loaded: loaded ?? this.loaded);
  }
}

class MatchInitial extends MatchState {}

class MatchLoading extends MatchState {}

class MatchLoadFail extends MatchState {}
