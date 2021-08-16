import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          body: SafeArea(
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 36),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    child: Text(
                      'Movie Tracker',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 36),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
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
                      bgColor: Colors.white.withOpacity(0.7),
                      borderColor: Color(0xFFB2B2B2),
                      isBlur: true,
                      onTap: signInWithGoogle,
                    ),
                  ),
                  SizedBox(height: 36),
                ],
              ),
            ),
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
