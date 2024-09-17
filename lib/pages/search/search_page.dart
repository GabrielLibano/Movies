import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/pages/search/widgets/movie_search.dart';
import 'package:movie_app/services/api_services.dart';
import 'package:movie_app/models/movie_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<Result> searchMovies;
  String filmName = '';
  final ApiServices apiServices = ApiServices();

  @override
  void initState() {
    searchMovies = apiServices.getTopRatedMovies();
    super.initState();
  }

  void _updateSearchMovies(String name) {
    setState(() {
      searchMovies = apiServices.getSearchMovies(filmName);
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
                } else if (!snapshot.hasData ||
                    snapshot.data!.movies.isEmpty) {
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
