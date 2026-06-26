import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MartipApp/helpers/storage_helper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _iconAnimController;
  late AnimationController _titleAnimController;
  late AnimationController _descAnimController;
  late Animation<double> _iconScale;
  late Animation<double> _iconRotate;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _descSlide;
  late Animation<double> _descOpacity;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.map_outlined,
      'title': 'Cari Lokasi\nTitip Terdekat',
      'description':
          'Temukan lokasi penitipan\nterdekat dengan mudah dan cepat.',
      'bgColor1': Color(0xFFFF6B6B),
      'bgColor2': Color(0xFFFFE66D),
      'iconBgColor': Color(0xFFFFF0E6),
    },
    {
      'icon': Icons.qr_code_scanner,
      'title': 'Scan QR Code\nTitipan & Ambil',
      'description': 'Scan QR Code saat titip\ndan ambil barang dengan aman.',
      'bgColor1': Color(0xFF4ECDC4),
      'bgColor2': Color(0xFF44A3E0),
      'iconBgColor': Color(0xFFE0F7F6),
    },
    {
      'icon': Icons.inventory_2_outlined,
      'title': 'Konfirmasi &\nLacak Barang',
      'description':
          'Konfirmasi titipan dan lacak\nstatus barang kamu secara real-time.',
      'bgColor1': Color(0xFF9B59B6),
      'bgColor2': Color(0xFFE74C3C),
      'iconBgColor': Color(0xFFF5E6FF),
    },
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _iconAnimController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _titleAnimController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _descAnimController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _iconScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _iconAnimController, curve: Curves.elasticOut),
    );

    _iconRotate = Tween<double>(begin: -0.5, end: 0).animate(
      CurvedAnimation(parent: _iconAnimController, curve: Curves.easeOut),
    );

    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _titleAnimController, curve: Curves.easeOut),
        );

    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _titleAnimController, curve: Curves.easeOut),
    );

    _descSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _descAnimController, curve: Curves.easeOut),
        );

    _descOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _descAnimController, curve: Curves.easeOut),
    );
  }

  void _startAnimations() {
    _iconAnimController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _titleAnimController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _descAnimController.forward();
    });
  }

  void _resetAnimations() {
    _iconAnimController.reset();
    _titleAnimController.reset();
    _descAnimController.reset();
    _startAnimations();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _iconAnimController.dispose();
    _titleAnimController.dispose();
    _descAnimController.dispose();
    super.dispose();
  }

  void _skip() async {
    await StorageHelper.setOnboardingShown(true);
    Get.offAllNamed('/login');
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    } else {
      _skip();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Gradient Background
          AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 0;
              if (_pageController.positions.isNotEmpty) {
                value = (_pageController.page ?? 0) % 1;
              }

              final currentColors = _pages[_currentPage];
              final nextColors = _pages[(_currentPage + 1) % _pages.length];

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(
                            currentColors['bgColor1'],
                            nextColors['bgColor1'],
                            value,
                          ) ??
                          currentColors['bgColor1'],
                      Color.lerp(
                            currentColors['bgColor2'],
                            nextColors['bgColor2'],
                            value,
                          ) ??
                          currentColors['bgColor2'],
                    ],
                  ),
                ),
              );
            },
          ),

          // Animated Background Shapes
          Positioned(
            top: -100,
            right: -100,
            child: AnimatedBuilder(
              animation: _pageController,
              builder: (context, _) {
                return Transform.rotate(
                  angle: (_pageController.page ?? 0) * 0.5,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            bottom: -80,
            left: -80,
            child: AnimatedBuilder(
              animation: _pageController,
              builder: (context, _) {
                return Transform.rotate(
                  angle: -(_pageController.page ?? 0) * 0.3,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                );
              },
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header with Skip Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Progress Text
                      Text(
                        '${_currentPage + 1}/${_pages.length}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      // Skip Button
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _skip,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Skip',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Page View Content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                      _resetAnimations();
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32.0,
                              vertical: 32.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Animated Icon Container
                                ScaleTransition(
                                  scale: _iconScale,
                                  child: RotationTransition(
                                    turns: _iconRotate,
                                    child: MouseRegion(
                                      onEnter: (_) {
                                        setState(() {});
                                      },
                                      child: AnimatedBuilder(
                                        animation: _pageController,
                                        builder: (context, _) {
                                          final rotateValue =
                                              (_pageController.page ?? 0) * 0.2;
                                          return Transform.rotate(
                                            angle: rotateValue,
                                            child: Container(
                                              width: 180,
                                              height: 180,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: RadialGradient(
                                                  colors: [
                                                    _pages[index]['iconBgColor'],
                                                    _pages[index]['iconBgColor']
                                                        .withOpacity(0.5),
                                                  ],
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.15),
                                                    blurRadius: 30,
                                                    offset: const Offset(0, 10),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  _pages[index]['icon'],
                                                  size: 90,
                                                  color:
                                                      _pages[index]['bgColor1'],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 60),

                                // Animated Title
                                SlideTransition(
                                  position: _titleSlide,
                                  child: FadeTransition(
                                    opacity: _titleOpacity,
                                    child: Text(
                                      _pages[index]['title'],
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            height: 1.3,
                                            fontSize: 32,
                                          ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Animated Description
                                SlideTransition(
                                  position: _descSlide,
                                  child: FadeTransition(
                                    opacity: _descOpacity,
                                    child: Text(
                                      _pages[index]['description'],
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontSize: 16,
                                            height: 1.6,
                                            color: Colors.white.withOpacity(
                                              0.85,
                                            ),
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Section - Dots & Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 40.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Animated Dots Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (indexDot) => GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                indexDot,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: AnimatedBuilder(
                              animation: _pageController,
                              builder: (context, child) {
                                final isActive = _currentPage == indexDot;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  width: isActive
                                      ? 32
                                      : 10, // Expanded when active
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: isActive
                                        ? [
                                            BoxShadow(
                                              color: Colors.white.withOpacity(
                                                0.5,
                                              ),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                            ),
                                          ]
                                        : [],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Animated Next Button with Hover Effect
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _next,
                          child: Container(
                            height: 58,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.9),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style:
                                    Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      color: _pages[_currentPage]['bgColor1'],
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ) ??
                                    const TextStyle(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _currentPage == _pages.length - 1
                                          ? 'Mulai Sekarang'
                                          : 'Lanjut',
                                    ),
                                    const SizedBox(width: 8),
                                    AnimatedBuilder(
                                      animation: _pageController,
                                      builder: (context, _) {
                                        return Transform.translate(
                                          offset: Offset(
                                            ((_pageController.page ?? 0) % 1) *
                                                5,
                                            0,
                                          ),
                                          child: const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 20,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
