import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import {
  IsNotEmpty,
  IsString,
  IsOptional,
  IsInt,
  Min,
  IsDateString,
} from "class-validator";

export class CreateTripDto {
  @ApiProperty({ description: "Destination ID or slug" })
  @IsNotEmpty()
  @IsString()
  destinationId: string;

  @ApiProperty({ description: "Title of the trip e.g. Goa Escape" })
  @IsNotEmpty()
  @IsString()
  title: string;

  @ApiPropertyOptional({ description: "Optional description or note" })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiProperty({ description: "Start date in ISO format e.g. 2026-08-21" })
  @IsNotEmpty()
  @IsDateString()
  startDate: string;

  @ApiProperty({ description: "End date in ISO format e.g. 2026-08-25" })
  @IsNotEmpty()
  @IsDateString()
  endDate: string;

  @ApiPropertyOptional({ default: 1 })
  @IsOptional()
  @IsInt()
  @Min(1)
  travelersCount?: number = 1;

  @ApiPropertyOptional({ description: "Cover image URL override" })
  @IsOptional()
  @IsString()
  coverImage?: string;
}
