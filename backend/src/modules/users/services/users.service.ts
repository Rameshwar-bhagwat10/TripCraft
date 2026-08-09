import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../../database/prisma/prisma.service';
import { UserContext } from '../../auth/decorators/user.decorator';
import { UpdatePreferencesDto } from '../dto/update_preferences.dto';

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  async getProfile(userCtx: UserContext) {
    let profile = await this.prisma.user.findUnique({
      where: { id: userCtx.id },
      include: { preferences: true },
    });

    if (!profile) {
      // Auto-initialize profile if registering for the first time
      profile = await this.prisma.user.create({
        data: {
          id: userCtx.id,
          email: userCtx.email,
          fullName: userCtx.fullName,
          avatarUrl: userCtx.avatarUrl,
        },
        include: { preferences: true },
      });
    }

    return profile;
  }

  async updatePreferences(userCtx: UserContext, dto: UpdatePreferencesDto) {
    // Ensure profile exists
    await this.getProfile(userCtx);

    const preferences = await this.prisma.userPreferences.upsert({
      where: { userId: userCtx.id },
      create: {
        userId: userCtx.id,
        travelStyles: dto.travelStyles ?? [],
        interests: dto.interests ?? [],
        budgetLevel: dto.budgetLevel ?? 'Moderate',
        travelPace: dto.travelPace ?? 'Balanced',
        companionTypes: dto.companionTypes ?? [],
        activityPreferences: dto.activityPreferences ?? [],
      },
      update: {
        travelStyles: dto.travelStyles,
        interests: dto.interests,
        budgetLevel: dto.budgetLevel,
        travelPace: dto.travelPace,
        companionTypes: dto.companionTypes,
        activityPreferences: dto.activityPreferences,
      },
    });

    // Mark onboarding as completed
    const updatedProfile = await this.prisma.user.update({
      where: { id: userCtx.id },
      data: { onboardingCompleted: true },
      include: { preferences: true },
    });

    return updatedProfile;
  }
}
