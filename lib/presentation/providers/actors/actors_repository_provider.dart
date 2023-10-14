import 'package:watch_time/infrastructure/datosources/actor_moviedb_datasource.dart';
import 'package:watch_time/infrastructure/repositories/actors_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsRepositoryProvider = Provider((ref) {
  return ActorsRespositoryImpl(ActorMoviedbDatasource());
});
