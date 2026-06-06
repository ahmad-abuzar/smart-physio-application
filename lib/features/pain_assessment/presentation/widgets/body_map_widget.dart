import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/pain_assessment_entity.dart';

class BodyMapWidget extends StatelessWidget {
  final Set<BodyPart> selectedParts;
  final ValueChanged<BodyPart> onPartTapped;

  const BodyMapWidget({
    super.key,
    required this.selectedParts,
    required this.onPartTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 480,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Body outline
          CustomPaint(
            size: const Size(280, 480),
            painter: _BodyOutlinePainter(),
          ),
          // Tappable body parts
          _buildBodyPart(
            bodyPart: BodyPart.shoulder,
            top: 100,
            left: 55,
            width: 170,
            height: 45,
          ),
          _buildBodyPart(
            bodyPart: BodyPart.arm,
            top: 145,
            left: 35,
            width: 50,
            height: 70,
          ),
          _buildBodyPart(
            bodyPart: BodyPart.arm,
            top: 145,
            left: 195,
            width: 50,
            height: 70,
            isRight: true,
          ),
          _buildBodyPart(
            bodyPart: BodyPart.forearm,
            top: 215,
            left: 20,
            width: 45,
            height: 65,
          ),
          _buildBodyPart(
            bodyPart: BodyPart.forearm,
            top: 215,
            left: 215,
            width: 45,
            height: 65,
            isRight: true,
          ),
          _buildBodyPart(
            bodyPart: BodyPart.thigh,
            top: 270,
            left: 80,
            width: 120,
            height: 80,
          ),
          _buildBodyPart(
            bodyPart: BodyPart.leg,
            top: 355,
            left: 80,
            width: 120,
            height: 90,
          ),
        ],
      ),
    );
  }

  Widget _buildBodyPart({
    required BodyPart bodyPart,
    required double top,
    required double left,
    required double width,
    required double height,
    bool isRight = false,
  }) {
    final isSelected = selectedParts.contains(bodyPart);
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () => onPartTapped(bodyPart),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.bodyPartActive.withValues(alpha: 0.4)
                : AppColors.bodyPartInactive.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.bodyPartActive
                  : AppColors.bodyPartInactive.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              bodyPart.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? AppColors.bodyPartActive
                    : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _BodyOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;

    // Head
    canvas.drawCircle(Offset(cx, 45), 30, paint);
    canvas.drawCircle(Offset(cx, 45), 30, fillPaint);

    // Neck
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, 80), width: 20, height: 15),
      paint,
    );

    // Torso
    final torsoPath = Path()
      ..moveTo(cx - 60, 90)
      ..lineTo(cx - 55, 265)
      ..lineTo(cx + 55, 265)
      ..lineTo(cx + 60, 90)
      ..close();
    canvas.drawPath(torsoPath, paint);
    canvas.drawPath(torsoPath, fillPaint);

    // Left arm
    final leftArmPath = Path()
      ..moveTo(cx - 60, 100)
      ..lineTo(cx - 80, 150)
      ..lineTo(cx - 85, 220)
      ..lineTo(cx - 95, 280)
      ..lineTo(cx - 80, 282)
      ..lineTo(cx - 70, 220)
      ..lineTo(cx - 65, 150)
      ..lineTo(cx - 60, 100);
    canvas.drawPath(leftArmPath, paint);

    // Right arm
    final rightArmPath = Path()
      ..moveTo(cx + 60, 100)
      ..lineTo(cx + 80, 150)
      ..lineTo(cx + 85, 220)
      ..lineTo(cx + 95, 280)
      ..lineTo(cx + 80, 282)
      ..lineTo(cx + 70, 220)
      ..lineTo(cx + 65, 150)
      ..lineTo(cx + 60, 100);
    canvas.drawPath(rightArmPath, paint);

    // Left leg
    final leftLegPath = Path()
      ..moveTo(cx - 45, 265)
      ..lineTo(cx - 50, 355)
      ..lineTo(cx - 55, 445)
      ..lineTo(cx - 35, 445)
      ..lineTo(cx - 30, 355)
      ..lineTo(cx - 5, 265);
    canvas.drawPath(leftLegPath, paint);

    // Right leg
    final rightLegPath = Path()
      ..moveTo(cx + 5, 265)
      ..lineTo(cx + 30, 355)
      ..lineTo(cx + 35, 445)
      ..lineTo(cx + 55, 445)
      ..lineTo(cx + 50, 355)
      ..lineTo(cx + 45, 265);
    canvas.drawPath(rightLegPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
