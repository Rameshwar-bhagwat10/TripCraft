import { IsArray, IsOptional, IsString } from 'class-validator';

export class UpdatePreferencesDto {
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  travelStyles?: string[];

  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  interests?: string[];

  @IsString()
  @IsOptional()
  budgetLevel?: string;

  @IsString()
  @IsOptional()
  travelPace?: string;

  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  companionTypes?: string[];

  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  activityPreferences?: string[];
}
