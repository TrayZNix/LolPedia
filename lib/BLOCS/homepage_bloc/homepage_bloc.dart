import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:lol_pedia/repositories/data_dragon_repository.dart';
import 'package:lol_pedia/repositories/esport_repository.dart';
// ignore: depend_on_referenced_packages
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import '../../models/champion.dart';
import '../../models/leagues.dart';

part 'homepage_event.dart';
part 'homepage_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  HomepageBloc() : super(HomepageInitial()) {
    on<LoadChampions>(
      cargarCampeones,
      transformer: throttleDroppable(throttleDuration),
    );
    on<LoadLigas>(
      loadLigas,
      transformer: throttleDroppable(throttleDuration),
    );
    on<FilterLoadedChampions>(filtrarCampeones);
    on<FilterLoadedLigas>(filtrarLigas);
  }

  Future<void> cargarCampeones(
      LoadChampions event, Emitter<HomepageState> emit) async {
    emit(HomepageLoading());
    DataDragonRepository repo = GetIt.I.get<DataDragonRepository>();
    List<Datum> champs = await repo.getChampions();
    emit(HomepageLoaded().copyWith(
        status: HomepageStatus.success,
        champions: champs,
        filteredChamps: champs));
  }

  Future<void> filtrarCampeones(
      FilterLoadedChampions event, Emitter<HomepageState> emit) async {
    DataDragonRepository repo = GetIt.I.get<DataDragonRepository>();
    List<Datum> champs = await repo.getChampions();
    emit(HomepageLoading());
    emit(HomepageLoaded().copyWith(
      status: HomepageStatus.success,
      champions: champs,
      filteredChamps: champs
          .where((element) =>
              element.name.toLowerCase().contains(filter.toLowerCase()))
          .toList(),
    ));
  }

  Future<void> loadLigas(LoadLigas event, Emitter<HomepageState> emit) async {
    emit(HomepageLoading());
    EsportRepository repo = GetIt.I.get<EsportRepository>();
    Leagues? leagues = await repo.getLeagues();

    emit(LeagueState(
      filteredLeagues: leagues.data.leagues,
      leagues: leagues.data.leagues,
      status: HomepageStatus.success,
      loading: false,
    ));
  }

  Future<void> filtrarLigas(
      FilterLoadedLigas event, Emitter<HomepageState> emit) async {
    emit(HomepageLoading());
    EsportRepository repo = GetIt.I.get<EsportRepository>();
    Leagues leagues = await repo.getLeagues();
    emit(LeagueState().copyWith(
      status: HomepageStatus.success,
      leagues: leagues.data.leagues,
      filteredLeagues: leagues.data.leagues
          .where((element) =>
              element.name.toLowerCase().contains(filter.toLowerCase()))
          .toList(),
    ));
  }

  late List<Datum> champs = [];
  late String filter = "";
}
