import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';
import '../providers/trip_operations_provider.dart';
import '../widgets/add_document_sheet.dart';
import '../widgets/document_card.dart';

class DocumentVaultScreen extends ConsumerStatefulWidget {
  final String tripId;

  const DocumentVaultScreen({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<DocumentVaultScreen> createState() => _DocumentVaultScreenState();
}

class _DocumentVaultScreenState extends ConsumerState<DocumentVaultScreen> {
  void _showUploadSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddDocumentSheet(
          onUpload: (data) async {
            await ref.read(tripOperationsProvider(widget.tripId).notifier).createDocument(data);
            if (context.mounted) {
              AppSnackBar.show(context, message: 'Document uploaded to vault');
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripOperationsProvider(widget.tripId));

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Document Vault (${state.documents.length})', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsBold.uploadSimple, color: AppColors.primary),
            onPressed: _showUploadSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: state.documents.isEmpty
            ? Center(child: Text('No documents uploaded yet.', style: AppTypography.bodyMedium))
            : ListView.builder(
                padding: const EdgeInsets.all(AppDimensions.pageMargin),
                itemCount: state.documents.length,
                itemBuilder: (context, index) {
                  final doc = state.documents[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.space10),
                    child: DocumentCard(
                      document: doc,
                      onTap: () => AppSnackBar.show(context, message: 'Opening ${doc.title}...'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
