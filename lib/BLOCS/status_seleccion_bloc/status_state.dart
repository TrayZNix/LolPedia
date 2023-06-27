part of 'status_bloc.dart';

@immutable
class StatusState extends Equatable {
  final LeagueStatusResponse? statusResponse;
  final bool loaded;
  const StatusState({this.loaded = false, this.statusResponse});

  @override
  List<Object> get props => [statusResponse ?? "", loaded];

  StatusState copyWith({LeagueStatusResponse? statusResponse, bool? loaded}) {
    return StatusState(
        statusResponse: statusResponse ?? this.statusResponse,
        loaded: loaded ?? this.loaded);
  }
}

class StatusInitial extends StatusState {}

class StatusLoading extends StatusState {}

class StatusLoaded extends StatusState {}
