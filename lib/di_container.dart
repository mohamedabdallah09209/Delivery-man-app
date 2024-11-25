import 'package:dio/dio.dart';
import 'package:app_delivary_task/features/auth/domain/reposotories/auth_repo.dart';
import 'package:app_delivary_task/features/chat/domain/reposotories/chat_repo.dart';
import 'package:app_delivary_task/features/language/domain/reposotories/language_repo.dart';
import 'package:app_delivary_task/features/order/domain/reposotories/order_repo.dart';
import 'package:app_delivary_task/features/profile/domain/reposotories/profile_repo.dart';
import 'package:app_delivary_task/features/splash/domain/reposotories/splash_repo.dart';
import 'package:app_delivary_task/features/order/domain/reposotories/tracker_repo.dart';
import 'package:app_delivary_task/features/auth/providers/auth_provider.dart';
import 'package:app_delivary_task/commons/providers/localization_provider.dart';
import 'package:app_delivary_task/features/language/providers/language_provider.dart';
import 'package:app_delivary_task/commons/providers/location_provider.dart';
import 'package:app_delivary_task/features/order/providers/order_provider.dart';
import 'package:app_delivary_task/features/profile/providers/profile_provider.dart';
import 'package:app_delivary_task/features/splash/providers/splash_provider.dart';
import 'package:app_delivary_task/commons/providers/theme_provider.dart';
import 'package:app_delivary_task/features/order/providers/tracker_provider.dart';
import 'package:app_delivary_task/utill/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'features/chat/providers/chat_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => LanguageRepo());
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => OrderRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => TrackerRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ChatRepo(dioClient: sl(), sharedPreferences: sl()));

  // Provider
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));
  sl.registerFactory(() => LanguageProvider(languageRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => ProfileProvider(profileRepo: sl()));
  sl.registerFactory(() => OrderProvider(orderRepo: sl()));
  sl.registerFactory(() => LocationProvider(sharedPreferences: sl()));
  sl.registerFactory(() => TrackerProvider(trackerRepo: sl()));
  sl.registerFactory(() => ChatProvider(chatRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
