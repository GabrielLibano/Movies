import 'dart:convert';

import 'package:movie_app/models/movie_genre_model.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/models/movie_detail_model.dart';
import 'package:movie_app/common/utils.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://api.themoviedb.org/3/';
const key = 'api_key=$apiKey';

class ApiServices {
  Future<bool> addFavoriteMovie(Movie movie) async {
    var bodyRequest = {
      "media_type": "movie",
    "media_id": movie.id, // Altere 'movie' para 'media_id'
    "favorite": true
    };

    const endPoint = 'account/$accontId/favorite';
    const url = '$baseUrl$endPoint';

    final response = await http.post(Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxNWU5OGM2ZjBkZTAwMjdmODY2ZTA3M2Q0OTRjMTQ0MCIsIm5iZiI6MTcyNjg0OTExNS40NTU2NjEsInN1YiI6IjY2ZWQ5ZGViMTg0NjU3MDA4ZWZlMTRjOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.MUh5_K2pGLkaUt5Gwbx3Qq5-QnKecaUBEuhC4q2Zgec'
        },
        body: jsonEncode(bodyRequest));

    if (response.statusCode == 201) {
      return true;
    }
    throw Exception('Erro ${response.statusCode}: ${response.body}'); // Inclua o corpo da resposta para depuração
  }

  Future<Result> getSearchMoviesByGenres(int id) async {
    final endPoint = 'discover/movie?with_genres=$id&';

    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load  movie details');
  }

  Future<List<MovieGenreModel>> getGeners() async {
    const endPoint = 'genre/movie/list';
    const url = '$baseUrl$endPoint?$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return parseGenres(response.body);
    }
    throw Exception('failed to load  movie details');
  }

  List<MovieGenreModel> parseGenres(String responseBody) {
    final parsed = jsonDecode(responseBody);

    return (parsed['genres'] as List)
        .map((json) => MovieGenreModel.fromJson(json))
        .toList();
  }

  Future<Result> getMovieRecommendations(int movieId) async {
    final endPoint = 'movie/$movieId/recommendations';
    final url = '$baseUrl$endPoint?$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load  movie details');
  }

  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    final endPoint = 'movie/$movieId';
    final url = '$baseUrl$endPoint?$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return MovieDetailModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load  movie details');
  }

  Future<Result> getSearchMovies(String searchText) async {
    final endPoint = 'search/movie?query=$searchText';
    final url = '$baseUrl$endPoint';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxNWU5OGM2ZjBkZTAwMjdmODY2ZTA3M2Q0OTRjMTQ0MCIsIm5iZiI6MTcyNjg0OTExNS40NTU2NjEsInN1YiI6IjY2ZWQ5ZGViMTg0NjU3MDA4ZWZlMTRjOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.MUh5_K2pGLkaUt5Gwbx3Qq5-QnKecaUBEuhC4q2Zgec'
    });
    if (response.statusCode == 200) {
      final movies = Result.fromJson(jsonDecode(response.body));
      return movies;
    }
    throw Exception('failed to load  search movie ');
  }

  Future<Result> getTopRatedMovies() async {
    const endpoint = "movie/top_rated";
    const url = "$baseUrl$endpoint?$key";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception("Ocorreu um erro ao carregar os filmes top rated");
  }

  Future<Result> getNowPlayingMovies() async {
    const endpoint = "movie/now_playing";
    const url = "$baseUrl$endpoint?$key";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception("Ocorreu um erro ao carregar os filmes top rated");
  }

  List<Movie> getMovies() {
    // Cria a lista de filmes

    final movie1 = Movie(
      adult: false,
      backdropPath: "/yDHYTfA3R0jFYba16jBB1ef8oIt.jpg",
      genreIds: [28, 35, 878],
      id: 533535,
      originalLanguage: "en",
      originalTitle: "Deadpool VS Wolverine",
      overview: "Deadpool & Wolverine",
      popularity: 13902.556,
      posterPath: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg",
      releaseDate: DateTime.parse("2024-07-24"),
      title: "Deadpool VS Wolverine",
      video: false,
      voteAverage: 7.858,
      voteCount: 1721,
    );

    final movie2 = Movie(
      adult: false,
      backdropPath: "/lgkPzcOSnTvjeMnuFzozRO5HHw1.jpg",
      genreIds: [28, 35, 878],
      id: 533535,
      originalLanguage: "en",
      originalTitle: "Despicable Me 4",
      overview: "Despicable Me 4",
      popularity: 13902.556,
      posterPath: "/wWba3TaojhK7NdycRhoQpsG0FaH.jpg",
      releaseDate: DateTime.parse("2024-07-24"),
      title: "Despicable Me 4",
      video: false,
      voteAverage: 7.858,
      voteCount: 1721,
    );

    final movie3 = Movie(
      adult: false,
      backdropPath: "/stKGOm8UyhuLPR9sZLjs5AkmncA.jpg",
      genreIds: [28, 35, 878],
      id: 533535,
      originalLanguage: "en",
      originalTitle: "Inside Out 2",
      overview: "Inside Out 2e",
      popularity: 13902.556,
      posterPath: "/stKGOm8UyhuLPR9sZLjs5AkmncA.jpg",
      releaseDate: DateTime.parse("2024-07-24"),
      title: "Inside Out 2",
      video: false,
      voteAverage: 7.858,
      voteCount: 1721,
    );

    List<Movie> movies = [
      movie1,
      movie2,
      movie3,
      movie1,
      movie2,
      movie3,
      movie1,
      movie2,
      movie3
    ];
    return movies;
  }

  Future<List<Movie>> getMoviesAsync() async {
    await Future.delayed(
        const Duration(seconds: 5)); // Simulação de carregamento
    // Cria a lista de filmes

    final movie1 = Movie(
      adult: false,
      backdropPath: "/yDHYTfA3R0jFYba16jBB1ef8oIt.jpg",
      genreIds: [28, 35, 878],
      id: 533535,
      originalLanguage: "en",
      originalTitle: "Deadpool VS Wolverine",
      overview: "Deadpool & Wolverine",
      popularity: 13902.556,
      posterPath: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg",
      releaseDate: DateTime.parse("2024-07-24"),
      title: "Deadpool VS Wolverine",
      video: false,
      voteAverage: 7.858,
      voteCount: 1721,
    );

    final movie2 = Movie(
      adult: false,
      backdropPath: "/lgkPzcOSnTvjeMnuFzozRO5HHw1.jpg",
      genreIds: [28, 35, 878],
      id: 533535,
      originalLanguage: "en",
      originalTitle: "Despicable Me 4",
      overview: "Despicable Me 4",
      popularity: 13902.556,
      posterPath: "/wWba3TaojhK7NdycRhoQpsG0FaH.jpg",
      releaseDate: DateTime.parse("2024-07-24"),
      title: "Despicable Me 4",
      video: false,
      voteAverage: 7.858,
      voteCount: 1721,
    );

    final movie3 = Movie(
      adult: false,
      backdropPath: "/stKGOm8UyhuLPR9sZLjs5AkmncA.jpg",
      genreIds: [28, 35, 878],
      id: 533535,
      originalLanguage: "en",
      originalTitle: "Inside Out 2",
      overview: "Inside Out 2e",
      popularity: 13902.556,
      posterPath: "/stKGOm8UyhuLPR9sZLjs5AkmncA.jpg",
      releaseDate: DateTime.parse("2024-07-24"),
      title: "Inside Out 2",
      video: false,
      voteAverage: 7.858,
      voteCount: 1721,
    );

    List<Movie> movies = [
      movie1,
      movie2,
      movie3,
      movie1,
      movie2,
      movie3,
      movie1,
      movie2,
      movie3
    ];
    return movies;
  }
}
