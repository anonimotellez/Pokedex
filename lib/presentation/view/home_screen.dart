import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon/config/core/get_it.dart';
import 'package:pokemon/domain/entities/pokemon.dart';
import 'package:pokemon/presentation/bloc/themebloc/theme_bloc.dart';
import 'package:pokemon/presentation/cubit/pokemonlistcubit/pokemon_list_cubit.dart';
import 'package:pokemon/presentation/cubit/pokemonlistcubit/pokemon_list_state.dart';
import 'package:pokemon/presentation/delegates/search_pokemon_delegate.dart';
import 'package:pokemon/presentation/widgets/pokemon_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final cubit = getIt<PokemonCubit>();
    //initState for call of beginning
    if (cubit.state is PokemonInitial && cubit.allPokemons.isEmpty) {
      getIt<PokemonCubit>().loadPokemons(); //
    }

    //scroll and call of loadPokemons
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        getIt<PokemonCubit>().loadPokemons(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokédex"),
        actions: [
          //icon search
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch<Pokemon?>(
                context: context,
                delegate: SearchPokemonDelegate(),
              );

              if (result != null && context.mounted) {
                context.push('/pokemon/${result.id}');
              }
            },
          ),
          IconButton(
            onPressed: () {
              //add with a click the theme in the icon
              getIt<ThemeBloc>().add(ToggleTheme());
            },
            icon: Icon(
              // Switch between light and dark icon depending on the current state
              getIt<ThemeBloc>().state.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: BlocBuilder<PokemonCubit, PokemonState>(
        builder: (context, state) {
          if (state is PokemonLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/pokemon-loading.gif',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 50),
                Center(child: CircularProgressIndicator()),
              ],
            );
          }
          if (state is PokemonLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                getIt<PokemonCubit>().loadPokemons();
                await Future.delayed(Duration(microseconds: 500));
              },
              child: PokemonGrid(
                pokemons: state.pokemons,
                scrollController: _scrollController,
                isLoadingMore: true,
                colums: 3,
              ),
            );
          }
          if (state is PokemonError) {
            return RefreshIndicator(
              onRefresh: () async {
                getIt<PokemonCubit>().loadPokemons();
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Center(
                      child: Image.asset('assets/pokemon-loading.gif'),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getIt<PokemonCubit>().loadPokemons();
        },
        child: Icon(Icons.refresh_outlined),
      ),
    );
  }
}
