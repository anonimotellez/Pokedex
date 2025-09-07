import 'package:pokemon/domain/datasource/datasource.dart';
import 'package:pokemon/domain/entities/pokemon.dart';
import 'package:pokemon/domain/entities/pokemon_details.dart';
import 'package:pokemon/domain/repository/repository.dart';

class PokemonRepositoryImp extends PokemonRepository {
  final PokemonDatasource datasource;

  PokemonRepositoryImp(this.datasource);

  @override
  Future<List<Pokemon>> getPokemons(int offset, int limit) {
    return datasource.getPokemons(offset, limit);
  }

  @override
  Future<PokemonDetail> getPokemonDetail(String id) {
    return datasource.getPokemonDetail(id);
  }
}
