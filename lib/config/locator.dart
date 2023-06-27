import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:lol_pedia/config/locator.config.dart';
import 'package:lol_pedia/repositories/data_dragon_repository.dart';
import 'package:lol_pedia/repositories/esport_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/local_storage.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
void setupAsyncDependencies() {
  getIt.registerSingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance());
  getIt.registerSingletonAsync<LocalStorageService>(
      () => LocalStorageService.getInstance());
  getIt.registerSingletonAsync<DataDragonRepository>(
      () => DataDragonRepository.getInstance());
  getIt.registerSingletonAsync<EsportRepository>(
      () => EsportRepository.getInstance());
}
