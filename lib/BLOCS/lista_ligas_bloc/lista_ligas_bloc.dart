import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lolpedia/models/league_status_response.dart';
// ignore: depend_on_referenced_packages
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import '../../repositories/data_dragon_repository.dart';

part 'lista_ligas_event.dart';
part 'lista_ligas_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ListaLigasBloc extends Bloc<ListaLigasEvent, ListaLigasState> {
  ListaLigasBloc() : super(StatusInitial()) {
    on<LoadStatus>(
      cargarStatus,
      transformer: throttleDroppable(throttleDuration),
    );
  }
}

Future<void> cargarStatus(
  LoadStatus event,
  Emitter<ListaLigasState> emit,
) async {
  emit(StatusLoading());
  DataDragonRepository repo = GetIt.I.get<DataDragonRepository>();
  LeagueStatusResponse? estado = await repo.getLeagueStatus();
  emit(StatusLoaded().copyWith(statusResponse: estado, loaded: true));
}
