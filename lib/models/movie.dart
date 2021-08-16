class Movie {
  String? id;
  String? name;
  String? directorName;
  String? posterPath;

  Movie({
    required this.id,
    required this.name,
    required this.directorName,
    required this.posterPath,
  });

  Map<String, String> toObject() {
    return {
      'id': this.id!,
      'name': this.name!,
      'director': this.directorName!,
      'posterPath': this.posterPath!,
    };
  }
}
