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
      description: 'Vault keeps your financial life entirely\nprivate. All your data is encrypted,\nstored only on your device, and never\nin the cloud. Total privacy,\nabsolute security.',
      assetPath: 'assets/images/onboarding_shield.png',
    ),
    OnboardingData(
      title: 'Auto Transaction Sync',
      description: 'We securely parse your bank SMS\nand notifications using on-device AI\nto track your spending automatically.',
      assetPath: 'assets/images/onboarding_sync.png',
    ),
    OnboardingData(
      title: 'Proactive Intelligence',
      description: 'Get nudges on spending habits\nand fraud alerts long before\nthey become a problem.',
      assetPath: 'assets/images/onboarding_intel.png',
    ),
    OnboardingData(
      title: 'Full Control',
      description: 'You dictate who, what, and where\nyour money goes. Say goodbye to\nhidden fees and surprises.',
      assetPath: 'assets/images/onboarding_control.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030712), // Deeper cosmic black
      body: Stack(
        children: [
          // 1. Premium Background Layer
          _buildBackgroundLayers(context),
          
          SafeArea(
            child: Column(
              children: [
                // 2. High-End Branding
                _buildHeader(),
                
                // 3. Immersive Content Slider
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (idx) => setState(() => _currentPage = idx),
                    itemCount: _data.length,
                    itemBuilder: (context, idx) => _buildPage(_data[idx]),
                  ),
                ),
                
                // 4. Strategic Call to Action
                _buildBottomControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundLayers(BuildContext context) {
    return Stack(
      children: [
        // Top-Right Cyber Glow
        Positioned(
          top: -150,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF1E40AF).withOpacity(0.4),
                  const Color(0xFF1E40AF).withOpacity(0.0),
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(begin: -20, end: 20, duration: 3.seconds),
        ),
        
        // Bottom-Left Deep Shadow
        Positioned(
          bottom: -200,
          left: -150,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF0F172A).withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CustomPaint(
              painter: VaultLogoPainter(),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'V A U L T',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 6.0,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.2, end: 0),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minimalist Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_data.length, (idx) => _buildDot(idx)),
          ),
          const SizedBox(height: 48),
          
          // Elevated Glass Action Button
          GestureDetector(
            onTap: () {
              if (_currentPage == _data.length - 1) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation()));
              } else {
                _controller.nextPage(duration: 500.ms, curve: Curves.easeOutQuart);
              }
            },
            child: Container(
              width: double.infinity,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 2,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white.withOpacity(0.0), Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.0)],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentPage == _data.length - 1 ? 'BEGIN JOURNEY' : 'CONTINUE',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1,1), end: const Offset(1.02, 1.02), duration: 2.seconds, curve: Curves.easeInOut),
        ],
      ),
    );
  }


  Widget _buildDot(int index) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: 300.ms,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: isActive ? 32 : 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : const Color(0xFF384561),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildPage(OnboardingData info) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 3D Generated High-Quality Icon
          SizedBox(
            width: 250,
            height: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(125), // Optional clipping if generated image has corners
              child: Image.asset(
                info.assetPath,
                fit: BoxFit.cover,
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .moveY(begin: -5, end: 5, duration: 2.seconds, curve: Curves.easeInOutSine)
           .fadeIn(duration: 600.ms),
          
          const SizedBox(height: 54),
          
          Text(
            info.title,
            style: const TextStyle(
              fontSize: 27, 
              fontWeight: FontWeight.w800, 
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms).move(begin: const Offset(0, 20), end: Offset.zero),
          
          const SizedBox(height: 18),
          
          Text(
            info.description,
            style: const TextStyle(
              fontSize: 14, 
              color: Color(0xFF94A3B8), // slateish grey
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
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
  final String assetPath;
  OnboardingData({
    required this.title, 
    required this.description, 
    required this.assetPath,
  });
}

// Custom Painter to draw the V + internal lock Vault Logo accurately
class VaultLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // V geometry
    final paintV = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF639CFA), Color(0xFF2C5FA7)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final pathV = Path();
    pathV.moveTo(0, 0);
    pathV.lineTo(size.width * 0.35, 0);
    pathV.lineTo(size.width * 0.5, size.height * 0.8);
    pathV.lineTo(size.width * 0.65, 0);
    pathV.lineTo(size.width, 0);
    pathV.lineTo(size.width * 0.5, size.height);
    pathV.close();

    canvas.drawPath(pathV, paintV);

    // Lock body
    final paintLockBody = Paint()
      ..color = const Color(0xFF00E5FF)
      ..style = PaintingStyle.fill;

    final lockRect = Rect.fromLTWH(size.width * 0.35, size.height * 0.55, size.width * 0.3, size.height * 0.35);
    canvas.drawRRect(RRect.fromRectAndRadius(lockRect, const Radius.circular(3)), paintLockBody);

    // Lock shackle
    final paintLockShackle = Paint()
      ..color = const Color(0xFF00E5FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawArc(
      Rect.fromLTWH(size.width * 0.4, size.height * 0.4, size.width * 0.2, size.height * 0.3),
      3.14159,
      3.14159,
      false,
      paintLockShackle,
    );
    
    // Keyhole
    final paintKeyhole = Paint()
      ..color = const Color(0xFF08122D)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.68), 2, paintKeyhole);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.48, size.height * 0.68, size.width * 0.04, size.height * 0.1), paintKeyhole);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
