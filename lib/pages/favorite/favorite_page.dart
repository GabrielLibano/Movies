import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/pages/top_rated/widgets/top_rated_movie.dart';
import 'package:movie_app/services/api_services.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  ApiServices apiServices = ApiServices();
  late Future<Result> favoriteMovies;
  @override
  void initState() {
    favoriteMovies = apiServices.getFavoritesMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: FutureBuilder<Result>(
          future: favoriteMovies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Erro ao carregar os filmes favoritos'),
              );
            } else if (!snapshot.hasData || snapshot.data!.movies.isEmpty) {
              return const Center(
                child: Text('Nenhum filme top rated encontrado'),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data?.movies.length,
                  itemBuilder: (context, index) {
                    return TopRatedMovie(movie: snapshot.data!.movies[index]);
                  });
            }
          }),
    );
  }
}