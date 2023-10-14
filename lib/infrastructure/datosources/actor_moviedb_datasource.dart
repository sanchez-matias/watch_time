import 'package:watch_time/domain/datasources/actors_datasource.dart';
import 'package:watch_time/domain/entities/actor.dart';
import 'package:watch_time/infrastructure/mappers/actor_mapper.dart';
import 'package:watch_time/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

import '../../config/constants/environment.dart';

class ActorMoviedbDatasource extends ActorsDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.movieDbKey,
      'language': 'es-MX',
    },
  ));

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');
    final castResponse = CreditsResponse.fromMap(response.data);
    return castResponse.cast
        .map((actor) => ActorMapper.castToEntity(actor))
        .toList();
  }
}
