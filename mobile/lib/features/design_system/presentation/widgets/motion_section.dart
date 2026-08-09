import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_motion.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';
import '../../../../shared/widgets/cards/app_card.dart';

class MotionSection extends StatefulWidget {
  const MotionSection({super.key});

  @override
  State<MotionSection> createState() => _MotionSectionState();
}

class _MotionSectionState extends State<MotionSection> {
  bool _toggled = false;

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      title: 'Motion System',
      subtitle: 'Fast (150ms), Normal (250ms), and Emphasis (350ms) transitions',
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          children: [
            SecondaryButton(
              label: _toggled ? 'Reset Animation' : 'Trigger Motion Test',
              onPressed: () {
                setState(() {
                  _toggled = !_toggled;
                });
              },
            ),
            const SizedBox(height: AppDimensions.space16),
            _buildBar('Fast (150ms)', AppMotion.fast, _toggled ? 220.0 : 60.0, AppColors.primary),
            const SizedBox(height: AppDimensions.space12),
            _buildBar('Normal (250ms)', AppMotion.normal, _toggled ? 220.0 : 60.0, AppColors.info),
            const SizedBox(height: AppDimensions.space12),
            _buildBar('Emphasis (350ms)', AppMotion.emphasis, _toggled ? 220.0 : 60.0, AppColors.aiAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(String label, Duration duration, double width, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(label, style: AppTypography.labelMedium),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: duration,
              curve: AppMotion.defaultCurve,
              width: width,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                borderRadius: AppDimensions.borderSM,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
