import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/pages/top_rated/widgets/top_rated_movie.dart';
import 'package:movie_app/services/api_services.dart';

class TopRatedPage extends StatefulWidget {
  const TopRatedPage({super.key});

  @override
  State<TopRatedPage> createState() => _TopRatedPageState();
}

class _TopRatedPageState extends State<TopRatedPage> {
  ApiServices apiServices = ApiServices();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: FutureBuilder<Result>(
          future: apiServices.getTopRatedMovies(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Erro ao carregar os filmes top rated'),
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
// itemCount: movies.length,
//         itemBuilder: (context, index) {
//           return TopRatedMovie(movie: movies[index]);
//         },