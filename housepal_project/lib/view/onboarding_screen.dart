import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToNextPage() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: 3,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return OnboardingPage(
            pageIndex: index,
            currentPage: _currentPage,
            title: index == 0
                ? 'Welcome to HousePal !'
                : index == 1
                    ? 'Browse Available Helpers'
                    : 'Enjoy\nProfessional Help !',
            description: index == 0
                ? 'Find trusted house helpers and get your work done quickly.'
                : index == 1
                    ? 'Choose from a variety of services: cleaning, babysitting, and more.'
                    : 'Relax while our trusted helpers take care of everything for you.',
            buttonText: index == 2 ? 'Get Started' : 'Next',
            backgroundColor: const Color(0xFFFFF5F5),
            onPressed: _goToNextPage,
            onSkip: _skipOnboarding,
            imagePath: index == 0
                ? 'assets/images/Curious-bro.png'
                : index == 1
                    ? 'assets/images/Booking2.png'
                    : 'assets/images/relax.png',
            isLastPage: index == 2,
          );
        },
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final int pageIndex;
  final int currentPage;
  final String title;
  final String description;
  final String buttonText;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final VoidCallback onSkip;
  final String imagePath;
  final bool isLastPage;

  const OnboardingPage({
    super.key,
    required this.pageIndex,
    required this.currentPage,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.backgroundColor,
    required this.onPressed,
    required this.onSkip,
    required this.imagePath,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate scale and opacity based on the page index
    final double scale = currentPage == pageIndex ? 1.0 : 0.9;
    final double opacity = currentPage == pageIndex ? 1.0 : 0.5;

    return Stack(
      children: [
        Container(color: backgroundColor),
        const Positioned(
          top: 70,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'HOUSEPAL',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Positioned(
          top: 150,
          left: 0,
          right: 0,
          child: Center(
            child: Transform.scale(
              scale: scale,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  imagePath,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 220,
          left: 0,
          right: 0,
          child: Center(
            child: Opacity(
              opacity: opacity,
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 150,
          left: 0,
          right: 0,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Opacity(
                opacity: opacity,
                child: Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    color: Color.fromARGB(255, 91, 90, 90),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? const Color(0xFF459D7A)
                        : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (!isLastPage)
          Positioned(
            bottom: 20,
            left: 20,
            child: GestureDetector(
              onTap: onSkip,
              child: const Text(
                'Skip',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF459D7A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 20,
          right: 20,
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF459D7A),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
