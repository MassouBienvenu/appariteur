import 'package:appariteur/controllers/loginController/childlogin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; // Ensure Google Fonts is imported
import 'package:shared_preferences/shared_preferences.dart';
class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageContent() {
    return [
      _buildPage(
        imagePath: 'assets/images/splash 1.png',
        text: 'Devenez rapidement et facilement surveillant!'
            ' Et gagnez de l\'argent en travaillant avec nous!',
      ),
      _buildPage(
        imagePath: 'assets/images/splash 2.png',
        text: 'Suivez vos horaires de travail,'
            ' Et décidez de quand vous travaillez!',
        showButton: true,
      ),
    ];
  }

  Future<void> _setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
  }

  void _onFinish() async {
    await _setOnboardingSeen();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }


  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: isCurrentPage ? 10.0 : 8.0,
      width: isCurrentPage ? 10.0 : 8.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildPage({required String imagePath, required String text, bool showButton = false}) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath),
          SizedBox(height: 20),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(fontSize: 18),
          ),
          if (showButton) ...[
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _onFinish();
                Navigator.push(

                    context, MaterialPageRoute(builder: (context) => SignInScreen()));;
              },
              child: Text('Commencer',style: TextStyle(color: Colors.white), ),
              style: ElevatedButton.styleFrom(primary: Colors.blue),
            ),
          ]
        ],
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: _buildPageContent(),
          ),
          Positioned(
            bottom: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                _buildPageContent().length,
                    (int index) => _buildPageIndicator(index == _currentPage),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
