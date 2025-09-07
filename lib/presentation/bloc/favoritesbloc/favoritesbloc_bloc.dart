import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'favoritesbloc_event.dart';
part 'favoritesbloc_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);

    add(LoadFavorites()); // load favorites on start
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('favorites') ?? [];
    emit(FavoritesState(favorites: list));
  }

  Future<void> _onAddFavorite(
    AddFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    final newList = [...state.favorites, event.pokemonId];
    emit(state.copyWith(favorites: newList.map((e) => e.toString()).toList()));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favorites',
      newList.map((e) => e.toString()).toList(),
    );
  }

  Future<void> _onRemoveFavorite(
    RemoveFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    final newList = state.favorites
        .where((id) => id != event.pokemonId)
        .toList();
    emit(state.copyWith(favorites: newList));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favorites',
      newList.map((e) => e.toString()).toList(),
    );
  }
}
