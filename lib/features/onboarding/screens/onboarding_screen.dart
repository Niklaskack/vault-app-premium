import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../main_navigation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _data = [
    OnboardingData(
      title: 'Trust-First Finance',
      description: 'Your financial data never leaves your device. No cloud, no tracking, total privacy.',
      icon: Icons.shield_outlined,
      color: Colors.indigo,
    ),
    OnboardingData(
      title: 'Auto Transaction Sync',
      description: 'We securely parse your bank SMS and notifications using on-device AI to track spending.',
      icon: Icons.sync,
      color: Colors.teal,
    ),
    OnboardingData(
      title: 'Proactive Intelligence',
      description: 'Get nudges on spending habits and fraud alerts before they become a problem.',
      icon: Icons.auto_awesome,
      color: Colors.amber.shade800,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemCount: _data.length,
            itemBuilder: (context, idx) => _buildPage(_data[idx]),
          ),
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(_data.length, (idx) => _buildDot(idx)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _data.length - 1) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation()));
                    } else {
                      _controller.nextPage(duration: 400.ms, curve: Curves.easeInOut);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(_currentPage == _data.length - 1 ? 'Start Saving' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: 300.ms,
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildPage(OnboardingData info) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(info.icon, size: 120, color: info.color).animate().fadeIn(duration: 600.ms).move(begin: const Offset(0, 10), end: Offset.zero, curve: Curves.easeOutBack),
          const SizedBox(height: 48),
          Text(
            info.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms).move(begin: const Offset(0, 20), end: Offset.zero),
          const SizedBox(height: 16),
          Text(
            info.description,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 500.ms).move(begin: const Offset(0, 20), end: Offset.zero),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  OnboardingData({required this.title, required this.description, required this.icon, required this.color});
}
