part of 'favoritesbloc_bloc.dart';

class FavoritesState {
  final List<String> favorites; // Id of pokemones
  FavoritesState({this.favorites = const []});

  FavoritesState copyWith({List<String>? favorites}) {
    return FavoritesState(favorites: favorites ?? this.favorites);
  }
}
