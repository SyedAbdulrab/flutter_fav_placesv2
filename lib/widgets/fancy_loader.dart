import 'package:flutter/material.dart';

class FancyLoadingIndicator extends StatefulWidget {
  final double dotSize;
  final double spacing;

  const FancyLoadingIndicator({Key? key, this.dotSize = 10.0, this.spacing = 6.0})
      : super(key: key);

  @override
  _FancyLoadingIndicatorState createState() => _FancyLoadingIndicatorState();
}

class _FancyLoadingIndicatorState extends State<FancyLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Color> _getColors() {
    return [
      const Color.fromARGB(255, 102, 6, 247), // Purple
      const Color.fromARGB(255, 108, 37, 157), // Yellow
      const Color.fromARGB(255, 107, 20, 157), // Red
      const Color.fromARGB(255, 206, 76, 189), // Green
    ];
  }

  Widget _buildDot(Color color, double rotation) {
    return Transform.rotate(
      angle: rotation,
      child: ScaleTransition(
        scale: _animation,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: SizedBox(
            width: widget.dotSize,
            height: widget.dotSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < 4; i++)
              Padding(
                padding: EdgeInsets.only(right: widget.spacing),
                child: _buildDot(
                  _getColors()[i],
                  (i * 1.0 / 4.0) * 2 * 3.14159,
                ),
              ),
          ],
        );
      },
    );
  }
}
