import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import appConfig from "./config/app.config";
import databaseConfig from "./config/database.config";
import authConfig from "./config/auth.config";
import { DatabaseModule } from "./database/database.module";
import { HealthModule } from "./modules/health/health.module";
import { UsersModule } from "./modules/users/users.module";
import { HomeModule } from "./modules/home/home.module";
import { DestinationsModule } from "./modules/destinations/destinations.module";
import { TripsModule } from "./modules/trips/trips.module";

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [appConfig, databaseConfig, authConfig],
    }),
    DatabaseModule,
    HealthModule,
    UsersModule,
    HomeModule,
    DestinationsModule,
    TripsModule,
  ],
})
export class AppModule {}
