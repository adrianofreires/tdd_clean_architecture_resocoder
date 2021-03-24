import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean_architecture_resocoder/core/network/network_info.dart';
import 'package:tdd_clean_architecture_resocoder/core/util/input_converter.dart';
import 'package:tdd_clean_architecture_resocoder/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_clean_architecture_resocoder/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_clean_architecture_resocoder/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:tdd_clean_architecture_resocoder/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_clean_architecture_resocoder/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_clean_architecture_resocoder/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:tdd_clean_architecture_resocoder/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'package:http/http.dart' as http;

final service_locator = GetIt.instance;

Future<void> init() async {
  //Features - Number Trivia
  service_locator.registerFactory(() => NumberTriviaBloc(
        concrete: service_locator(),
        inputConverter: service_locator(),
        random: service_locator(),
      ));

  //UseCases
  service_locator
      .registerLazySingleton(() => GetConcreteNumberTrivia(service_locator()));
  service_locator
      .registerLazySingleton(() => GetRandomNumberTrivia(service_locator()));

  //Repository
  service_locator.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDataSource: service_locator(),
          localDataSource: service_locator(),
          networkInfo: service_locator()));

  //DataSources
  service_locator.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: service_locator()));

  service_locator.registerLazySingleton<NumberTriviaLocalDataSource>(() =>
      NumberTriviaLocalDataSourceImpl(sharedPreferences: service_locator()));

  //Core
  service_locator.registerLazySingleton(() => InputConverter());
  service_locator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(service_locator()));

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  service_locator.registerLazySingleton(() => sharedPreferences);
  service_locator.registerLazySingleton(() => http.Client());
  service_locator.registerLazySingleton(() => DataConnectionChecker());
}
