import 'package:dio/dio.dart';
import 'package:pokemon/domain/datasource/datasource.dart';
import 'package:pokemon/domain/entities/pokemon.dart';
import 'package:pokemon/domain/entities/pokemon_details.dart';

class PokemonDatasourceImpl extends PokemonDatasource {
  PokemonDatasourceImpl(this.dio);
  final Dio dio;

  @override
  Future<List<Pokemon>> getPokemons(int offset, int limit) async {
    //parameters to call the api
    final response = await dio.get(
      '/pokemon',
      queryParameters: {'offset': offset, 'limit': limit},
    );
    //if status is 200 call api
    if (response.statusCode == 200) {
      final results = response.data['results'] as List;
      return results
          .map(
            (json) => Pokemon(
              name: json['name'],
              url: json['url'],
              id: json['url']
                  .toString()
                  .split('/')
                  .where((part) => part.isNotEmpty)
                  .last,
              imageUrl:
                  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${json['url'].split('/')[json['url'].split('/').length - 2]}.png",
            ),
          )
          .toList();
    } else {
      //error
      throw Exception('Failed to load pokemons');
    }
  }

  @override
  Future<PokemonDetail> getPokemonDetail(String id) async {
    //call api of details pokemon
    final response = await dio.get('/pokemon/$id');
    //if status is 200 call api
    if (response.statusCode == 200) {
      final data = response.data;
      return PokemonDetail(
        id: data['id'],
        name: data['name'],
        imageUrl: data['sprites']['front_default'],
        height: data['height'],
        weight: data['weight'],
        types: data['types']
            .map<String>((typeInfo) => typeInfo['type']['name'] as String)
            .toList(),
      );
    } else {
      //error
      throw Exception('Failed to load pokemon details');
    }
  }
}
