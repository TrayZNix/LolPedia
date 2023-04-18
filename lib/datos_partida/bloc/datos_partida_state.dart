part of 'datos_partida_bloc.dart';

@immutable
class DatosPartidaState extends Equatable {
  final ClientApiAllDataResponse? clientApiData;
  final bool loaded;
  const DatosPartidaState({this.loaded = false, this.clientApiData});

  @override
  List<Object> get props => [clientApiData ?? "", loaded];

  DatosPartidaState copyWith({ClientApiAllDataResponse? clientApiData, bool? loaded}) {
    return DatosPartidaState(
        clientApiData: clientApiData ?? this.clientApiData,
        loaded: loaded ?? this.loaded);
  }
}

class DatosPartidaInitial extends DatosPartidaState {}

class DatosPartidaLoading extends DatosPartidaState {}

class DatosPartidaLoaded extends DatosPartidaState {}
