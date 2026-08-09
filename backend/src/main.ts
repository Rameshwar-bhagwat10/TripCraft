import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";
import { ValidationPipe } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { DocumentBuilder, SwaggerModule } from "@nestjs/swagger";
import { GlobalExceptionFilter } from "./common/filters/http-exception.filter";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);

  const apiPrefix = configService.get<string>("app.apiPrefix") || "api/v1";
  app.setGlobalPrefix(apiPrefix);

  // Enable CORS
  const corsOrigin =
    configService.get<string>("app.corsOrigin") || "http://localhost:3000";
  app.enableCors({
    origin: corsOrigin.split(","),
    methods: "GET,HEAD,PUT,PATCH,POST,DELETE",
    credentials: true,
  });

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // Global exception filter
  app.useGlobalFilters(new GlobalExceptionFilter());

  // Swagger Documentation configuration
  const config = new DocumentBuilder()
    .setTitle("TripCraft API")
    .setDescription("The TripCraft Trip Planning SaaS API services description")
    .setVersion("1.0")
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup("api/docs", app, document);

  // Enable graceful shutdown
  app.enableShutdownHooks();

  const port = configService.get<number>("app.port") || 3000;
  await app.listen(port);
  console.log(
    `Application is running on: http://localhost:${port}/${apiPrefix}`,
  );
  console.log(
    `API Swagger documentation available at: http://localhost:${port}/api/docs`,
  );
}
bootstrap();
