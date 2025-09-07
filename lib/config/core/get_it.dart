import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon/domain/datasource/datasource.dart';
import 'package:pokemon/domain/repository/repository.dart';
import 'package:pokemon/infrastructure/datasource/pokemon_datasource_impl.dart';
import 'package:pokemon/infrastructure/repository/pokemon_repository_imp.dart';
import 'package:pokemon/presentation/bloc/favoritesbloc/favoritesbloc_bloc.dart';
import 'package:pokemon/presentation/bloc/sightingsbloc/sightings_bloc.dart';
import 'package:pokemon/presentation/bloc/themebloc/theme_bloc.dart';

import 'package:pokemon/presentation/cubit/pokemondetailscubit/pokemon_details_cubit.dart';
import 'package:pokemon/presentation/cubit/pokemonlistcubit/pokemon_list_cubit.dart';
import 'package:pokemon/presentation/cubit/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Dio
  getIt.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/v2')),
  );

  // Datasource
  getIt.registerLazySingleton<PokemonDatasource>(
    () => PokemonDatasourceImpl(getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<PokemonRepository>(
    () => PokemonRepositoryImp(getIt<PokemonDatasource>()),
  );
  //theme cubit
  getIt.registerLazySingleton(() => ThemeCubit());
  //theme bloc
  getIt.registerLazySingleton(() => ThemeBloc());
  //favirites
  getIt.registerLazySingleton(() => FavoritesBloc());
  // SharedPreferences
  getIt.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );

  // SightingsBloc
  getIt.registerFactory<SightingsBloc>(
    () => SightingsBloc(getIt<SharedPreferences>()),
  );

  // PokemonCubit
  getIt.registerLazySingleton<PokemonCubit>(() => PokemonCubit());
  //PokemonDetails
  getIt.registerFactory(() => PokemonDetailCubit());
}
