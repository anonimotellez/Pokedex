import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/config/core/get_it.dart';
import 'package:pokemon/presentation/bloc/favoritesbloc/favoritesbloc_bloc.dart';
import 'package:pokemon/presentation/cubit/pokemondetailscubit/pokemon_details_cubit.dart';
import 'package:pokemon/presentation/widgets/info_cart_pokemon.dart';

class PokemonScreen extends StatelessWidget {
  final String? pokemonId;
  const PokemonScreen({super.key, this.pokemonId});

  @override
  Widget build(BuildContext context) {
    //final textStyles = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<PokemonDetailCubit, PokemonDetailState>(
          builder: (context, state) {
            if (state is PokemonDetailLoaded) {
              return Text(" ${state.pokemon.name}   ${state.pokemon.id}");
            }
            return const Text("Loading...");
          },
        ),
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            bloc: getIt<FavoritesBloc>(),
            builder: (context, favState) {
              final isFavorite = favState.favorites.contains(pokemonId);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  final bloc = getIt<FavoritesBloc>();
                  if (isFavorite) {
                    bloc.add(RemoveFavorite(pokemonId));
                  } else {
                    bloc.add(AddFavorite(pokemonId));
                  }
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PokemonDetailCubit, PokemonDetailState>(
        builder: (context, state) {
          if (state is PokemonDetailLoaded) {
            final pokemon = state.pokemon;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                // Image center
                Stack(
                  alignment: AlignmentGeometry.bottomCenter,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                            left: BorderSide(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Color.fromARGB(255, 64, 82, 185)
                                  : Color.fromARGB(255, 194, 74, 65),
                              width: 5,
                            ),
                            top: BorderSide(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Color.fromARGB(255, 64, 82, 185)
                                  : Color.fromARGB(255, 194, 74, 65),
                              width: 5,
                            ),
                            right: BorderSide(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Color.fromARGB(255, 64, 82, 185)
                                  : Color.fromARGB(255, 194, 74, 65),
                              width: 5,
                            ),
                          ),
                        ),
                        child: Image.network(
                          pokemon.imageUrl,
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            // ignore: deprecated_member_use
                            Colors.black.withOpacity(0.5),
                          ],
                          stops: [0.7, 1.0],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcOver,
                      child: Image.asset(
                        'assets/rock-pokemon.png',
                        height: 50,
                        width: 290,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: pokemon.types.map((type) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FilledButton(
                          onPressed: () {},
                          child: Text(type),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 32),

                // text horizontal
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          InfoCard(
                            icon: Icons.height_sharp,
                            mainText: '${pokemon.height}',
                            subText: 'Height',
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          InfoCard(
                            icon: Icons.monitor_weight_outlined,
                            mainText: '${pokemon.weight}',
                            subText: 'Weight',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          if (state is PokemonDetailError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
