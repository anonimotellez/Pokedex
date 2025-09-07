import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/config/core/get_it.dart';
import 'package:pokemon/domain/entities/pokemon.dart';
import 'package:pokemon/domain/repository/repository.dart';
import 'package:pokemon/presentation/cubit/pokemonlistcubit/pokemon_list_state.dart';

class PokemonCubit extends Cubit<PokemonState> {
  final PokemonRepository repository;
  bool _isLoading = false;
  int _offset = 0;
  final int _limit = 100;
  List<Pokemon> allPokemons = [];

  PokemonCubit()
    : repository = getIt<PokemonRepository>(),
      super(PokemonInitial());

  Future<void> loadPokemons({bool loadMore = false}) async {
    if (_isLoading) return;
    _isLoading = true;

    await Future.delayed(const Duration(milliseconds: 300));

    if (!loadMore) {
      emit(PokemonLoading());
      _offset = 0;
    }

    try {
      final pokemons = await repository.getPokemons(_offset, _limit);

      if (state is PokemonLoaded && loadMore) {
        final current = (state as PokemonLoaded).pokemons;
        allPokemons.addAll(pokemons);
        emit(PokemonLoaded([...current, ...pokemons]));
      } else {
        allPokemons = [...pokemons];
        emit(PokemonLoaded(pokemons));
      }
      _offset += _limit;
    } catch (e) {
      emit(PokemonError('error'));
    } finally {
      _isLoading = false;
    }
  }
}
