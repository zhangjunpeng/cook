import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class PhysicPage extends StatefulWidget {
  const PhysicPage({Key? key}) : super(key: key);

  @override
  State<PhysicPage> createState() => _PhysicPageState();
}

class _PhysicPageState extends State<PhysicPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  Alignment _alignment = Alignment.center;

  late Animation<Alignment> _animation;
  void _runAnimation(Offset pixelsPerScond, Size size) {
    _animation = _animationController
        .drive(AlignmentTween(begin: _alignment, end: Alignment.center));
    //弹簧效果
    final unitsPerScondX = pixelsPerScond.dx / size.width;
    final unitsPerScondy = pixelsPerScond.dy / size.height;
    final unitsPerScond = Offset(unitsPerScondX, unitsPerScondy);
    final unitsVelocity = unitsPerScond.distance;
    const spring = SpringDescription(mass: 30, stiffness: 1, damping: 1);
    final simulation = SpringSimulation(spring, 0, 1, -unitsVelocity);
    _animationController.animateWith(simulation);
    // _animationController.reset();
    // _animationController.forward();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animationController.addListener(() {
      setState(() {
        _alignment = _animation.value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      height: 500,
      width: 500,
      child: GestureDetector(
        onPanDown: (details) {
          _animationController.stop();
        },
        onPanUpdate: (details) {
          setState(() {
            _alignment += Alignment(details.delta.dx / (size.width / 2),
                details.delta.dy / (size.height / 2));
          });
        },
        onPanEnd: (details) {
          _runAnimation(details.velocity.pixelsPerSecond, size);
        },
        child: Align(
          alignment: _alignment,
          child: const FlutterLogo(
            size: 128,
          ),
        ),
      ),
    );
  }
}
