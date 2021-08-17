import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// WIDGETS
import '../widgets/social_button.dart';

// PROVIDERS
import '../providers/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).signin();
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
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/img/bg.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SafeArea(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 36),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Progress',
                              height: 0.6,
                            ),
                            children: [
                              TextSpan(
                                text: 'Movie\n',
                                style: TextStyle(
                                  fontSize: 56,
                                ),
                              ),
                              TextSpan(
                                text: 'Tracker',
                                style: TextStyle(
                                  fontSize: 37,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Container(
                        width: 300,
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Now keep track of your favourite movies hassle-free.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: SocialButton(
                          text: 'SIGN IN WITH GOOGLE',
                          iconName: 'google',
                          textColor: Color(0xFF16222A),
                          bgColor: Colors.white,
                          borderColor: Colors.white,
                          isBlur: true,
                          onTap: signInWithGoogle,
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isLoading) ...[
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.6),
          ),
          Center(
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
