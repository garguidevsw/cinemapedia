import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMoviedbDataSource extends ActorsDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX'
      },
    ),
  );

  List<Actor> _jsonToActors(Map<String, dynamic> json) {
    final creditsResponse = CreditsResponse.fromJson(json);

    final List<Cast> cast = creditsResponse.cast;

    final List<Actor> actors =
        cast.map((cast) => ActorMapper.castToEntity(cast)).toList();

    return actors;
  }

  @override
  Future<List<Actor>> getActorsMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');
    return _jsonToActors(response.data);
  }
}
