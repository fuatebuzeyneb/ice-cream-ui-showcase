import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ice_cream_ui_showcase/books_data.dart';
import 'ice_cream_page.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          const SizedBox(height: 90),
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Swipe to explore',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: SizedBox(
                height: 460,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.72),
                  itemCount: BookItem.books.length,
                  itemBuilder: (context, index) {
                    return _AnimatedBookCard(
                      item: BookItem.books[index],
                      index: index,
                      onTap: () {
                        if (BookItem.books[index].enabled) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const IceCreamPage(),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedBookCard extends StatefulWidget {
  final BookItem item;
  final int index;
  final VoidCallback onTap;

  const _AnimatedBookCard({
    required this.item,
    required this.index,
    required this.onTap,
  });

  @override
  State<_AnimatedBookCard> createState() => _AnimatedBookCardState();
}

class _AnimatedBookCardState extends State<_AnimatedBookCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeCtrl;
  late final Animation<double> _shake;

  bool _isShaking = false;

  @override
  void initState() {
    super.initState();

    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _shake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 8, end: -8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 8, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (!widget.item.enabled) return;
    if (_isShaking) return;

    setState(() => _isShaking = true);

    await _shakeCtrl.forward(from: 0);

    if (!mounted) return;
    setState(() => _isShaking = false);

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, t, child) {
        final tilt = math.sin(t * math.pi) * 0.05;

        return Transform.rotate(
          angle: tilt,
          child: Transform.scale(
            scale: widget.item.enabled ? 1.0 : 0.96,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _shakeCtrl,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shake.value, 0),
              child: child,
            );
          },
          child: AbsorbPointer(
            absorbing: _isShaking,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
              decoration: BoxDecoration(
                color: widget.item.color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                    color: Colors.black.withOpacity(0.18),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.12),
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 24,
                    left: 24,
                    right: 24,
                    child: Image.asset(
                      widget.item.image,
                      height: 160,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Text(
                      widget.item.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.85),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 14,
                    left: 0,
                    right: 0,
                    child: Text(
                      widget.item.enabled ? 'Tap to Open' : 'Coming Soon',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.45),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
