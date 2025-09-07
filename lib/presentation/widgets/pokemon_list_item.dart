import 'package:flutter/material.dart';
import 'package:pokemon/domain/entities/pokemon.dart';

//list of search of the pokemons

class PokemonListItem extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback? onTap;

  const PokemonListItem({super.key, required this.pokemon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return ListTile(
      leading: Image.network(pokemon.imageUrl, width: 100, height: 100),
      title: Text(pokemon.name, style: textStyles.titleMedium),
      subtitle: Text(pokemon.id.toString()),
      onTap: onTap,
    );
  }
}
