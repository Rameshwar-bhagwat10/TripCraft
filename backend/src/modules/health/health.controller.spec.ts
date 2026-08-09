import { Test, TestingModule } from "@nestjs/testing";
import { HealthController } from "./health.controller";
import { PrismaService } from "../../database/prisma/prisma.service";

describe("HealthController", () => {
  let controller: HealthController;
  let prisma: PrismaService;

  beforeEach(async () => {
    const mockPrismaService = {
      $queryRaw: jest.fn().mockResolvedValue([{ 1: 1 }]),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [HealthController],
      providers: [
        {
          provide: PrismaService,
          useValue: mockPrismaService,
        },
      ],
    }).compile();

    controller = module.get<HealthController>(HealthController);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it("should be defined", () => {
    expect(controller).toBeDefined();
  });

  describe("check", () => {
    it("should return health status successfully", async () => {
      const mockResponse: any = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn().mockImplementation((data) => data),
      };

      await controller.check(mockResponse);

      expect(prisma.$queryRaw).toHaveBeenCalled();
      expect(mockResponse.status).toHaveBeenCalledWith(200);
      expect(mockResponse.json).toHaveBeenCalledWith(
        expect.objectContaining({
          status: "ok",
          service: "tripcraft-api",
          database: "connected",
        }),
      );
    });

    it("should return error response when database is disconnected", async () => {
      const mockResponse: any = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn().mockImplementation((data) => data),
      };

      jest
        .spyOn(prisma, "$queryRaw")
        .mockRejectedValueOnce(new Error("Connection failure"));

      await controller.check(mockResponse);

      expect(mockResponse.status).toHaveBeenCalledWith(500);
      expect(mockResponse.json).toHaveBeenCalledWith(
        expect.objectContaining({
          status: "error",
          service: "tripcraft-api",
          database: "disconnected",
          error: "Connection failure",
        }),
      );
    });
  });
});
