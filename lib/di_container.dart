import 'package:book_explorer/src/config/config_api.dart';
import 'package:book_explorer/src/core/application/api_interceptor.dart';
import 'package:book_explorer/src/core/application/navigation_service.dart';
import 'package:book_explorer/src/core/application/token_service.dart';
import 'package:book_explorer/src/core/data/repositories/cache_repository_impl.dart';
import 'package:book_explorer/src/core/domain/interfaces/interface_api_interceptor.dart';
import 'package:book_explorer/src/core/domain/interfaces/interface_cache_repository.dart';
import 'package:book_explorer/src/features/book/data/interfaces/interface_book_repository.dart';
import 'package:book_explorer/src/features/book/data/repository/book_repository.dart';
import 'package:book_explorer/src/features/book/presentation/providers/provider_book.dart';
import 'package:book_explorer/src/features/home/presentation/providers/provider_common.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {

  //using dependency-injection
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  ///REPOSITORIES
  //#region Repositories
  sl.registerLazySingleton<ICacheRepository>(() => CacheRepositoryImpl(sharedPreference: sl()));
  sl.registerLazySingleton<IBookRepository>(() => BookRepository(sl<Dio>()));
  //#endregion

  ///USE-CASES


  ///END of USE-CASES

  ///PROVIDERS
  //region Providers
  sl.registerFactory(() => ProviderCommon(),);
  sl.registerFactory(() => ProviderBook(sl<IBookRepository>()));

  //interceptors
  sl.registerLazySingleton<IApiInterceptor>(() => ApiInterceptor(baseUrl: ConfigApi.baseUrl));   ///CHANGE SERVER HERE

  /// Dio
  sl.registerLazySingleton<Dio>(() => Dio());

  ///services
  sl.registerSingleton(NavigationService());  //to initialize navigator-key for app-runtime
  sl.registerSingleton(TokenService()); //token service to store token app-runtime
  //logger
  sl.registerLazySingleton(()=>Logger(
    printer: PrettyPrinter(
      colors: false,
    ),
  ),);

}