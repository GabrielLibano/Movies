import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/pages/search/widgets/movie_search.dart';
import 'package:movie_app/services/api_services.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/models/movie_genre_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<Result> searchMovies;
  late Future<List<MovieGenreModel>> genres;
  final ApiServices apiServices = ApiServices();
  int? selectedGenreId;

  @override
  void initState() {
    searchMovies = apiServices.getTopRatedMovies();
    genres = apiServices.getGeners();
    super.initState();
  }

  void _updateSearchMovies(String name) {
    setState(() {
      searchMovies = apiServices.getSearchMovies(name);
    });
  }

  void _updateFilterParms(int id) {
    setState(() {
      selectedGenreId = id;
      searchMovies = apiServices.getSearchMoviesByGenres(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CupertinoSearchTextField(
                padding: const EdgeInsets.all(10.0),
                prefixIcon: const Icon(
                  CupertinoIcons.search,
                  color: Colors.grey,
                ),
                suffixIcon: const Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ),
                style: const TextStyle(color: Colors.white),
                backgroundColor: Colors.grey.withOpacity(0.3),
                onChanged: (value) {
                  _updateSearchMovies(value);
                },
              ),
            ),
            Container(
                padding: const EdgeInsets.all(0),
                child: FutureBuilder<List<MovieGenreModel>>(
                  future: genres,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Mostra um loading enquanto os dados carregam
                    } else if (snapshot.hasError) {
                      return const Text('Erro ao carregar gêneros');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('Nenhum gênero disponível');
                    } else {
                      List<MovieGenreModel> genres = snapshot.data!;
                      return DropdownButton<int>(
                        hint: const Text("Select Genre"),
                        value: selectedGenreId,
                        onChanged: (int? newValue) {
                          _updateFilterParms(newValue ?? 0);
                        },
                        items: genres.map<DropdownMenuItem<int>>((genre) {
                          return DropdownMenuItem<int>(
                            value: genre.id,
                            child: Text(genre.name),
                          );
                        }).toList(),
                      );
                    }
                  },
                )),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<Result>(
              future: searchMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erro ao carregar os filmes'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.movies.isEmpty) {
                  return const Center(
                    child: Text('Nenhum filme encontrado'),
                  );
                } else {
                  return Expanded(
                      child: ListView.builder(
                    itemCount: snapshot.data!.movies.length,
                    itemBuilder: (context, index) {
                      return MovieSearch(
                        movie: snapshot.data!.movies[index],
                      );
                    },
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
