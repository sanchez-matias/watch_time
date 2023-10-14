import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/movie.dart';

class MoviesPosterLink extends StatelessWidget {
  final Movie movie;
  const MoviesPosterLink({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: GestureDetector(
        onTap: () {
          context.push('/movie/${movie.id}');
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: FadeIn(child: Image.network(movie.posterPath)),
        ),
      ),
    );
  }
}
