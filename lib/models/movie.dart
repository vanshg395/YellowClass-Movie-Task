class Movie {
  String? userId;

  String? name;

  String? directorName;

  String? posterPath;

  Movie({
    required this.userId,
    required this.name,
    required this.directorName,
    required this.posterPath,
  });

  Map<String, String> toObject() {
    return {
      'userId': this.userId!,
      'name': this.name!,
      'director': this.directorName!,
      'posterPath': this.posterPath!,
    };
  }
}
