class Movie {
  String? id;
  String? name;
  String? directorName;
  String? genre;
  String? posterPath;

  Movie({
    required this.id,
    required this.name,
    required this.directorName,
    required this.genre,
    required this.posterPath,
  });

  Map<String, String> toObject() {
    return {
      'id': this.id!,
      'name': this.name!,
      'director': this.directorName!,
      'genre': this.genre!,
      'posterPath': this.posterPath!,
    };
  }
}
