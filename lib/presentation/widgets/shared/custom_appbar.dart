import 'package:watch_time/presentation/delegates/search_movie_delegate.dart';
import 'package:watch_time/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/movie.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
        bottom: false,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Icon(
                    Icons.movie_creation_rounded,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 10),
                  Text('CINEMAPEDIA', style: textStyle),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // Here will be stored the reference to the searchMovies
                      // function on our MovieDbDatasourse.
                      final searchedMovies = ref.read(searchedMoviesProvider);
                      final searchQuery = ref.read(searchQueryProvider);

                      // The function that shows a search bar on the top.
                      // Its default value will always be an empty string but we
                      // will allways keep the last query entered.
                      showSearch<Movie?>(
                        query: searchQuery,
                        context: context,
                        delegate: SearchMovieDelegate(
                          initialMovies: searchedMovies,
                          searchMovies: ref
                              .read(searchedMoviesProvider.notifier)
                              .searchMoviesByQuery,
                        ),
                      ).then((movie) {
                        //* log(movie?.title);
                        if (movie == null) return;
                        context.push('/movie/${movie.id}');
                      });
                    },
                  )
                ],
              ),
            )));
  }
}
