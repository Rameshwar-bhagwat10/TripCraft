import {
  Body,
  Controller,
  Get,
  Put,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser, UserContext } from '../../auth/decorators/user.decorator';
import { SupabaseAuthGuard } from '../../auth/guards/supabase_auth.guard';
import { UpdatePreferencesDto } from '../dto/update_preferences.dto';
import { UsersService } from '../services/users.service';

@ApiTags('users')
@Controller('users')
@UseGuards(SupabaseAuthGuard)
@ApiBearerAuth()
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('me')
  @ApiOperation({ summary: 'Get current user TripCraft profile & onboarding state' })
  @ApiResponse({ status: 200, description: 'User profile retrieved successfully' })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  async getProfile(@CurrentUser() user: UserContext) {
    return this.usersService.getProfile(user);
  }

  @Put('me/preferences')
  @ApiOperation({ summary: 'Save onboarding travel preferences and mark onboarding complete' })
  @ApiResponse({ status: 200, description: 'Preferences saved and onboarding completed' })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  async updatePreferences(
    @CurrentUser() user: UserContext,
    @Body() dto: UpdatePreferencesDto,
  ) {
    return this.usersService.updatePreferences(user, dto);
  }
}
