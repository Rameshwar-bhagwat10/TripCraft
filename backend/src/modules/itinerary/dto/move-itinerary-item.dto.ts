import { ApiProperty } from "@nestjs/swagger";
import { IsNotEmpty, IsString, IsInt, Min } from "class-validator";

export class MoveItineraryItemDto {
  @ApiProperty({ description: "Target Trip Day ID" })
  @IsNotEmpty()
  @IsString()
  targetDayId: string;

  @ApiProperty({ default: 0 })
  @IsNotEmpty()
  @IsInt()
  @Min(0)
  newOrderIndex: number;
}
