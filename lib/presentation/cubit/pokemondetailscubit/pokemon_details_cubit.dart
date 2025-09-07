import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/config/core/get_it.dart';
import 'package:pokemon/domain/entities/pokemon_details.dart';
import 'package:pokemon/domain/repository/repository.dart';

part 'pokemon_details_state.dart';

class PokemonDetailCubit extends Cubit<PokemonDetailState> {
  final PokemonRepository repository;

  PokemonDetailCubit()
    : repository = getIt<PokemonRepository>(),
      super(PokemonDetailInitial());

  Future<void> loadPokemonDetail(String id) async {
    emit(PokemonDetailLoading());
    try {
      final pokemon = await repository.getPokemonDetail(id);
      emit(PokemonDetailLoaded(pokemon));
    } catch (e) {
      emit(PokemonDetailError(e.toString()));
    }
  }
}
