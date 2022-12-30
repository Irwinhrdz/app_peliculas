import 'package:app_peliculas/providers/movie_provider.dart';
import 'package:app_peliculas/search/search_delegate.dart';
import 'package:app_peliculas/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    // print(moviesProvider.onDisplayMovies);

    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cine.'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: () =>
                showSearch(context: context, delegate: MovieSearchDelegate()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //principal Cards
            CardSwiper(movies: moviesProvider.onDisplayMovies),

            //movies slider
            MovieSlider(
              popular: moviesProvider.onDisplayPopular,
              title: 'Populares!',
              onNextPage: () => moviesProvider.getPopularMovies(),
            ),

            //
          ],
        ),
      ),
    );
  }
}
