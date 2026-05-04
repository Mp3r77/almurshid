import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:untitled1/core/network/network_info.dart';
import 'package:untitled1/core/utils/user_storage.dart';
import 'package:untitled1/features/doctors/domain/usecases/search_doctors.dart';

import '../core/network/api_client.dart';
import '../core/utils/user_bloc.dart';
import '../features/home/presentation/bloc/home_bloc.dart';
import '../features/appointment/data/datasources/appointment_remote_data_source.dart';
import '../features/appointment/data/repositories/appointment_repository_impl.dart';
import '../features/appointment/domain/repositories/appointment_repository.dart';
import '../features/appointment/domain/usecases/get_previous_appointments.dart';
import '../features/appointment/domain/usecases/get_upcoming_appointments.dart';
import '../features/appointment/domain/usecases/process_booking_usecase.dart';
import '../features/appointment/presentation/bloc/appointment_bloc.dart';
import '../features/doctors/data/datasources/doctors_remote_data_source.dart';
import '../features/doctors/data/repositories/doctors_repository_impl.dart';
import '../features/doctors/domain/repositories/doctors_repository.dart';
import '../features/doctors/domain/usecases/get_all_doctors.dart';
import '../features/doctors/presentation/bloc/doctors_bloc.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/diagnostics/presentation/bloc/diagnostics_bloc.dart';
import '../features/messages/presentation/bloc/messages_bloc.dart';
import '../features/notifications/presentation/bloc/notification_bloc.dart';

final sl = GetIt.instance;

void configureDependencies() {
  _registerDependencies();
}

void registerExternalDependencies() {
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<TokenStorage>(() => SimpleTokenStorage());
  sl.registerLazySingleton<UserStorage>(() => UserStorageImpl());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoSimpleImpl());
  sl.registerLazySingleton<Dio>(() => Dio());
}

void _registerDependencies() {
  sl.registerFactory<UserBloc>(() => UserBloc(userStorage: sl<UserStorage>()));
  sl.registerFactory<HomeBloc>(() => HomeBloc(userStorage: sl<UserStorage>()));
  sl.registerLazySingleton<NotificationBloc>(() => NotificationBloc());
  sl.registerFactory<MessagesBloc>(() => MessagesBloc());
  sl.registerFactory<AuthBloc>(() => AuthBloc());
  sl.registerFactory<DiagnosticsBloc>(() => DiagnosticsBloc());

  sl.registerLazySingleton<ApiClient>(() => ApiClient(
        dio: sl<Dio>(),
        tokenStorage: sl<TokenStorage>(),
      ));

  sl.registerLazySingleton<DoctorsRemoteDataSource>(
      () => DoctorsRemoteDataSourceImpl(
            apiClient: sl<ApiClient>(),
          ));
  sl.registerLazySingleton<DoctorsRepository>(() => DoctorsRepositoryImpl(
        remoteDataSource: sl<DoctorsRemoteDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ));
  sl.registerLazySingleton<GetAllDoctors>(
      () => GetAllDoctors(sl<DoctorsRepository>()));
  sl.registerLazySingleton<SearchDoctors>(
      () => SearchDoctors(sl<DoctorsRepository>()));
  sl.registerFactory<DoctorsBloc>(() => DoctorsBloc(
        getAllDoctors: sl<GetAllDoctors>(),
        searchDoctors: sl<SearchDoctors>(),
      ));

  sl.registerLazySingleton<AppointmentRemoteDataSource>(
      () => AppointmentRemoteDataSourceImpl(
            apiClient: sl<ApiClient>(),
          ));
  sl.registerLazySingleton<AppointmentRepository>(
      () => AppointmentRepositoryImpl(
            remoteDataSource: sl<AppointmentRemoteDataSource>(),
            networkInfo: sl<NetworkInfo>(),
          ));
  sl.registerLazySingleton<GetUpcomingAppointments>(
      () => GetUpcomingAppointments(sl<AppointmentRepository>()));
  sl.registerLazySingleton<GetPreviousAppointments>(
      () => GetPreviousAppointments(sl<AppointmentRepository>()));
  sl.registerLazySingleton<ProcessBookingUseCase>(
      () => ProcessBookingUseCase(sl<AppointmentRepository>()));
  sl.registerFactory<AppointmentBloc>(() => AppointmentBloc(
        getUpcomingAppointments: sl<GetUpcomingAppointments>(),
        getPreviousAppointments: sl<GetPreviousAppointments>(),
        processBookingUseCase: sl<ProcessBookingUseCase>(),
        notificationBloc: sl<NotificationBloc>(),
      ));
}
