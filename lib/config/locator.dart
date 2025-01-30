import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:lolpedia/config/locator.config.dart';
import 'package:lolpedia/repositories/data_dragon_repository.dart';
import 'package:lolpedia/repositories/esport_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/local_storage.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
void setupAsyncDependencies() {
  getIt.registerSingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );
  getIt.registerSingletonAsync<LocalStorageService>(
    () => LocalStorageService.getInstance(),
  );
  getIt.registerSingletonAsync<DataDragonRepository>(
    () => DataDragonRepository.getInstance(),
  );
  getIt.registerSingletonAsync<EsportRepository>(
    () => EsportRepository.getInstance(),
  );
}
