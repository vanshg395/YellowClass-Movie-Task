import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// SCREENS
import './add_movie_screen.dart';
import './update_movie_screen.dart';
import './profile_screen.dart';

// WIDGETS
import '../widgets/movie_tile.dart';

// MODELS
import '../models/movie.dart';

// PROVIDERS
import '../providers/auth.dart';
import '../providers/movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController hideFabAnimation;
  String genre = 'All';

  @override
  void initState() {
    super.initState();
    getMyMovies();
    hideFabAnimation = AnimationController(
        vsync: this, duration: kThemeAnimationDuration, value: 1);
  }

  @override
  void dispose() {
    hideFabAnimation.dispose();
    super.dispose();
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

  bool handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              hideFabAnimation.forward();
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              hideFabAnimation.reverse();
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Progress',
              height: 0.8,
            ),
            children: [
              TextSpan(
                text: 'Movie\n',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              TextSpan(
                text: 'Tracker',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ProfileScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.account_circle,
              size: 34,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF000000).withOpacity(0.3),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Movies Watched',
                  ),
                  Spacer(),
                ],
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: handleScrollNotification,
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: hideFabAnimation,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => AddMovieScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
