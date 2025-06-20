import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/header.dart';
import '../components/navigation_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTabletOrLarger = size.width >= 600;
    final padding = size.width * 0.05;
    final fontScale = isTabletOrLarger ? 1.2 : 1.0;
    final NavigationController navController =
        Get.find<NavigationController>();

    return Scaffold(
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        backgroundColor: const Color(0xFF1F1F39),
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: ListView(
            children: [
              ListTile(
                leading: Icon(
                  Icons.home_filled,
                  color: Colors.greenAccent,
                  size: size.width * 0.08 * fontScale,
                ),
                title: Text(
                  'Home',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.05 * fontScale,
                  ),
                ),
                onTap: () {
                  navController.onDestinationSelected(1);
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: size.height * 0.015),
              ListTile(
                leading: Icon(
                  Icons.book,
                  color: Colors.purpleAccent,
                  size: size.width * 0.08 * fontScale,
                ),
                title: Text(
                  'Courses',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.05 * fontScale,
                  ),
                ),
                onTap: () {
                  navController.onDestinationSelected(1);
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: size.height * 0.015),
              ListTile(
                leading: Icon(
                  Icons.school_rounded,
                  color: Colors.blueAccent,
                  size: size.width * 0.08 * fontScale,
                ),
                title: Text(
                  'Learn',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.05 * fontScale,
                  ),
                ),
                onTap: () {
                  navController.onDestinationSelected(2);
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: size.height * 0.015),
              ListTile(
                leading: Icon(
                  Icons.person_rounded,
                  color: Colors.orangeAccent,
                  size: size.width * 0.08 * fontScale,
                ),
                title: Text(
                  'Profile',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.05 * fontScale,
                  ),
                ),
                onTap: () {
                  navController.onDestinationSelected(4);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                // Cap width for large screens
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      const HeaderWidget(),
                      SizedBox(height: size.height * 0.03),
                      CachedNetworkImage(
                        imageUrl:
                            'https://media.tenor.com/sLkOvbmv4SgAAAAi/tkthao219-bunny.gif',
                        // Sample GIF URL
                        width: size.width * 0.5,
                        height: size.height * 0.25,
                        fit: BoxFit.contain,
                        placeholder:
                            (context, url) => const Center(
                              child:
                                  CupertinoActivityIndicator(
                                    color: Colors.white,
                                    radius: 20,
                                  ),
                            ),
                        errorWidget:
                            (context, url, error) =>
                                Container(
                                  color: Colors.grey[800],
                                  child: const Icon(
                                    Icons.error,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                      SizedBox(height: size.height * 0.04),
                      Column(
                        children: [
                          OptionButton(
                            label: "Courses",
                            icon: Icons.menu_book_sharp,
                            onPressed:
                                () => navController
                                    .onDestinationSelected(
                                      1,
                                    ),
                            screenWidth: size.width,
                            screenHeight: size.height,
                            backgroundColor: Colors
                                .greenAccent
                                .withOpacity(0.2),
                            splashColor: Colors.greenAccent
                                .withOpacity(0.4),
                          ),
                          SizedBox(
                            height: size.height * 0.015,
                          ),
                          OptionButton(
                            label: "Talk",
                            icon: Icons.chat_outlined,
                            onPressed:
                                () => navController
                                    .onDestinationSelected(
                                      3,
                                    ),
                            screenWidth: size.width,
                            screenHeight: size.height,
                            backgroundColor: Colors
                                .blueAccent
                                .withOpacity(0.2),
                            splashColor: Colors.blueAccent
                                .withOpacity(0.4),
                          ),
                          SizedBox(
                            height: size.height * 0.015,
                          ),
                          OptionButton(
                            label: "Role Play",
                            icon:
                                Icons
                                    .record_voice_over_outlined,
                            onPressed:
                                () => navController
                                    .onDestinationSelected(
                                      3,
                                    ),
                            screenWidth: size.width,
                            screenHeight: size.height,
                            backgroundColor: Colors
                                .purpleAccent
                                .withOpacity(0.2),
                            splashColor: Colors.purpleAccent
                                .withOpacity(0.4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class OptionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final double screenWidth;
  final double screenHeight;
  final Color backgroundColor;
  final Color splashColor;

  const OptionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.screenWidth,
    required this.screenHeight,
    required this.backgroundColor,
    required this.splashColor,
    super.key,
  });

  @override
  State<OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTabletOrLarger = widget.screenWidth >= 600;
    final fontScale = isTabletOrLarger ? 1.2 : 1.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: widget.screenHeight * 0.01,
      ),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(
              widget.screenWidth * 0.06,
            ),
            border: Border.all(color: Colors.white),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(
                widget.screenWidth * 0.06,
              ),
              onTap: widget.onPressed,
              onTapDown: (_) => _controller.forward(),
              onTapUp: (_) => _controller.reverse(),
              onTapCancel: () => _controller.reverse(),
              splashColor: widget.splashColor,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: widget.screenHeight * 0.015,
                  horizontal: widget.screenWidth * 0.04,
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      color: Colors.white,
                      size:
                          widget.screenWidth *
                          0.08 *
                          fontScale,
                    ),
                    SizedBox(
                      width: widget.screenWidth * 0.03,
                    ),
                    Text(
                      widget.label,
                      style: GoogleFonts.roboto(
                        fontSize:
                            widget.screenWidth *
                            0.045 *
                            fontScale,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
