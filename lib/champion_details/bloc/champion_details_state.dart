part of 'champion_details_bloc.dart';

enum ChampionDetailsStatus { initial, success, failure }

@immutable
class ChampionDetailsState extends Equatable {
  final ChampionDetailsStatus status;
  final bool loading;
  final Data? champions;

  const ChampionDetailsState(
      {this.status = ChampionDetailsStatus.initial,
      this.loading = true,
      this.champions});

  ChampionDetailsState copyWith({
    ChampionDetailsStatus? status,
    Data? champions,
    bool? loading,
  }) {
    return ChampionDetailsState(
        status: status ?? this.status,
        loading: loading ?? this.loading,
        champions: champions ?? this.champions);
  }

  @override
  List<Object?> get props => [];
}

class ChampionDetailsInitial extends ChampionDetailsState {}

class ChampionDetailsLoading extends ChampionDetailsState {}

class ChampionDetailsLoaded extends ChampionDetailsState {}
