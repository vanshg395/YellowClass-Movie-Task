import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// SCREENS
import './screens/login_screen.dart';
import './screens/tabs_screen.dart';
import './screens/loading_screen.dart';

// PROVIDERS
import './providers/auth.dart';

void main() async {
  runApp(MyApp());
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ChangeNotifierProvider.value(
      value: Auth(),
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Movie Tracker',
          theme: ThemeData(
            cardColor: Color(0xFF16222A),
            scaffoldBackgroundColor: Color(0xFFF2F2F2),
            buttonColor: Colors.white,
            dividerColor: Color(0xFFB2B2B2),
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
