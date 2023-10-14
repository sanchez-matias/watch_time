import 'package:watch_time/infrastructure/datosources/moviedb_datasource.dart';
import 'package:watch_time/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(MovieDbDatasource());
});
