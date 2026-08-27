import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nsdelivery_vendor_app/src/configs/injector/injector.dart';

final getIt = GetIt.I;

void configureDepedencies() {
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        validateStatus: (status) => status != null && status < 400,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(ApiInterceptor(dio));
    return dio;
  });

  /// App Essentials
  getIt.registerLazySingleton(() => ThemeBloc());

  getIt.registerLazySingleton(() => TranslateBloc());

  getIt.registerLazySingleton(() => AppRouteConf());

  getIt.registerFactory(() => BottomNav3Bloc());

  getIt.registerLazySingleton(() => AuthLoginUseCase(getIt<AuthRepositoryImpl>()));

  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepositoryImpl>()));

  getIt.registerFactory(() => AuthLoginFormBloc());

  getIt.registerFactory(
    () => AuthLoginBloc(
      getIt<AuthLoginUseCase>(),
      getIt<LogoutUseCase>(),
    ),
  );

  getIt.registerLazySingleton(() => ForgotPasswordUseCase(getIt<AuthRepositoryImpl>()));

  getIt.registerFactory(() => ForgotPasswordBloc(getIt<ForgotPasswordUseCase>()));

  /// Menu Management
  getIt.registerLazySingleton(() => ItemsListUseCase(getIt<AuthRepositoryImpl>()));

  getIt.registerFactory(() => ItemsListBloc(getIt<ItemsListUseCase>()));

  /// Orders
  getIt.registerLazySingleton(() => OrderHistoryUseCase(getIt<AuthRepositoryImpl>()));

  getIt.registerFactory(() => OrderHistoryBloc(getIt<OrderHistoryUseCase>()));

  getIt.registerLazySingleton(() => OrdersListUseCase(getIt<AuthRepositoryImpl>()));

  getIt.registerFactory(() => OrdersListBloc(getIt<OrdersListUseCase>()));

  getIt.registerLazySingleton(() => OrderDetailsUseCase(getIt<AuthRepositoryImpl>()));

  getIt.registerFactory(() => OrderDetailsBloc(getIt<OrderDetailsUseCase>()));

  /// Dashboard / Serviceability
  getIt.registerLazySingleton(() => ServiceabilityUpdateUseCase(getIt<AuthRepositoryImpl>()));

  getIt.registerFactory(() => ServiceabilityBloc(getIt<ServiceabilityUpdateUseCase>()));

  /// Settings / Time Slots
  getIt.registerLazySingleton(() => SlotsListUseCase(getIt<AuthRepositoryImpl>()));

  getIt.registerFactory(() => SlotsListBloc(getIt<SlotsListUseCase>()));

  getIt.registerLazySingleton(() => SlotCreateUseCase(getIt<AuthRepositoryImpl>()));

  getIt.registerFactory(() => SlotCreateBloc(getIt<SlotCreateUseCase>()));

  getIt.registerLazySingleton(() => SlotUpdateUseCase(getIt<AuthRepositoryImpl>()));

  getIt.registerFactory(() => SlotUpdateBloc(getIt<SlotUpdateUseCase>()));

  getIt.registerLazySingleton(() => SlotDeleteUseCase(getIt<AuthRepositoryImpl>()));

  getIt.registerFactory(() => SlotDeleteBloc(getIt<SlotDeleteUseCase>()));

  /// Other api blocs


  /// API Helper

  getIt.registerLazySingleton(() => NetworkInfo());

  getIt.registerLazySingleton(() => AuthRepositoryImpl(getIt<RemoteDataSourceImpl>(), getIt<NetworkInfo>()),);

  getIt.registerLazySingleton(() => RemoteDataSourceImpl(getIt<ApiHelper>()));

  getIt.registerLazySingleton(() => ApiHelper(getIt<Dio>()));
}
