import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../../../../shared/widgets/inputs/date_picker_field.dart';
import '../../../../shared/widgets/inputs/search_field.dart';

class InputSection extends StatelessWidget {
  const InputSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      title: 'Inputs',
      subtitle: 'Form text fields, search bar, and date picker components',
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          children: [
            const AppTextField(
              label: 'Destination Name',
              hintText: 'e.g. Paris, France',
              prefixIcon: Icon(PhosphorIconsRegular.mapPin, size: 20),
            ),
            const SizedBox(height: AppDimensions.space16),
            const AppTextField(
              label: 'Field with Error',
              hintText: 'Enter invalid value',
              errorText: 'This field is required',
            ),
            const SizedBox(height: AppDimensions.space16),
            const AppTextField(
              label: 'Disabled Input',
              hintText: 'Read only value',
              enabled: false,
            ),
            const SizedBox(height: AppDimensions.space16),
            SearchField(
              onChanged: (_) {},
              onFilterTap: () {},
            ),
            const SizedBox(height: AppDimensions.space16),
            DatePickerField(
              label: 'Trip Start Date',
              selectedDate: DateTime.now(),
              onDateSelected: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
