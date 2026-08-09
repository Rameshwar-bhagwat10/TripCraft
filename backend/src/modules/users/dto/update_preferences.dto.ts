import { ApiPropertyOptional } from "@nestjs/swagger";
import { IsArray, IsBoolean, IsOptional, IsString } from "class-validator";

export class UpdatePreferencesDto {
  @ApiPropertyOptional({ example: ["Adventure", "Culture"] })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  travelStyles?: string[];

  @ApiPropertyOptional({ example: ["Nature", "Food"] })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  interests?: string[];

  @ApiPropertyOptional({ example: "Moderate" })
  @IsString()
  @IsOptional()
  budgetLevel?: string;

  @ApiPropertyOptional({ example: "Balanced" })
  @IsString()
  @IsOptional()
  travelPace?: string;

  @ApiPropertyOptional({ example: ["Friends", "Family"] })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  companionTypes?: string[];

  @ApiPropertyOptional({ example: ["Outdoor", "Dining"] })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  activityPreferences?: string[];

  @ApiPropertyOptional({ example: false })
  @IsBoolean()
  @IsOptional()
  reducedMotion?: boolean;

  @ApiPropertyOptional({ example: false })
  @IsBoolean()
  @IsOptional()
  largerText?: boolean;

  @ApiPropertyOptional({ example: false })
  @IsBoolean()
  @IsOptional()
  highContrast?: boolean;

  @ApiPropertyOptional({ example: true })
  @IsBoolean()
  @IsOptional()
  personalizedRecommendations?: boolean;

  @ApiPropertyOptional({ example: true })
  @IsBoolean()
  @IsOptional()
  aiPersonalization?: boolean;

  @ApiPropertyOptional({ example: true })
  @IsBoolean()
  @IsOptional()
  contextualSuggestions?: boolean;
}
