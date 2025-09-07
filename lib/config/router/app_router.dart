import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon/config/core/get_it.dart';
import 'package:pokemon/presentation/bloc/sightingsbloc/sightings_bloc.dart';
import 'package:pokemon/presentation/cubit/pokemondetailscubit/pokemon_details_cubit.dart';
import 'package:pokemon/presentation/cubit/pokemonlistcubit/pokemon_list_cubit.dart';
import 'package:pokemon/presentation/view/Sightings_screen.dart';
import 'package:pokemon/presentation/view/favorites_screen.dart';
import 'package:pokemon/presentation/view/home_screen.dart';
import 'package:pokemon/presentation/view/pokemon_screen.dart';
import 'package:pokemon/presentation/widgets/custom_bottom_navigation.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    //remember state
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(child: navigationShell);
      },
      branches: [
        /// Branch 1 - Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) {
                return BlocProvider.value(
                  value: getIt<PokemonCubit>(),
                  child: HomeScreen(),
                );
              },
              routes: [
                GoRoute(
                  path: 'pokemon/:id',
                  name: 'PokemonDetails',
                  builder: (context, state) {
                    final id = state.pathParameters['id'];
                    return BlocProvider(
                      create: (_) =>
                          getIt<PokemonDetailCubit>()..loadPokemonDetail(id!),
                      child: PokemonScreen(pokemonId: id),
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        /// Branch 2 - Favorites
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorite',
              name: 'favorite',
              builder: (context, state) => const FavoritesScreen(),
            ),
          ],
        ),

        /// Branch 3 - sightings
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/sight',
              name: 'sight',
              builder: (context, state) {
                return BlocProvider.value(
                  value: getIt<SightingsBloc>(),
                  child: const SightingsScreen(),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
