part of 'lista_ligas_bloc.dart';

@immutable
class ListaLigasState extends Equatable {
  final LeagueStatusResponse? statusResponse;
  final bool loaded;
  const ListaLigasState({this.loaded = false, this.statusResponse});

  @override
  List<Object> get props => [statusResponse ?? "", loaded];

  ListaLigasState copyWith(
      {LeagueStatusResponse? statusResponse, bool? loaded}) {
    return ListaLigasState(
        statusResponse: statusResponse ?? this.statusResponse,
        loaded: loaded ?? this.loaded);
  }
}

class StatusInitial extends ListaLigasState {}

class StatusLoading extends ListaLigasState {}

class StatusLoaded extends ListaLigasState {}
