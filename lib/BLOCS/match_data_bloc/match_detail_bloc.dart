import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:lol_pedia/models/match_data_details_interface.dart';
import 'package:lol_pedia/models/match_data_window_interface.dart';
import 'package:lol_pedia/repositories/esport_repository.dart';

import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'match_detail_event.dart';
part 'match_detail_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MatchDetailBloc
    extends Bloc<MatchDetailsEvent, OriginalMatchDetailsState> {
  final String matchId;
  int gamesPlayed;

  MatchDetailBloc(this.matchId, this.gamesPlayed)
      : super(MatchDetailInitial()) {
    on<LoadMatchDetailsEvent>(
      cargarDetallesPartido,
      transformer: throttleDroppable(throttleDuration),
    );
    on<RecargarDetallesPartidoEvent>(
      recargarDetallesPartido,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> cargarDetallesPartido(LoadMatchDetailsEvent event,
      Emitter<OriginalMatchDetailsState> emit) async {
    emit(MatchDetailLoading());
    try {
      int id = int.parse(matchId);
      id = id + gamesPlayed;
      MatchDetailsWindowInterface detailsWindows = await GetIt.I
          .get<EsportRepository>()
          .getConcreteMatchDataWindow(id.toString());
      MatchDetailsInterface details = await GetIt.I
          .get<EsportRepository>()
          .getConcreteMatchDetail(id.toString());
      emit(const MatchDetailsState().copyWith(
          matchDetails: details,
          matchDetailsWindows: detailsWindows,
          loaded: true));
    } catch (e) {
      emit(MatchDetailLoadFail());
    }
  }

  Future<void> recargarDetallesPartido(RecargarDetallesPartidoEvent event,
      Emitter<OriginalMatchDetailsState> emit) async {
    try {
      int id = int.parse(matchId);
      id = id + gamesPlayed;
      MatchDetailsWindowInterface detailsWindows = await GetIt.I
          .get<EsportRepository>()
          .getConcreteMatchDataWindow(id.toString());
      MatchDetailsInterface details = await GetIt.I
          .get<EsportRepository>()
          .getConcreteMatchDetail(id.toString());
      emit(const MatchDetailsState().copyWith(
          matchDetails: details,
          matchDetailsWindows: detailsWindows,
          loaded: true));
    } catch (e) {
      emit(MatchDetailLoadFail());
    }
  }
}
