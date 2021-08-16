import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';

// SCREENS
import './screens/login_screen.dart';
import './screens/tabs_screen.dart';
import './screens/loading_screen.dart';

// PROVIDERS
import './providers/auth.dart';
import '../providers/movie.dart';

void main() async {
  runApp(MyApp());
  await Firebase.initializeApp();
  final currentDir = await getApplicationDocumentsDirectory();
  Hive.init(currentDir.path);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: MovieProvider(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Movie Tracker',
          theme: ThemeData(
            scaffoldBackgroundColor: Color(0xFFF2F2F2),
            fontFamily: GoogleFonts.inter().fontFamily,
          ),
          home: auth.isAuth
              ? TabsScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? LoadingScreen()
                          : LoginScreen(),
                ),
        ),
      ),
    );
  }
}
