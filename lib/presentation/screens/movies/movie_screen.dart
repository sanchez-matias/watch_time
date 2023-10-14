import 'package:watch_time/presentation/providers/movies/movie_info_provider.dart';
import 'package:watch_time/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';

  final String movieId;
  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) => _MovieDetails(movie: movie),
            childCount: 1,
          )),
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Small poster
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),
              const SizedBox(width: 10),

              // Title and description
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(children: [
                  Text(movie.title, style: textStyles.titleLarge),
                  Text(movie.overview),
                ]),
              ),
            ],
          ),
        ),

        // Movie genres
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Chip(
                      backgroundColor: colors.primary.withOpacity(0.3),
                      label: Text(gender),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ))
            ],
          ),
        ),

        _ActorsByMovie(movieId: movie.id.toString()),
        const SizedBox(height: 100)
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);
    final colors = Theme.of(context).colorScheme;

    if (actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }

    final actors = actorsByMovie[movieId]!;
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
          return Container(
            padding: const EdgeInsets.all(8),
            width: 135,
            child: Column(
              children: [
                // Actor Photo
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    actor.profilePath,
                    height: 180,
                    width: 135,
                  ),
                ),

                const SizedBox(height: 5),

                // Actor Name
                Text(actor.name, maxLines: 2),
                Text(
                  actor.character ?? '',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.primary),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// I will set a future provider which will drop a boolean to indicate if this
// movie is on favorites or not. I use the family variation so it can accept
// taking an ID as a parameter to search into our local database.
final isFavoriteProvider =
    FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverAppBar({
    required this.movie,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      // Favorite Button
      actions: [
        Padding(
          padding: EdgeInsets.only(right: size.width * 0.03),
          child: IconButton(
              onPressed: () async {
                // This method only comunicates with the database and not with
                // the widget, so we will need to refresh it every time this flag
                // changes.
                await ref
                    .read(favoriteMoviesProvider.notifier)
                    .toggleFavorite(movie);

                // By using this method, we force the widget to refresh.
                ref.invalidate(isFavoriteProvider(movie.id));
              },
              icon: isFavoriteFuture.when(
                data: (isFavorite) => isFavorite
                    ? const Icon(Icons.favorite_rounded, color: Colors.red)
                    : const Icon(Icons.favorite_outline_rounded),
                loading: () => const CircularProgressIndicator.adaptive(),
                error: (error, stackTrace) => throw UnimplementedError(),
              )),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        // titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        // title: Text(
        //   movie.title,
        //   style: const TextStyle(fontSize: 20),
        //   textAlign: TextAlign.start,
        //   maxLines: 2,
        //   overflow: TextOverflow.ellipsis,
        // ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black87],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.7, 1],
              ))),
            )
          ],
        ),
      ),
    );
  }
}
