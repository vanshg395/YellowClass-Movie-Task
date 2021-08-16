import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// MODEL
import '../models/movie.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];

  Future<void> addMovie(Movie movie) async {
    try {
      var box = await Hive.openBox('movies');
      _movies.add(movie);
      await box.put(
          movie.userId, _movies.map((movie) => movie.toObject()).toList());
      notifyListeners();
      box.close();
    } catch (e) {
      throw e;
    }
  }

  Future<void> getAllMovies(String userId) async {
    try {
      var box = await Hive.openBox('movies');
      final extractedMovies = box.get(userId);
      print(extractedMovies);
      if (extractedMovies != null) {
        _movies = (extractedMovies as List<dynamic>)
            .map(
              (movie) => Movie(
                userId: movie['userId'],
                name: movie['name'],
                directorName: movie['director'],
                posterPath: movie['posterPath'],
              ),
            )
            .toList();
      }
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
