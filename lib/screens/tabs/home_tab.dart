import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// SCREENS
import '../add_movie_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
        ),
      ),
      body: Text('Home'),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
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
