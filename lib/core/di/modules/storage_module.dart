import 'package:injecteo/injecteo.dart';
import 'package:shared_preferences/shared_preferences.dart';

@externalModule
abstract class StorageConfigModule {
  @singleton
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}
