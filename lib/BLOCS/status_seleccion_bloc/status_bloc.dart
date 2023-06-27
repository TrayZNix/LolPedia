import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lol_pedia/models/league_status_response.dart';
import 'package:lol_pedia/dinamic_general_variables.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import '../../repositories/data_dragon_repository.dart';

part 'status_event.dart';
part 'status_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc() : super(StatusInitial()) {
    on<LoadStatus>(cargarStatus,
        transformer: throttleDroppable(throttleDuration));
  }
}

Future<void> cargarStatus(LoadStatus event, Emitter<StatusState> emit) async {
  emit(StatusLoading());
  DataDragonRepository repo = GetIt.I.get<DataDragonRepository>();
  LeagueStatusResponse? estado = await repo.getLeagueStatus();
  emit(StatusLoaded().copyWith(statusResponse: estado, loaded: true));
}
