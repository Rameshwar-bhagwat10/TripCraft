import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late String _initialName;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).profile;
    _initialName = profile?.fullName ?? '';
    _nameController = TextEditingController(text: _initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _hasChanges => _nameController.text.trim() != _initialName;

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final success = await ref.read(profileProvider.notifier).updateProfile(
          fullName: _nameController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
      AppSnackBar.show(
        context,
        message: 'Profile updated successfully',
        variant: AppSnackBarVariant.success,
      );
      context.pop();
    } else {
      AppSnackBar.show(
        context,
        message: 'Failed to update profile',
        variant: AppSnackBarVariant.error,
      );
    }
  }

  Future<bool> _confirmPop() async {
    if (!_hasChanges) return true;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Unsaved Changes'),
          content: const Text('You have unsaved changes. Discard changes and leave?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Keep Editing'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Discard', style: TextStyle(color: AppColors.error)),
            ),
          ],
        );
      },
    );

    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final email = profileState.profile?.email ?? '';

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _confirmPop();
        if (shouldPop && context.mounted) {
          context.pop();
        }
      },
      child: AppScaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(PhosphorIconsRegular.caretLeft, color: AppColors.textPrimary, size: 24),
            onPressed: () async {
              final shouldPop = await _confirmPop();
              if (shouldPop && context.mounted) {
                context.pop();
              }
            },
          ),
          title: Text(
            'Edit Profile',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.space16),
                  Text(
                    'Personal Information',
                    style: AppTypography.displaySmall,
                  ),
                  const SizedBox(height: AppDimensions.space6),
                  Text(
                    'Update your account details below.',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppDimensions.space24),

                  // Container
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.space20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        AppTextField(
                          label: 'Full Name',
                          hintText: 'Enter your full name',
                          controller: _nameController,
                          prefixIcon: const Icon(PhosphorIconsRegular.user),
                          onChanged: (_) => setState(() {}),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Full name is required';
                            return null;
                          },
                        ),
                        const SizedBox(height: AppDimensions.space16),

                        AppTextField(
                          label: 'Email Address (Read-only)',
                          hintText: email,
                          enabled: false,
                          prefixIcon: const Icon(PhosphorIconsRegular.envelope),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space32),

                  PrimaryButton(
                    label: 'Save Changes',
                    onPressed: _hasChanges && !profileState.isUpdating ? _handleSave : null,
                    isLoading: profileState.isUpdating,
                    isDisabled: !_hasChanges,
                  ),
                  const SizedBox(height: AppDimensions.space24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}