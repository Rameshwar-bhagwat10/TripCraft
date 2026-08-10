import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';

import '../providers/ai_copilot_provider.dart';

class AiMemoriesScreen extends ConsumerStatefulWidget {
  const AiMemoriesScreen({super.key});

  @override
  ConsumerState<AiMemoriesScreen> createState() => _AiMemoriesScreenState();
}

class _AiMemoriesScreenState extends ConsumerState<AiMemoriesScreen> {
  bool _isLoading = true;
  List<dynamic> _memories = [];

  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  Future<void> _loadMemories() async {
    final repo = ref.read(aiCopilotRepositoryProvider);
    final res = await repo.getMemories();
    if (mounted) {
      setState(() {
        _memories = res;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteMemory(String id) async {
    final repo = ref.read(aiCopilotRepositoryProvider);
    final success = await repo.deleteMemory(id);
    if (mounted && success) {
      setState(() {
        _memories.removeWhere((m) => m.id == id);
      });
      AppSnackBar.show(context, message: 'AI memory removed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('AI Persistent Memories', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.pageMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tripcraft AI learns persistent preferences and travel constraints from your conversations to personalize future recommendations.',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4),
                    ),
                    const SizedBox(height: AppDimensions.space20),

                    Text('STORED MEMORIES (${_memories.length})', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                    const SizedBox(height: AppDimensions.space10),

                    if (_memories.isEmpty)
                      Text('No stored memories yet.', style: AppTypography.bodyMedium)
                    else
                      ..._memories.map((mem) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: AppDimensions.space10),
                          padding: const EdgeInsets.all(AppDimensions.space14),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.primarySurface,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(PhosphorIconsFill.brain, color: AppColors.primary, size: 18),
                              ),
                              const SizedBox(width: AppDimensions.space12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(mem.key.toUpperCase(), style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 10)),
                                    const SizedBox(height: 2),
                                    Text(mem.value, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(PhosphorIconsRegular.trash, color: AppColors.error, size: 18),
                                onPressed: () => _deleteMemory(mem.id),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
      ),
    );
  }
}
