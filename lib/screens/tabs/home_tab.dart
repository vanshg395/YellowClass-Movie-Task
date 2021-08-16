import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// SCREENS
import '../add_movie_screen.dart';
import '../update_movie_screen.dart';

// WIDGETS
import '../../widgets/movie_tile.dart';

// MODELS
import '../../models/movie.dart';

// PROVIDERS
import '../../providers/auth.dart';
import '../../providers/movie.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    getMyMovies();
  }

  Future<void> getMyMovies() async {
    try {
      Provider.of<MovieProvider>(context, listen: false).getAllMovies(
        Provider.of<Auth>(context, listen: false).userId!,
      );
    } catch (e) {
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 3),
          // margin: EdgeInsets.all(12),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void editMovie(Movie movie) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => UpdateMovieScreen(movie: movie),
      ),
    );
  }

  Future<void> deleteMovie(Movie movie) async {
    HapticFeedback.lightImpact();
    bool isConfirmed = false;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm'),
        content: Text('Are you sure that you want to delete ${movie.name}?'),
        actions: [
          TextButton(
            onPressed: () {
              isConfirmed = true;
              Navigator.of(context).pop();
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
        ],
      ),
    );
    if (!isConfirmed) return;
    try {
      await Provider.of<MovieProvider>(context, listen: false).deleteMovie(
        Provider.of<Auth>(context, listen: false).userId!,
        movie,
      );
    } catch (e) {
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 3),
          // margin: EdgeInsets.all(12),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
        ),
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16),
              ...Provider.of<MovieProvider>(context)
                  .movies
                  .map(
                    (movie) => MovieTile(
                      movie: movie,
                      editHandler: () => editMovie(movie),
                      deleteHandler: () => deleteMovie(movie),
                    ),
                  )
                  .toList(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AddMovieScreen(),
            ),
          );
        },
      ),
    );
  }
}
