import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:lol_pedia/models/champion_details.dart';
import 'package:lol_pedia/repositories/data_dragon_repository.dart';
import 'package:meta/meta.dart';
// ignore: depend_on_referenced_packages
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'champion_details_event.dart';
part 'champion_details_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ChampionDetailsBloc
    extends Bloc<ChampionDetailsEvent, ChampionDetailsState> {
  ChampionDetailsBloc(this.championName) : super(ChampionDetailsInitial()) {
    on<LoadChampionDetails>(
      cargarCampeones,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final String championName;

  Future<void> cargarCampeones(
      LoadChampionDetails event, Emitter<ChampionDetailsState> emit) async {
    emit(ChampionDetailsLoading());
    DataDragonRepository repo = GetIt.I.get<DataDragonRepository>();
    Data? data = await repo.getChampionsDetails(championName);
    emit(ChampionDetailsLoaded()
        .copyWith(status: ChampionDetailsStatus.success, data: data));
  }
}
