part of 'match_bloc.dart';

class MatchState extends Equatable {
  const MatchState();

  @override
  List<Object> get props => [];
}

class MatchDetailsState extends MatchState {
  final MatchDetails? matchDetails;
  final bool loaded;
  const MatchDetailsState({this.loaded = false, this.matchDetails});

  @override
  List<Object> get props => [matchDetails ?? "", loaded];

  MatchDetailsState copyWith({MatchDetails? matchDetails, bool? loaded}) {
    return MatchDetailsState(
        matchDetails: matchDetails ?? this.matchDetails,
        loaded: loaded ?? this.loaded);
  }
}

class MatchInitial extends MatchState {}

class MatchLoading extends MatchState {}

class MatchLoadFail extends MatchState {}
