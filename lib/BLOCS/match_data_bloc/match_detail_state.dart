part of 'match_detail_bloc.dart';

class OriginalMatchDetailsState extends Equatable {
  const OriginalMatchDetailsState();

  @override
  List<Object> get props => [];
}

class MatchDetailsState extends OriginalMatchDetailsState {
  final MatchDetailsWindowInterface? matchDetailsWindows;
  final MatchDetailsInterface? matchDetails;
  final bool loaded;
  const MatchDetailsState(
      {this.loaded = false, this.matchDetailsWindows, this.matchDetails});

  @override
  List<Object> get props =>
      [matchDetailsWindows ?? "", matchDetails ?? "", loaded];

  MatchDetailsState copyWith(
      {MatchDetailsWindowInterface? matchDetailsWindows,
      MatchDetailsInterface? matchDetails,
      bool? loaded}) {
    return MatchDetailsState(
        matchDetailsWindows: matchDetailsWindows ?? this.matchDetailsWindows,
        matchDetails: matchDetails ?? this.matchDetails,
        loaded: loaded ?? this.loaded);
  }
}

class MatchDetailInitial extends OriginalMatchDetailsState {}

class MatchDetailLoading extends OriginalMatchDetailsState {}

class MatchDetailLoadFail extends OriginalMatchDetailsState {}
