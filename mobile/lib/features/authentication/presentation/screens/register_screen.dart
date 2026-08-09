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
import '../../domain/entities/auth_state.dart';
import '../providers/auth_provider.dart';
import '../widgets/password_strength_indicator.dart';
import '../widgets/social_auth_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    final success = await ref.read(authProvider.notifier).register(
          email: _emailController.text,
          password: _passwordController.text,
          fullName: _fullNameController.text,
        );

    if (!success && mounted) {
      final errorMsg = ref.read(authProvider).errorMessage ?? 'Registration failed.';
      AppSnackBar.show(
        context,
        message: errorMsg,
        variant: AppSnackBarVariant.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.authenticating;

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.pageMargin),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create your account', style: AppTypography.headlineLarge),
              const SizedBox(height: AppDimensions.space8),
              Text(
                'Start planning smarter trips with Tripcraft.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppDimensions.space32),

              // Full Name
              AppTextField(
                label: 'Full Name',
                hintText: 'Enter your full name',
                controller: _fullNameController,
                prefixIcon: const Icon(PhosphorIconsRegular.user, size: 20),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Full name is required';
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.space16),

              // Email
              AppTextField(
                label: 'Email',
                hintText: 'Enter your email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(PhosphorIconsRegular.envelope, size: 20),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Email is required';
                  if (!val.contains('@') || !val.contains('.')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.space16),

              // Password
              AppTextField(
                label: 'Password',
                hintText: 'Create a password',
                controller: _passwordController,
                obscureText: _obscurePassword,
                onChanged: (_) => setState(() {}),
                prefixIcon: const Icon(PhosphorIconsRegular.lockKey, size: 20),
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
              ),
              PasswordStrengthIndicator(password: _passwordController.text),
              const SizedBox(height: AppDimensions.space16),

              // Confirm Password
              AppTextField(
                label: 'Confirm Password',
                hintText: 'Re-enter your password',
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                prefixIcon: const Icon(PhosphorIconsRegular.lockKey, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? PhosphorIconsRegular.eye : PhosphorIconsRegular.eyeSlash,
                    size: 20,
                    color: AppColors.textTertiary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                validator: (val) {
                  if (val != _passwordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.space24),

              // Create Account CTA
              PrimaryButton(
                label: 'Create Account',
                onPressed: isLoading ? null : _handleRegister,
                isLoading: isLoading,
              ),
              const SizedBox(height: AppDimensions.space24),

              // OR Divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
                    child: Text(
                      'OR',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: AppDimensions.space24),

              // Social Buttons
              SocialAuthButton(
                provider: SocialProvider.google,
                onPressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
              ),
              const SizedBox(height: AppDimensions.space12),
              SocialAuthButton(
                provider: SocialProvider.apple,
                onPressed: () => ref.read(authProvider.notifier).signInWithApple(),
              ),
              const SizedBox(height: AppDimensions.space32),

              // Sign in link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () => context.go(RouteConstants.login),
                    child: Text(
                      'Sign in',
                      style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.space32),
            ],
          ),
        ),
      ),
    );
  }
}