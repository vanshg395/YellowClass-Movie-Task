import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// MODEL
import '../models/movie.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];

  List<Movie> get movies => [..._movies];

  Future<void> addMovie(String userId, Movie movie) async {
    try {
      var box = await Hive.openBox('movies');
      _movies.add(movie);
      await box.put(userId, _movies.map((movie) => movie.toObject()).toList());
      await box.close();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> getAllMovies(String userId) async {
    try {
      var box = await Hive.openBox('movies');
      final extractedMovies = box.get(userId);
      if (extractedMovies != null) {
        _movies = (extractedMovies as List<dynamic>)
            .map(
              (movie) => Movie(
                id: movie['id'],
                name: movie['name'],
                directorName: movie['director'],
                genre: movie['genre'],
                posterPath: movie['posterPath'],
              ),
            )
            .toList();
      }
      await box.close();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateMovie(String userId, Movie movie) async {
    try {
      var box = await Hive.openBox('movies');
      _movies[_movies.indexWhere(
          (retrievedMovie) => retrievedMovie.id == movie.id)] = movie;
      await box.put(userId, _movies.map((movie) => movie.toObject()).toList());
      await box.close();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteMovie(String userId, Movie movie) async {
    try {
      var box = await Hive.openBox('movies');
      _movies.remove(movie);
      await box.put(userId, _movies.map((movie) => movie.toObject()).toList());
      await box.close();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void resetMovies() {
    _movies = [];
  }
}
