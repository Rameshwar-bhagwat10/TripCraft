import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';

/// Reusable Visual Timeline Connector Node.
class TimelineNode extends StatelessWidget {
  final Color tintColor;
  final bool isFirst;
  final bool isLast;

  const TimelineNode({
    super.key,
    required this.tintColor,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isFirst)
          Container(
            width: 2,
            height: 16,
            color: AppColors.border,
          ),
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: tintColor, width: 3),
            boxShadow: [
              BoxShadow(
                color: tintColor.withValues(alpha: 0.2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        if (!isLast)
          Expanded(
            child: Container(
              width: 2,
              color: AppColors.border,
            ),
          ),
      ],
    );
  }
}
