import 'package:watch_time/domain/entities/actor.dart';
import 'package:watch_time/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
      id: cast.id,
      name: cast.name,
      profilePath: cast.profilePath != null
          ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
          : 'https://appcdn.getkeywords.io/assets/images/empty_state/no_data.png',
      character: cast.character);
}
