import 'package:flutter/material.dart';
import 'package:pokemon/config/core/get_it.dart';
import 'package:pokemon/domain/entities/pokemon.dart';
import 'package:pokemon/presentation/cubit/pokemonlistcubit/pokemon_list_cubit.dart';
import 'package:pokemon/presentation/widgets/pokemon_list_item.dart';

// Class that extends SearchDelegate to search for Pokemons
class SearchPokemonDelegate extends SearchDelegate<Pokemon?> {
  // Text in the search field
  @override
  String get searchFieldLabel => 'Buscar Pokemon';

  // Actions of the search field
  @override
  List<Widget>? buildActions(BuildContext context) {
    // If there is text written in the search, add an X to clear
    return [
      if (query.isNotEmpty)
        //clear the search
        IconButton(onPressed: () => query = '', icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      // Close the search without returning nothing and return to pokemonList
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Get all the pokemons from the cubit
    final pokemons = getIt<PokemonCubit>().allPokemons;
    // Filters results based on the text entered
    final results = pokemons.where((p) {
      // name in lower case
      final name = p.name.toLowerCase();

      final id = p.id.toString();
      //query in lower case
      final q = query.toLowerCase();
      // Match if the name contains the text or if the id is exact
      return name.contains(q) || id == q;
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text('No se encontraron resultados'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final p = results[index];
        return PokemonListItem(pokemon: p, onTap: () => close(context, p));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final pokemons = getIt<PokemonCubit>().allPokemons;
    final suggestions = pokemons.where((p) {
      final name = p.name;
      final id = p.id.toString();
      final q = query.toLowerCase();
      return name.contains(q) || id == q;
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final p = suggestions[index];
        // Close the search and return the selected pokemon
        return PokemonListItem(pokemon: p, onTap: () => close(context, p));
      },
    );
  }
}
