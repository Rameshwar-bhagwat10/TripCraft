import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';
import '../../../../shared/widgets/buttons/tertiary_button.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';
import '../providers/auth_provider.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  int _cooldownSeconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() {
      _cooldownSeconds = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldownSeconds > 0) {
        setState(() {
          _cooldownSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _handleResend() async {
    if (_cooldownSeconds > 0) return;
    final email = ref.read(authProvider).email ?? '';
    await ref.read(authProvider.notifier).resendVerificationEmail(email);
    _startCooldown();
    if (mounted) {
      AppSnackBar.show(
        context,
        message: 'Verification link resent to $email',
        variant: AppSnackBarVariant.info,
      );
    }
  }

  Future<void> _handleCheckVerification() async {
    final isVerified = await ref.read(authProvider.notifier).checkEmailVerification();
    if (!isVerified && mounted) {
      AppSnackBar.show(
        context,
        message: 'Email still not verified. Please check your inbox.',
        variant: AppSnackBarVariant.warning,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = ref.watch(authProvider).email ?? 'your email';

    return AppScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(15, 118, 110, 0.12),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      PhosphorIconsBold.envelopeSimpleOpen,
                      size: 38,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space24),
                  Text(
                    'Check your inbox',
                    style: AppTypography.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Text(
                    "We've sent a verification link to:",
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.space4),
                  Text(
                    email,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.space12),
                  Text(
                    'Verify your email to continue setting up your Tripcraft account.',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.space32),

                  PrimaryButton(
                    label: "I've verified my email",
                    onPressed: _handleCheckVerification,
                  ),
                  const SizedBox(height: AppDimensions.space12),

                  SecondaryButton(
                    label: _cooldownSeconds > 0
                        ? 'Resend available in ${_cooldownSeconds}s'
                        : 'Resend verification email',
                    onPressed: _cooldownSeconds > 0 ? null : _handleResend,
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  TertiaryButton(
                    label: 'Change email / Sign out',
                    onPressed: () => ref.read(authProvider.notifier).logout(),
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