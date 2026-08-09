import { ApiPropertyOptional } from "@nestjs/swagger";
import { IsOptional, IsString } from "class-validator";

export class SearchPlacesDto {
  @ApiPropertyOptional({ description: "Search term e.g. Fort, Beach, Cafe" })
  @IsOptional()
  @IsString()
  query?: string;

  @ApiPropertyOptional({
    description: "Category e.g. Sightseeing, Food, Hotel",
  })
  @IsOptional()
  @IsString()
  category?: string;

  @ApiPropertyOptional({ description: "Destination ID e.g. dest-goa" })
  @IsOptional()
  @IsString()
  destinationId?: string;
}
