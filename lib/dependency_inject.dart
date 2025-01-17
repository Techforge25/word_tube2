import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:word_toob/app_providers/app_setting_provider.dart';
import 'package:word_toob/app_providers/content_provider.dart';
import 'package:word_toob/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/common/app_constants/general.dart';
import 'package:word_toob/source/core/client_local.dart';
import 'package:word_toob/source/data_source/local_data_source.dart';
import 'package:word_toob/source/models/isar_collection/grid_local.dart';
import 'package:word_toob/source/models/isar_collection/grid_sized_local.dart';
import 'package:word_toob/source/repository/app_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> setup() async {
  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([GridSizedLocalSchema, GridLocalSchema],
      directory: dir.path);

  printLog("[setup] **** App Settings Applied ****");

  ///providers
  sl.registerLazySingleton<AppSettingsProvider>(() => AppSettingsProvider());
  sl.registerLazySingleton<ContentProvider>(
      () => ContentProvider(iAppRepository: sl()));
  sl.registerLazySingleton<MainDashboardController>(
      () => MainDashboardController());

  sl.registerLazySingleton<LocalClient>(() => LocalClient(isar: isar));

  sl.registerLazySingleton<ILocalDataSource>(
      () => LocalDataSource(localClient: sl()));

  sl.registerLazySingleton<IAppRepository>(
      () => AppRepository(localDataSource: sl()));

  //         iAuthenticationLocalDataSource: sl()));
  // sl.registerLazySingleton<AuthenticationProvider>(
  //         () => AuthenticationProvider(iAuthenticationRepository: sl()));
  // sl.registerLazySingleton<ContentProvider>(
  //         () => ContentProvider(iAppRepository: sl()));

  // dio.interceptors.addAll([
  //   if(kDebugMode)
  //     prettyLogger(),
  //   AuthInterceptor(dio,sl(), sl()),
  // ]);
}
