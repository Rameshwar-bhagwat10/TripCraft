import { ApiProperty } from "@nestjs/swagger";
import { IsNotEmpty, IsString, IsArray, ValidateNested } from "class-validator";
import { Type } from "class-transformer";

export class ReorderItemPayload {
  @ApiProperty()
  @IsNotEmpty()
  @IsString()
  id: string;

  @ApiProperty()
  @IsNotEmpty()
  orderIndex: number;
}

export class ReorderItineraryItemsDto {
  @ApiProperty({ description: "Day ID" })
  @IsNotEmpty()
  @IsString()
  dayId: string;

  @ApiProperty({ type: [ReorderItemPayload] })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ReorderItemPayload)
  items: ReorderItemPayload[];
}
