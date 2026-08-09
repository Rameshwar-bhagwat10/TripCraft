import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import {
  IsNotEmpty,
  IsString,
  IsOptional,
  IsBoolean,
  IsInt,
  Min,
} from "class-validator";

export class CreateItineraryItemDto {
  @ApiPropertyOptional({ description: "Optional place ID reference" })
  @IsOptional()
  @IsString()
  placeId?: string;

  @ApiProperty({ description: "Title of the activity e.g. Fort Aguada" })
  @IsNotEmpty()
  @IsString()
  title: string;

  @ApiPropertyOptional({ description: "Detailed description" })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional({ default: "sightseeing" })
  @IsOptional()
  @IsString()
  type?: string = "sightseeing";

  @ApiPropertyOptional({ description: "Start time e.g. 09:00" })
  @IsOptional()
  @IsString()
  startTime?: string;

  @ApiPropertyOptional({ description: "End time e.g. 10:30" })
  @IsOptional()
  @IsString()
  endTime?: string;

  @ApiPropertyOptional({ description: "Formatted duration e.g. 1h 30m" })
  @IsOptional()
  @IsString()
  duration?: string;

  @ApiPropertyOptional({ default: 0 })
  @IsOptional()
  @IsInt()
  @Min(0)
  orderIndex?: number = 0;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  notes?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  imageUrl?: string;

  @ApiPropertyOptional({ default: false })
  @IsOptional()
  @IsBoolean()
  isAllDay?: boolean = false;
}
