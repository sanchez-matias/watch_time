import 'package:watch_time/infrastructure/datosources/isar_datasource.dart';
import 'package:watch_time/infrastructure/repositories/local_storage_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageRepositoryProvider = Provider(
  (ref) => LocalStorageRepositoryImpl(IsarDatasource()),
);
