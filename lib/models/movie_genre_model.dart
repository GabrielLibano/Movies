class MovieGenreModel {
  final int id;
  final String name;

  MovieGenreModel({required this.id, required this.name});

  factory MovieGenreModel.fromJson(Map<String, dynamic> json) {
    return MovieGenreModel(
      id: json['id'],
      name: json['name'],
    );
  }
  
}

