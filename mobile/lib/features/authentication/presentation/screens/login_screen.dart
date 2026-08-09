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
import '../widgets/social_auth_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    final success = await ref.read(authProvider.notifier).login(
          _emailController.text,
          _passwordController.text,
        );

    if (!success && mounted) {
      final errorMsg = ref.read(authProvider).errorMessage ?? 'Invalid login credentials.';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.pageMargin),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.space32),
              // Header Logo
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: AppDimensions.borderMD,
                ),
                child: const Icon(
                  PhosphorIconsBold.compass,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppDimensions.space24),
              Text('Welcome back', style: AppTypography.headlineLarge),
              const SizedBox(height: AppDimensions.space8),
              Text(
                'Sign in to continue planning better trips.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppDimensions.space32),

              // Email Field
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

              // Password Field
              AppTextField(
                label: 'Password',
                hintText: 'Enter your password',
                controller: _passwordController,
                obscureText: _obscurePassword,
                prefixIcon: const Icon(PhosphorIconsRegular.lockKey, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? PhosphorIconsRegular.eye
                        : PhosphorIconsRegular.eyeSlash,
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
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.space12),

              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push('/auth/forgot-password'),
                  child: Text(
                    'Forgot password?',
                    style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.space20),

              // Sign In CTA
              PrimaryButton(
                label: 'Sign In',
                onPressed: isLoading ? null : _handleLogin,
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

              // Social Auth Buttons
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

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () => context.push(RouteConstants.register),
                    child: Text(
                      'Create account',
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