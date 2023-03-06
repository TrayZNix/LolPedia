part of 'homepage_bloc.dart';

enum HomepageStatus { initial, success, failure }

@immutable
class HomepageState extends Equatable {
  final HomepageStatus status;
  final bool loading;
  final List<Datum> champions;

  const HomepageState(
      {this.status = HomepageStatus.initial,
      this.loading = true,
      this.champions = const <Datum>[]});

  HomepageState copyWith({
    HomepageStatus? status,
    List<Datum>? champions,
    bool? loading,
  }) {
    return HomepageState(
        status: status ?? this.status,
        loading: loading ?? this.loading,
        champions: champions ?? this.champions);
  }

  @override
  List<Object?> get props => [];
}

class HomepageInitial extends HomepageState {}

class HomepageLoading extends HomepageState {}

class HomepageLoaded extends HomepageState {}
