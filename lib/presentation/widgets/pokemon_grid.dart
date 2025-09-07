import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon/domain/entities/pokemon.dart';

class PokemonGrid extends StatelessWidget {
  final List<Pokemon> pokemons;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final int colums;
  const PokemonGrid({
    super.key,
    required this.pokemons,
    required this.scrollController,
    this.isLoadingMore = false,
    required this.colums,
  });

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: scrollController,
      crossAxisCount: colums, // 2 columnas
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(12),
      itemCount: pokemons.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= pokemons.length) {
          return SizedBox(
            width: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        final pokemon = pokemons[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => context.push('/pokemon/${pokemon.id}'),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(pokemon.imageUrl, width: 100, height: 100),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    pokemon.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
