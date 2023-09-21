part of 'match_detail_bloc.dart';

abstract class MatchDetailsEvent extends Equatable {
  const MatchDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadMatchDetailsEvent extends MatchDetailsEvent {}

class RecargarDetallesPartidoEvent extends MatchDetailsEvent {}
