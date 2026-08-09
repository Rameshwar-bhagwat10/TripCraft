import { ApiPropertyOptional } from "@nestjs/swagger";
import { IsOptional, IsString, IsInt, Min } from "class-validator";
import { Type } from "class-transformer";

export class SearchDestinationDto {
  @ApiPropertyOptional({
    description: "Search term for name, city, country, or region",
  })
  @IsOptional()
  @IsString()
  search?: string;

  @ApiPropertyOptional({
    description:
      "Category filter e.g. Beach, Mountains, Adventure, Culture, Nature, Food",
  })
  @IsOptional()
  @IsString()
  category?: string;

  @ApiPropertyOptional({
    description: "Budget level e.g. Budget, Moderate, Premium, Luxury",
  })
  @IsOptional()
  @IsString()
  budget?: string;

  @ApiPropertyOptional({
    description: "Travel style e.g. Relaxation, Adventure, Culture, Nature",
  })
  @IsOptional()
  @IsString()
  travelStyle?: string;

  @ApiPropertyOptional({
    description: "Sort option: Recommended, Popular, Trending, Alphabetical",
  })
  @IsOptional()
  @IsString()
  sort?: string;

  @ApiPropertyOptional({ default: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number = 1;

  @ApiPropertyOptional({ default: 20 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  limit?: number = 20;
}
