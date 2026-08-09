import { Controller, Get, HttpStatus, Res } from "@nestjs/common";
import { ApiTags, ApiOperation, ApiResponse } from "@nestjs/swagger";
import { Response } from "express";
import { PrismaService } from "../../database/prisma/prisma.service";

@ApiTags("Health")
@Controller("health")
export class HealthController {
  constructor(private readonly prisma: PrismaService) {}

  @Get()
  @ApiOperation({ summary: "Run system health check" })
  @ApiResponse({ status: 200, description: "Service is healthy" })
  @ApiResponse({ status: 500, description: "Service or database is unhealthy" })
  async check(@Res() res: Response) {
    try {
      await this.prisma.$queryRaw`SELECT 1`;
      return res.status(HttpStatus.OK).json({
        status: "ok",
        service: "tripcraft-api",
        database: "connected",
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
        status: "error",
        service: "tripcraft-api",
        database: "disconnected",
        error: error.message || error,
        timestamp: new Date().toISOString(),
      });
    }
  }
}
