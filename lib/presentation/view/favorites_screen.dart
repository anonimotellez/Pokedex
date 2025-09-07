import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/config/core/get_it.dart';
import 'package:pokemon/presentation/bloc/favoritesbloc/favoritesbloc_bloc.dart';
import 'package:pokemon/presentation/cubit/pokemonlistcubit/pokemon_list_cubit.dart';
import 'package:pokemon/presentation/widgets/pokemon_grid.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allPokemons = getIt<PokemonCubit>().allPokemons;

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        bloc: getIt<FavoritesBloc>(),
        builder: (context, favState) {
          final favoritePokemons = allPokemons
              .where((p) => favState.favorites.contains(p.id))
              .toList();

          if (favoritePokemons.isEmpty) {
            return const Center(child: Text('No tienes favoritos'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              getIt<PokemonCubit>().loadPokemons();
              getIt<FavoritesBloc>().add(LoadFavorites());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: PokemonGrid(
              pokemons: favoritePokemons,
              scrollController: ScrollController(),
              colums: 2,
            ),
          );
        },
      ),
    );
  }
}
