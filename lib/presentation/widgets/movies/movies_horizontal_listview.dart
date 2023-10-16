import 'package:animate_do/animate_do.dart';
import 'package:watch_time/config/helpers/human_formats.dart';
import 'package:watch_time/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoviesHorizontalListview extends StatefulWidget {
  final List<Movie> movies;
  final String? title;

  final VoidCallback? loadNextPage;

  const MoviesHorizontalListview({
    super.key,
    required this.movies,
    this.title,
    this.loadNextPage,
  });

  @override
  State<MoviesHorizontalListview> createState() =>
      _MoviesHorizontalListviewState();
}

class _MoviesHorizontalListviewState extends State<MoviesHorizontalListview> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;
      if (scrollController.position.pixels + 200 >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: Column(
        children: [
          if (widget.title != null) _Title(title: widget.title!),
          Expanded(
              child: ListView.builder(
            controller: scrollController,
            itemCount: widget.movies.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return FadeInRight(child: _Slide(movie: widget.movies[index]));
            },
          ))
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  const _Title({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(title, style: titleStyle),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: colors.primary,
        ),
        onTap: () {},
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster image
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onTap: () => context.push('/movie/${movie.id}'),
                child: FadeInImage(
                    height: 220,
                    fit: BoxFit.cover,
                    placeholder:
                        const AssetImage('assets/loaders/bottle-loader.gif'),
                    image: NetworkImage(movie.posterPath)),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // title
          SizedBox(
            width: 135,
            child: Text(
              movie.title,
              maxLines: 2,
              style: titleStyle.bodyMedium,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const Spacer(),

          // raiting
          SizedBox(
            width: 135,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_half, color: Colors.yellow.shade800),
                Text(
                  '${movie.voteAverage}',
                  style: titleStyle.bodyMedium
                      ?.copyWith(color: Colors.yellow.shade800),
                ),
                const SizedBox(width: 15),
                //Text('${movie.popularity}', style: titleStyle.bodySmall)
                Text(HumanFormats.number(movie.popularity),
                    style: titleStyle.bodySmall)
              ],
            ),
          )
        ],
      ),
    );
  }
}
