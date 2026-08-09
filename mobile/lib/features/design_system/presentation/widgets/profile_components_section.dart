import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../profile/presentation/widgets/profile_avatar.dart';
import '../../../profile/presentation/widgets/profile_header.dart';
import '../../../profile/presentation/widgets/profile_row.dart';
import '../../../profile/presentation/widgets/profile_section.dart';

class ProfileComponentsSection extends StatelessWidget {
  const ProfileComponentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      title: 'Profile & Settings Components',
      subtitle: 'Profile Header, Avatar, Section Container, and List Rows',
      child: Column(
        children: [
          const ProfileHeader(
            fullName: 'Rameshwar Bhagwat',
            email: 'rameshwar@example.com',
          ),
          const SizedBox(height: AppDimensions.space20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              ProfileAvatar(fullName: 'Rameshwar Bhagwat', size: 64),
              ProfileAvatar(fullName: 'Jane Doe', size: 64),
              ProfileAvatar(fullName: 'TripCraft', size: 64),
            ],
          ),
          const SizedBox(height: AppDimensions.space20),
          ProfileSection(
            title: 'SAMPLE SETTINGS SECTION',
            children: [
              ProfileRow(
                icon: PhosphorIconsRegular.user,
                title: 'Personal Information',
                value: 'Rameshwar Bhagwat',
                onTap: () {},
              ),
              ProfileRow(
                icon: PhosphorIconsRegular.compass,
                title: 'Travel Preferences',
                value: 'Adventure, Nature',
                onTap: () {},
              ),
              ProfileRow(
                icon: PhosphorIconsRegular.globe,
                title: 'Language',
                value: 'English (EN)',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
