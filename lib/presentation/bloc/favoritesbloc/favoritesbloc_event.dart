part of 'favoritesbloc_bloc.dart';

abstract class FavoritesEvent {}

class LoadFavorites extends FavoritesEvent {}

class AddFavorite extends FavoritesEvent {
  final String? pokemonId;
  AddFavorite(this.pokemonId);
}

class RemoveFavorite extends FavoritesEvent {
  final String? pokemonId;
  RemoveFavorite(this.pokemonId);
}
