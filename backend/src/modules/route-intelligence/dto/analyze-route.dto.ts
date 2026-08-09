import { ApiPropertyOptional } from "@nestjs/swagger";
import { IsOptional, IsString } from "class-validator";

export class AnalyzeRouteDto {
  @ApiPropertyOptional({ default: "driving" })
  @IsOptional()
  @IsString()
  mode?: string = "driving";
}
