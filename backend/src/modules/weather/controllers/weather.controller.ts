import { Controller, Get, Query, Param } from '@nestjs/common';
import { WeatherService } from '../services/weather.service';

@Controller('weather')
export class WeatherController {
  constructor(private readonly weatherService: WeatherService) {}

  @Get('current')
  async getCurrentWeather(
    @Query('lat') lat?: string,
    @Query('lng') lng?: string,
    @Query('location') location?: string,
  ) {
    const latitude = lat ? parseFloat(lat) : 15.4989;
    const longitude = lng ? parseFloat(lng) : 73.7725;
    return this.weatherService.getCurrentWeather(latitude, longitude, location || 'Goa, India');
  }

  @Get('forecast')
  async getForecast(
    @Query('lat') lat?: string,
    @Query('lng') lng?: string,
  ) {
    const latitude = lat ? parseFloat(lat) : 15.4989;
    const longitude = lng ? parseFloat(lng) : 73.7725;
    const hourly = await this.weatherService.getHourlyForecast(latitude, longitude);
    const daily = await this.weatherService.getDailyForecast(latitude, longitude);
    const alerts = await this.weatherService.getWeatherAlerts(latitude, longitude);

    return { hourly, daily, alerts };
  }

  @Get('trips/:tripId')
  async getTripWeather(@Param('tripId') tripId: string) {
    return this.weatherService.getTripWeather(tripId);
  }
}
