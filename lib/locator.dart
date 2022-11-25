import 'package:get_it/get_it.dart';
import 'package:hope_app/services/services.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}
