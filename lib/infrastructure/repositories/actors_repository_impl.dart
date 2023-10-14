import 'package:watch_time/domain/datasources/actors_datasource.dart';
import 'package:watch_time/domain/entities/actor.dart';
import 'package:watch_time/domain/repositories/actors_repository.dart';

class ActorsRespositoryImpl extends ActorsRepository {
  final ActorsDatasource datasource;

  ActorsRespositoryImpl(this.datasource);
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) {
    return datasource.getActorsByMovie(movieId);
  }
}
