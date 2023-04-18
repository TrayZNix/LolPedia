import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lol_pedia/models/client_api_all_data_response.dart';
import 'package:lol_pedia/repositories/client_api.dart';
// ignore: depend_on_referenced_packages
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';


part 'datos_partida_event.dart';
part 'datos_partida_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class DatosPartidaBloc extends Bloc<DatosPartidaEvent, DatosPartidaState> {
  DatosPartidaBloc() : super(DatosPartidaInitial()) {
    on<LoadClientApiData>(cargarStatus,
        transformer: throttleDroppable(throttleDuration));
  }
}

Future<void> cargarStatus(
    LoadClientApiData event, Emitter<DatosPartidaState> emit) async {
  emit(DatosPartidaLoading());
  ClientApiRepository repo = GetIt.I.get<ClientApiRepository>();
  ClientApiAllDataResponse? data = await repo.getClientApiFullData();
  emit(DatosPartidaLoaded().copyWith(clientApiData: data, loaded: true));
}
