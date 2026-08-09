import { Controller, Get, UseGuards } from "@nestjs/common";
import {
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from "@nestjs/swagger";
import { CurrentUser, UserContext } from "../../auth/decorators/user.decorator";
import { SupabaseAuthGuard } from "../../auth/guards/supabase_auth.guard";
import { HomeService } from "../services/home.service";

@ApiTags("home")
@Controller("home")
@UseGuards(SupabaseAuthGuard)
@ApiBearerAuth()
export class HomeController {
  constructor(private readonly homeService: HomeService) {}

  @Get()
  @ApiOperation({
    summary: "Get aggregated Home payload for authenticated user",
  })
  @ApiResponse({ status: 200, description: "Home data retrieved successfully" })
  @ApiResponse({ status: 401, description: "Unauthorized" })
  async getHomeData(@CurrentUser() user: UserContext) {
    return this.homeService.getHomeData(user);
  }
}
