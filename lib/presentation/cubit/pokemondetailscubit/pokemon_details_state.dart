part of 'pokemon_details_cubit.dart';

abstract class PokemonDetailState {}

class PokemonDetailInitial extends PokemonDetailState {}

class PokemonDetailLoading extends PokemonDetailState {}

class PokemonDetailLoaded extends PokemonDetailState {
  final PokemonDetail pokemon;
  PokemonDetailLoaded(this.pokemon);
}

class PokemonDetailError extends PokemonDetailState {
  final String message;
  PokemonDetailError(this.message);
}
