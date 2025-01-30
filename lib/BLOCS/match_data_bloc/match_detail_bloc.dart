import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:lolpedia/models/items_interface.dart';
import 'package:lolpedia/models/match_data_details_interface.dart';
import 'package:lolpedia/models/match_data_window_interface.dart';
import 'package:lolpedia/models/match_details_interface.dart';
import 'package:lolpedia/repositories/data_dragon_repository.dart';
import 'package:lolpedia/repositories/esport_repository.dart';

// ignore: depend_on_referenced_packages
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
  final List<Game> matchId;
  int gamesPlayed;
  int currentDetailIndex = 0;
  late Items items;

  MatchDetailBloc(this.matchId, this.gamesPlayed, this.currentDetailIndex)
    : super(MatchDetailInitial()) {
    on<LoadMatchDetailsEvent>(
      cargarDetallesPartido,
      transformer: throttleDroppable(throttleDuration),
    );
    on<RecargarDetallesPartidoEvent>(
      recargarDetallesPartido,
      transformer: throttleDroppable(throttleDuration),
    );
    on<ChangeDetailsTabEvent>(
      returnState,
      transformer: throttleDroppable(Duration.zero),
    );
  }

  Future<void> cargarDetallesPartido(
    LoadMatchDetailsEvent event,
    Emitter<OriginalMatchDetailsState> emit,
  ) async {
    emit(MatchDetailLoading());
    try {
      MatchDetailsWindowInterface detailsWindows = await GetIt.I
          .get<EsportRepository>()
          .getConcreteMatchDataWindow(matchId[gamesPlayed - 1].id.toString());
      MatchDetailsInterface details = await GetIt.I
          .get<EsportRepository>()
          .getConcreteMatchDetail(matchId[gamesPlayed - 1].id.toString());
      String version = "";
      List<String> partes = detailsWindows.gameMetadata.patchVersion
          .toString()
          .split('.');
      if (partes.length >= 3) {
        version = "${partes[0]}.${partes[1]}.1";
      }
      items = await GetIt.I.get<DataDragonRepository>().getItems(version);

      emit(
        const MatchDetailsState().copyWith(
          matchDetails: details,
          matchDetailsWindows: detailsWindows,
          loaded: true,
        ),
      );
    } catch (e) {
      emit(MatchDetailLoadFail());
    }
  }

  Future<void> recargarDetallesPartido(
    RecargarDetallesPartidoEvent event,
    Emitter<OriginalMatchDetailsState> emit,
  ) async {
    try {
      MatchDetailsWindowInterface detailsWindows = await GetIt.I
          .get<EsportRepository>()
          .getConcreteMatchDataWindow(matchId[gamesPlayed - 1].id.toString());
      MatchDetailsInterface details = await GetIt.I
          .get<EsportRepository>()
          .getConcreteMatchDetail(matchId[gamesPlayed - 1].id.toString());
      emit(
        const MatchDetailsState().copyWith(
          matchDetails: details,
          matchDetailsWindows: detailsWindows,
          loaded: true,
        ),
      );
    } catch (e) {
      emit(MatchDetailLoadFail());
    }
  }

  Future<void> returnState(
    ChangeDetailsTabEvent event,
    Emitter<OriginalMatchDetailsState> emit,
  ) async {
    var estado = state;
    emit(MatchDetailLoading());
    Future.delayed(const Duration(milliseconds: 1150));
    emit(estado);
  }
}
