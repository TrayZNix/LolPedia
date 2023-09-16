import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:lol_pedia/repositories/esport_repository.dart';

import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import '../../UIs/match_details/match_details_page.dart';
import '../../models/match_details_interface.dart';

part 'match_event.dart';
part 'match_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final String matchId;

  MatchBloc(this.matchId) : super(MatchInitial()) {
    on<LoadMatchEvent>(
      cargarDetallesPartido,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> cargarDetallesPartido(
      LoadMatchEvent event, Emitter<MatchState> emit) async {
    emit(MatchLoading());
    try {
      MatchDataInterface details =
          await GetIt.I.get<EsportRepository>().getMatchDetails(matchId);
      emit(
          const MatchDataState().copyWith(matchDetails: details, loaded: true));
    } catch (_) {
      emit(MatchLoadFail());
    }
  }
}
