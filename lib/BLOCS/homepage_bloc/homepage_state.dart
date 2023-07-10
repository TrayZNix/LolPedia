part of 'homepage_bloc.dart';

enum HomepageStatus { initial, success, failure }

@immutable
class HomepageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChampionState extends HomepageState {
  final HomepageStatus status;
  final bool loading;
  final List<Datum> champions;
  final List<Datum> filteredChamps;

  ChampionState(
      {this.status = HomepageStatus.initial,
      this.loading = true,
      this.champions = const <Datum>[],
      this.filteredChamps = const <Datum>[]});

  ChampionState copyWith({
    HomepageStatus? status,
    List<Datum>? champions,
    List<Datum>? filteredChamps,
    bool? loading,
  }) {
    return ChampionState(
        status: status ?? this.status,
        loading: loading ?? this.loading,
        filteredChamps: filteredChamps ?? this.filteredChamps,
        champions: champions ?? this.champions);
  }

  @override
  List<Object?> get props => [status, champions, loading];
}

class LeagueState extends HomepageState {
  final HomepageStatus status;
  final bool loading;
  final List<League> leagues;
  final List<League> filteredLeagues;

  LeagueState(
      {this.status = HomepageStatus.initial,
      this.loading = true,
      this.leagues = const <League>[],
      this.filteredLeagues = const <League>[]});

  LeagueState copyWith({
    HomepageStatus? status,
    List<League>? leagues,
    List<League>? filteredLeagues,
    bool? loading,
  }) {
    return LeagueState(
        status: status ?? this.status,
        loading: loading ?? this.loading,
        filteredLeagues: filteredLeagues ?? this.filteredLeagues,
        leagues: leagues ?? this.leagues);
  }

  @override
  List<Object?> get props => [status, leagues, loading];
}

class HomepageInitial extends HomepageState {}

class HomepageLoading extends HomepageState {}

class HomepageLoaded extends ChampionState {}

class HomepageFilterChampions extends HomepageState {}
