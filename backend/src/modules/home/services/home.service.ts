import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../database/prisma/prisma.service';
import { UserContext } from '../../auth/decorators/user.decorator';

@Injectable()
export class HomeService {
  constructor(private readonly prisma: PrismaService) {}

  async getHomeData(userCtx: UserContext) {
    const profile = await this.prisma.user.findUnique({
      where: { id: userCtx.id },
      include: { preferences: true },
    });

    const userTravelStyles = profile?.preferences?.travelStyles ?? ['Adventure', 'Nature'];

    return {
      user: {
        id: userCtx.id,
        email: userCtx.email,
        fullName: profile?.fullName ?? userCtx.fullName ?? 'Traveler',
        avatarUrl: profile?.avatarUrl ?? userCtx.avatarUrl,
        language: profile?.language ?? 'en',
        currency: profile?.currency ?? 'USD',
      },
      upcomingTrip: null, // Contract ready for Phase 6 Trips
      recommendations: [
        {
          id: 'rec-1',
          title: 'Goa Coastline',
          location: 'Goa, India',
          category: 'Beach & Relaxation',
          imageUrl: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800',
          isSaved: false,
        },
        {
          id: 'rec-2',
          title: 'Munnar Tea Hills',
          location: 'Kerala, India',
          category: 'Nature & Adventure',
          imageUrl: 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=800',
          isSaved: true,
        },
        {
          id: 'rec-3',
          title: 'Manali Valleys',
          location: 'Himachal Pradesh, India',
          category: 'Mountains & Treks',
          imageUrl: 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=800',
          isSaved: false,
        },
      ],
      inspiration: [
        { id: 'insp-1', title: 'Weekend Escapes', icon: 'compass' },
        { id: 'insp-2', title: 'Beach Getaways', icon: 'sun' },
        { id: 'insp-3', title: 'Mountain Retreats', icon: 'mountains' },
        { id: 'insp-4', title: 'Cultural Journeys', icon: 'buildings' },
        { id: 'insp-5', title: 'Food & Culinary', icon: 'fork-knife' },
      ],
      weather: {
        location: 'Mumbai, India',
        temperature: 28,
        condition: 'Partly Cloudy',
        feelsLike: 30,
        icon: 'cloud-sun',
      },
      recentActivity: [
        {
          id: 'act-1',
          title: 'Goa Trip Planning',
          subtitle: 'Draft itinerary created',
          updatedAt: new Date().toISOString(),
        },
      ],
    };
  }
}
