import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_motion.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/steps/activities_step.dart';
import '../widgets/steps/budget_step.dart';
import '../widgets/steps/companions_step.dart';
import '../widgets/steps/completion_step.dart';
import '../widgets/steps/interests_step.dart';
import '../widgets/steps/travel_pace_step.dart';
import '../widgets/steps/travel_style_step.dart';
import '../widgets/steps/welcome_step.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    Widget currentStepWidget;
    switch (state.currentStep) {
      case 1:
        currentStepWidget = const WelcomeStep();
        break;
      case 2:
        currentStepWidget = const TravelStyleStep();
        break;
      case 3:
        currentStepWidget = const InterestsStep();
        break;
      case 4:
        currentStepWidget = const BudgetStep();
        break;
      case 5:
        currentStepWidget = const TravelPaceStep();
        break;
      case 6:
        currentStepWidget = const CompanionsStep();
        break;
      case 7:
        currentStepWidget = const ActivitiesStep();
        break;
      case 8:
        currentStepWidget = const CompletionStep();
        break;
      default:
        currentStepWidget = const WelcomeStep();
        break;
    }

    final double progress = (state.currentStep - 1) / 7.0;
    final String stepText = '0${state.currentStep - 1} of 07';

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: state.currentStep > 1 && state.currentStep < 8
            ? IconButton(
                icon: const Icon(PhosphorIconsRegular.caretLeft, color: AppColors.textPrimary, size: 24),
                onPressed: () => notifier.previousStep(),
              )
            : null,
        title: state.currentStep > 1 && state.currentStep < 8
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  stepText,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : null,
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (state.currentStep > 1 && state.currentStep < 8)
            LinearProgressIndicator(
              value: progress.clamp(0.05, 1.0),
              backgroundColor: AppColors.surfaceSecondary,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 3,
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.pageMargin,
                vertical: AppDimensions.space16,
              ),
              child: AnimatedSwitcher(
                duration: AppMotion.normal,
                switchInCurve: AppMotion.enterCurve,
                switchOutCurve: AppMotion.exitCurve,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.04, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey<int>(state.currentStep),
                  child: currentStepWidget,
                ),
              ),
            ),
          ),
          if (state.currentStep < 8)
            Container(
              padding: const EdgeInsets.all(AppDimensions.pageMargin),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: const Border(top: BorderSide(color: AppColors.border, width: 1.0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.03),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: PrimaryButton(
                  label: state.currentStep == 1 ? "Let's get started" : 'Continue',
                  onPressed: () => notifier.nextStep(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}