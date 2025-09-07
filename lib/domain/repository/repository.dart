import 'package:pokemon/domain/entities/pokemon.dart';
import 'package:pokemon/domain/entities/pokemon_details.dart';

//application logic
abstract class PokemonRepository {
  Future<List<Pokemon>> getPokemons(int offset, int limit);
  Future<PokemonDetail> getPokemonDetail(String id);
}
