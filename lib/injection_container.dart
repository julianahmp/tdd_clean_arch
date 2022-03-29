import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'core/network/network_info.dart';
import 'core/utils/input_converter.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory<NumberTriviaBloc>(() => NumberTriviaBloc(
        getConcreteNumberTrivia: sl(),
        getRandomNumberTrivia: sl(),
        inputConverter: sl(),
      ));

  sl.registerLazySingleton(() => GetConcreteNumberTrivia(repository: sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(repository: sl()));

  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            remoteDataSource: sl(),
            localDataSource: sl(),
            networkInfo: sl(),
          ));

  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
