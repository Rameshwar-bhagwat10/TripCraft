import { ApiPropertyOptional } from "@nestjs/swagger";
import { IsOptional, IsString } from "class-validator";

export class UpdateTripDayDto {
  @ApiPropertyOptional({
    description: "Optional title e.g. Old Goa & Heritage",
  })
  @IsOptional()
  @IsString()
  title?: string;

  @ApiPropertyOptional({ description: "Notes for the day" })
  @IsOptional()
  @IsString()
  notes?: string;
}
