import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main_navigation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _controller = PageController();
  double _scrollOffset = 0;
  int _currentPage = 0;

  final List<OnboardingData> _data = [
    OnboardingData(
      title: 'TRUST-FIRST FINANCE',
      subtitle: 'ABSOLUTE PRIVACY',
      description: 'Vault keeps your financial life entirely private. All your data is encrypted and stored locally. Never in the cloud.',
      assetPath: 'assets/images/onboarding_shield.png',
    ),
    OnboardingData(
      title: 'AUTO NODE SYNC',
      subtitle: 'ON-DEVICE NLP',
      description: 'Our local AI engine securely parses your bank notifications to track spending instantly and automatically.',
      assetPath: 'assets/images/onboarding_sync.png',
    ),
    OnboardingData(
      title: 'PROACTIVE ALERTS',
      subtitle: 'FRAUD DETECTION',
      description: 'Get immediate nudges on spending habits and anomaly alerts before they become a risk.',
      assetPath: 'assets/images/onboarding_intel.png',
    ),
    OnboardingData(
      title: 'TOTAL CONTROL',
      subtitle: 'LOCAL STORAGE',
      description: 'You dictate who, what, and where your money goes. Radical transparency in every byte.',
      assetPath: 'assets/images/onboarding_control.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _scrollOffset = _controller.page ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617), // Deepest Obsidian
      body: Stack(
        children: [
          // 1. Cosmic Abyss: Multi-layered animated background
          _buildCosmicAbyss(),
          
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // 2. Elite Branding
                _buildEliteHeader(),
                
                // 3. Immersive Content Slider
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (idx) => setState(() => _currentPage = idx),
                    itemCount: _data.length,
                    itemBuilder: (context, idx) => _buildPage(idx),
                  ),
                ),
                
                // 4. Liquid Controls
                _buildLiquidControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCosmicAbyss() {
    return Stack(
      children: [
        // Constant Deep Bloom
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [Color(0xFF0F172A), Color(0xFF020617)],
              ),
            ),
          ),
        ),
        
        // Dynamic Halo Bloom (Parallax)
        Positioned(
          left: -150 - (_scrollOffset * 40),
          top: 100,
          child: _buildGlowOrb(450, const Color(0xFF1E40AF).withOpacity(0.15)),
        ),
        
        Positioned(
          right: -100 + (_scrollOffset * 30),
          bottom: 100,
          child: _buildGlowOrb(400, const Color(0xFF38B6FF).withOpacity(0.1)),
        ),

        // Animated "Light Rays" or Particles
        ...List.generate(3, (i) => Positioned(
          top: 100.0 * i,
          left: -50.0 + (i * 100),
          child: Opacity(
            opacity: 0.05,
            child: Container(
              width: 2,
              height: 400,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.white, Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ).animate(onPlay: (c) => c.repeat()).moveY(begin: -50, end: 300, duration: (5 + i).seconds),
        )),
      ],
    );
  }

  Widget _buildGlowOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 4.seconds, curve: Curves.easeInOut);
  }

  Widget _buildEliteHeader() {
    return Column(
      children: [
        SizedBox(
          width: 44,
          height: 44,
          child: CustomPaint(painter: VaultLogoPainter(glowColor: const Color(0xFF38B6FF))),
        ).animate().scale(delay: 200.ms, duration: 600.ms, curve: Curves.easeOutBack),
        const SizedBox(height: 12),
        Text(
          'V A U L T',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 10.0,
          ),
        ).animate().fadeIn(delay: 400.ms).shimmer(duration: 1.seconds),
      ],
    );
  }

  Widget _buildPage(int index) {
    final info = _data[index];
    // Simple parallax effect calculations
    double relativeScroll = index - _scrollOffset;
    double opacity = (1 - relativeScroll.abs()).clamp(0.0, 1.0);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glassmorphic Icon Halo
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 3.seconds),
              
              Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(relativeScroll * 100, 0),
                  child: Image.asset(info.assetPath, width: 200, height: 200),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 60),
          
          Opacity(
            opacity: opacity,
            child: Column(
              children: [
                Text(
                  info.subtitle,
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFF38B6FF),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4.0,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  info.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    info.description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.4),
                      height: 1.7,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiquidControls() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_data.length, (idx) {
              bool active = _currentPage == idx;
              return AnimatedContainer(
                duration: 400.ms,
                width: active ? 24 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: active ? const Color(0xFF38B6FF) : Colors.white.withOpacity(0.1),
                ),
              );
            }),
          ),
          const SizedBox(height: 48),
          
          GestureDetector(
            onTap: () {
              if (_currentPage == _data.length - 1) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation()));
              } else {
                _controller.nextPage(duration: 800.ms, curve: Curves.easeInOutQuart);
              }
            },
            child: Container(
              width: double.infinity,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E40AF), Color(0xFF38B6FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF38B6FF).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Moving Shimmer Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white.withOpacity(0.0), Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ).animate(onPlay: (c) => c.repeat()).move(begin: const Offset(-200, -200), end: const Offset(400, 400), duration: 3.seconds),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == _data.length - 1 ? 'GO TO VAULT' : 'NEXT PHASE',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String description;
  final String assetPath;
  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.assetPath,
  });
}

class VaultLogoPainter extends CustomPainter {
  final Color glowColor;
  VaultLogoPainter({required this.glowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paintV = Paint()
      ..shader = LinearGradient(
        colors: [glowColor, glowColor.withOpacity(0.4)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final pathV = Path();
    pathV.moveTo(0, size.height * 0.1);
    pathV.lineTo(size.width * 0.2, size.height * 0.1);
    pathV.lineTo(size.width * 0.5, size.height * 0.9);
    pathV.lineTo(size.width * 0.8, size.height * 0.1);
    pathV.lineTo(size.width, size.height * 0.1);
    pathV.lineTo(size.width * 0.5, size.height);
    pathV.close();

    canvas.drawPath(pathV, paintV);

    final paintLock = Paint()
      ..color = glowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final lockRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.35),
      width: size.width * 0.25,
      height: size.height * 0.2,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(lockRect, const Radius.circular(3)), paintLock);
    
    canvas.drawArc(
      Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.25), width: size.width * 0.15, height: size.height * 0.15),
      3.14, 3.14, false, paintLock
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

