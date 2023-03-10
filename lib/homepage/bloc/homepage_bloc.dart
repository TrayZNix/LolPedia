import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:lol_pedia/repositories/data_dragon_repository.dart';
// ignore: depend_on_referenced_packages
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'dart:math';

import '../../models/champion.dart';

part 'homepage_event.dart';
part 'homepage_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  int random = Random().nextInt(100);
  HomepageBloc() : super(HomepageInitial()) {
    on<LoadChampions>(
      cargarCampeones,
      transformer: throttleDroppable(throttleDuration),
    );
    on<FilterLoadedChampions>(filtrarCampeones);
  }

  Future<void> cargarCampeones(
      LoadChampions event, Emitter<HomepageState> emit) async {
    emit(HomepageLoading());
    DataDragonRepository repo = GetIt.I.get<DataDragonRepository>();
    List<Datum> champs = await repo.getChampions();
    if (kDebugMode) {
      print(random);
    }
    emit(HomepageLoaded().copyWith(
        status: HomepageStatus.success,
        champions: champs,
        filteredChamps: champs));
  }

  Future<void> filtrarCampeones(
      FilterLoadedChampions event, Emitter<HomepageState> emit) async {
    DataDragonRepository repo = GetIt.I.get<DataDragonRepository>();
    List<Datum> champs = await repo.getChampions();
    if (kDebugMode) {
      print(random);
    }
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

  late List<Datum> champs = [];
  late String filter = "si";
}
