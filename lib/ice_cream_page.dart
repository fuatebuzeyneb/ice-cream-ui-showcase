import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ice_cream_data.dart';

class IceCreamPage extends StatefulWidget {
  const IceCreamPage({super.key});

  @override
  State<IceCreamPage> createState() => _IceCreamPageState();
}

class _IceCreamPageState extends State<IceCreamPage> {
  final PageController _controller = PageController();
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final page =
        _controller.hasClients && _controller.position.haveDimensions
            ? (_controller.page ?? 0.0)
            : 0.0;

    final titleIndex = page.round().clamp(0, iceCreamList.length - 1);

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: iceCreamList.length,
            scrollDirection: Axis.horizontal,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, index) {
              final delta = (index - page).clamp(-1.0, 1.0);

              if (delta.abs() > 1.0) return const SizedBox.shrink();

              final isCurrent = delta <= 0 && delta > -1.0;
              final turn = (delta.abs()).clamp(0.0, 1.0);
              final angle = -turn * math.pi;
              final nextIndex = (index + 1).clamp(0, iceCreamList.length - 1);

              return Stack(
                children: [
                  Positioned.fill(
                    child: _FullScreenIcePage(
                      item: iceCreamList[nextIndex],
                      overlayItem: iceCreamList[index],
                    ),
                  ),
                  if (isCurrent)
                    Positioned.fill(
                      child: _BookTurn(
                        angle: angle,
                        child: _FullScreenIcePage(
                          item: iceCreamList[index],
                          overlayItem: iceCreamList[index],
                        ),
                      ),
                    ),
                  if (!isCurrent)
                    Positioned.fill(
                      child: _FullScreenIcePage(
                        item: iceCreamList[index],
                        overlayItem: iceCreamList[index],
                      ),
                    ),
                ],
              );
            },
          ),
          Positioned(
            top: 110,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder:
                    (child, anim) =>
                        FadeTransition(opacity: anim, child: child),
                child: Text(
                  iceCreamList[titleIndex].name,
                  key: ValueKey(iceCreamList[titleIndex].name),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bebasNeue(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookTurn extends StatelessWidget {
  final double angle;
  final Widget child;

  const _BookTurn({required this.angle, required this.child});

  @override
  Widget build(BuildContext context) {
    final shadowOpacity = (angle.abs() / math.pi * 0.45).clamp(0.0, 0.45);

    return Stack(
      children: [
        Transform(
          alignment: Alignment.centerRight,
          transform:
              Matrix4.identity()
                ..setEntry(3, 2, 0.0014)
                ..rotateY(angle),
          child: ClipRect(child: child),
        ),
        IgnorePointer(
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Colors.black.withOpacity(shadowOpacity),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FullScreenIcePage extends StatelessWidget {
  final IceCream item;
  final IceCream overlayItem;

  const _FullScreenIcePage({required this.item, required this.overlayItem});

  @override
  Widget build(BuildContext context) {
    final bg = item.color;
    final size = MediaQuery.of(context).size;

    return ClipRect(
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.2),
                  radius: 1.35,
                  colors: [
                    Colors.white,
                    Color.lerp(bg, Colors.white, 0.35)!,
                    bg,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: _OverlayLayer(overlayImage: overlayItem.overlayImage),
          ),
          Center(
            child: Image.asset(
              item.image,
              width: size.width * 0.8,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverlayLayer extends StatelessWidget {
  final String overlayImage;
  const _OverlayLayer({required this.overlayImage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -20,
          left: -30,
          child: _blurredImage(overlayImage, 120, sigma: 3),
        ),
        Positioned(
          top: 70,
          right: 40,
          child: Transform.rotate(
            angle: 0.6,
            child: _blurredImage(overlayImage, 70, sigma: 5),
          ),
        ),
        Positioned(
          top: 220,
          left: 40,
          child: Opacity(
            opacity: 0.85,
            child: Image.asset(overlayImage, width: 70),
          ),
        ),
        Positioned(
          right: -80,
          bottom: 140,
          child: Transform.rotate(
            angle: 0.6,
            child: _blurredImage(overlayImage, 180, sigma: 4),
          ),
        ),
        Positioned(
          left: -70,
          bottom: -50,
          child: Transform.rotate(
            angle: 0.35,
            child: _blurredImage(overlayImage, 180, sigma: 4),
          ),
        ),
      ],
    );
  }

  static Widget _blurredImage(String asset, double width, {double sigma = 4}) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: Opacity(opacity: 0.85, child: Image.asset(asset, width: width)),
    );
  }
}
