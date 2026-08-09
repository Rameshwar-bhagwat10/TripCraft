import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../providers/auth_provider.dart';
import '../widgets/password_strength_indicator.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    final success = await ref.read(authProvider.notifier).updatePassword(_passwordController.text);
    setState(() => _isLoading = false);

    if (success && mounted) {
      AppSnackBar.show(
        context,
        message: 'Password updated successfully!',
        variant: AppSnackBarVariant.success,
      );
      context.go(RouteConstants.login);
    } else if (mounted) {
      AppSnackBar.show(
        context,
        message: 'Failed to update password.',
        variant: AppSnackBarVariant.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.caretLeft, color: AppColors.textPrimary, size: 24),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.space12),
                Text('Create a new password', style: AppTypography.displaySmall),
                const SizedBox(height: AppDimensions.space6),
                Text(
                  'Choose a strong password for your Tripcraft account.',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppDimensions.space28),

                AppTextField(
                  label: 'New Password',
                  hintText: 'Enter new password',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  onChanged: (_) => setState(() {}),
                  prefixIcon: const Icon(PhosphorIconsRegular.lockKey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? PhosphorIconsRegular.eye : PhosphorIconsRegular.eyeSlash,
                      size: 20,
                      color: AppColors.textTertiary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Password is required';
                    if (val.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                PasswordStrengthIndicator(password: _passwordController.text),
                const SizedBox(height: AppDimensions.space16),

                AppTextField(
                  label: 'Confirm Password',
                  hintText: 'Re-enter new password',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  prefixIcon: const Icon(PhosphorIconsRegular.lockKey),
                  validator: (val) {
                    if (val != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                  onSubmitted: (_) => _handleUpdatePassword(),
                ),
                const SizedBox(height: AppDimensions.space24),

                PrimaryButton(
                  label: 'Update password',
                  onPressed: _isLoading ? null : _handleUpdatePassword,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
