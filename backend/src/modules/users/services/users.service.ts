import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../database/prisma/prisma.service';
import { UserContext } from '../../auth/decorators/user.decorator';
import { UpdatePreferencesDto } from '../dto/update_preferences.dto';
import { UpdateProfileDto } from '../dto/update_profile.dto';

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

  async updateProfile(userCtx: UserContext, dto: UpdateProfileDto) {
    // Ensure profile exists
    await this.getProfile(userCtx);

    const updatedProfile = await this.prisma.user.update({
      where: { id: userCtx.id },
      data: {
        ...(dto.fullName !== undefined && { fullName: dto.fullName }),
        ...(dto.avatarUrl !== undefined && { avatarUrl: dto.avatarUrl }),
        ...(dto.language !== undefined && { language: dto.language }),
        ...(dto.currency !== undefined && { currency: dto.currency }),
      },
      include: { preferences: true },
    });

    return updatedProfile;
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
        reducedMotion: dto.reducedMotion ?? false,
        largerText: dto.largerText ?? false,
        highContrast: dto.highContrast ?? false,
        personalizedRecommendations: dto.personalizedRecommendations ?? true,
        aiPersonalization: dto.aiPersonalization ?? true,
        contextualSuggestions: dto.contextualSuggestions ?? true,
      },
      update: {
        ...(dto.travelStyles !== undefined && { travelStyles: dto.travelStyles }),
        ...(dto.interests !== undefined && { interests: dto.interests }),
        ...(dto.budgetLevel !== undefined && { budgetLevel: dto.budgetLevel }),
        ...(dto.travelPace !== undefined && { travelPace: dto.travelPace }),
        ...(dto.companionTypes !== undefined && { companionTypes: dto.companionTypes }),
        ...(dto.activityPreferences !== undefined && { activityPreferences: dto.activityPreferences }),
        ...(dto.reducedMotion !== undefined && { reducedMotion: dto.reducedMotion }),
        ...(dto.largerText !== undefined && { largerText: dto.largerText }),
        ...(dto.highContrast !== undefined && { highContrast: dto.highContrast }),
        ...(dto.personalizedRecommendations !== undefined && { personalizedRecommendations: dto.personalizedRecommendations }),
        ...(dto.aiPersonalization !== undefined && { aiPersonalization: dto.aiPersonalization }),
        ...(dto.contextualSuggestions !== undefined && { contextualSuggestions: dto.contextualSuggestions }),
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
