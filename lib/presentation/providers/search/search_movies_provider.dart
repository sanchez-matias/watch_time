import 'package:watch_time/domain/entities/movie.dart';
import 'package:watch_time/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedMoviesProvider =
    StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {
  final moviesRepository = ref.read(movieRepositoryProvider);

  return SearchedMoviesNotifier(
    searchMovies: moviesRepository.searchMovies,
    ref: ref,
  );
});

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier<List<Movie>> {
  final SearchMoviesCallback searchMovies;
  final Ref ref;
  SearchedMoviesNotifier({required this.searchMovies, required this.ref})
      : super([]);

  // We will call this method when we want to update our searchQueryProvider.
  Future<List<Movie>> searchMoviesByQuery(String query) async {
    ref.read(searchQueryProvider.notifier).update((state) => query);
    final List<Movie> movies = await searchMovies(query);
    state = movies;

    return movies;
  }
}
