import { Injectable, Logger } from '@nestjs/common';

export interface WeatherCondition {
  main: string;
  description: string;
  icon: string;
  code: string;
}

export interface WeatherSnapshot {
  location: string;
  latitude: number;
  longitude: number;
  temperature: number;
  feelsLike: number;
  tempMin: number;
  tempMax: number;
  condition: WeatherCondition;
  humidity: number;
  windSpeed: number;
  windDirection: number;
  precipitationProbability: number;
  uvIndex?: number;
  sunrise?: string;
  sunset?: string;
  observedAt: string;
}

export interface HourlyForecastItem {
  time: string;
  temperature: number;
  feelsLike: number;
  condition: WeatherCondition;
  precipitationProbability: number;
  precipitationAmountMm: number;
  windSpeed: number;
}

export interface DailyForecastItem {
  date: string;
  dayName: string;
  tempMax: number;
  tempMin: number;
  condition: WeatherCondition;
  precipitationProbability: number;
  precipitationAmountMm: number;
  windSpeed: number;
  uvIndex: number;
  sunrise: string;
  sunset: string;
}

export interface WeatherAlertItem {
  id: string;
  title: string;
  description: string;
  severity: 'info' | 'caution' | 'warning' | 'critical';
  startTime: string;
  endTime: string;
  source: string;
}

@Injectable()
export class WeatherService {
  private readonly logger = new Logger(WeatherService.name);

  async getCurrentWeather(lat = 15.4989, lng = 73.7725, locationName = 'Goa, India'): Promise<WeatherSnapshot> {
    // In production, fetch from OpenWeather API if WEATHER_API_KEY environment variable is set
    return {
      location: locationName,
      latitude: lat,
      longitude: lng,
      temperature: 28,
      feelsLike: 31,
      tempMin: 24,
      tempMax: 30,
      condition: {
        main: 'Partly Cloudy',
        description: 'Partly cloudy with light coastal breeze',
        icon: 'partly-cloudy',
        code: 'partly_cloudy',
      },
      humidity: 74,
      windSpeed: 14,
      windDirection: 240,
      precipitationProbability: 35,
      uvIndex: 7,
      sunrise: '06:12 AM',
      sunset: '06:45 PM',
      observedAt: new Date().toISOString(),
    };
  }

  async getHourlyForecast(lat = 15.4989, lng = 73.7725): Promise<HourlyForecastItem[]> {
    return [
      { time: '09:00 AM', temperature: 27, feelsLike: 29, condition: { main: 'Clear', description: 'Sunny', icon: 'clear', code: 'clear' }, precipitationProbability: 10, precipitationAmountMm: 0.0, windSpeed: 10 },
      { time: '11:00 AM', temperature: 29, feelsLike: 32, condition: { main: 'Partly Cloudy', description: 'Partly cloudy', icon: 'partly-cloudy', code: 'partly_cloudy' }, precipitationProbability: 20, precipitationAmountMm: 0.0, windSpeed: 12 },
      { time: '01:00 PM', temperature: 30, feelsLike: 34, condition: { main: 'Cloudy', description: 'Overcast', icon: 'cloudy', code: 'cloudy' }, precipitationProbability: 45, precipitationAmountMm: 0.5, windSpeed: 15 },
      { time: '03:00 PM', temperature: 27, feelsLike: 30, condition: { main: 'Heavy Rain', description: 'Heavy monsoon shower', icon: 'heavy-rain', code: 'heavy_rain' }, precipitationProbability: 85, precipitationAmountMm: 12.4, windSpeed: 22 },
      { time: '05:00 PM', temperature: 26, feelsLike: 28, condition: { main: 'Rain', description: 'Light rain', icon: 'rain', code: 'rain' }, precipitationProbability: 60, precipitationAmountMm: 3.2, windSpeed: 18 },
      { time: '07:00 PM', temperature: 25, feelsLike: 27, condition: { main: 'Clear', description: 'Clear sky', icon: 'clear', code: 'clear' }, precipitationProbability: 15, precipitationAmountMm: 0.0, windSpeed: 11 },
    ];
  }

  async getDailyForecast(lat = 15.4989, lng = 73.7725): Promise<DailyForecastItem[]> {
    return [
      { date: '2026-08-21', dayName: 'Mon', tempMax: 30, tempMin: 24, condition: { main: 'Partly Cloudy', description: 'Scattered clouds', icon: 'partly-cloudy', code: 'partly_cloudy' }, precipitationProbability: 30, precipitationAmountMm: 1.2, windSpeed: 14, uvIndex: 8, sunrise: '06:12 AM', sunset: '06:45 PM' },
      { date: '2026-08-22', dayName: 'Tue', tempMax: 27, tempMin: 23, condition: { main: 'Heavy Rain', description: 'Monsoon rain afternoon', icon: 'heavy-rain', code: 'heavy_rain' }, precipitationProbability: 85, precipitationAmountMm: 15.6, windSpeed: 22, uvIndex: 5, sunrise: '06:13 AM', sunset: '06:44 PM' },
      { date: '2026-08-23', dayName: 'Wed', tempMax: 29, tempMin: 24, condition: { main: 'Cloudy', description: 'Mostly cloudy', icon: 'cloudy', code: 'cloudy' }, precipitationProbability: 40, precipitationAmountMm: 2.5, windSpeed: 16, uvIndex: 7, sunrise: '06:13 AM', sunset: '06:44 PM' },
      { date: '2026-08-24', dayName: 'Thu', tempMax: 31, tempMin: 25, condition: { main: 'Clear', description: 'Sunny & bright', icon: 'clear', code: 'clear' }, precipitationProbability: 10, precipitationAmountMm: 0.0, windSpeed: 10, uvIndex: 9, sunrise: '06:14 AM', sunset: '06:43 PM' },
      { date: '2026-08-25', dayName: 'Fri', tempMax: 30, tempMin: 24, condition: { main: 'Partly Cloudy', description: 'Pleasant evening breeze', icon: 'partly-cloudy', code: 'partly_cloudy' }, precipitationProbability: 25, precipitationAmountMm: 0.8, windSpeed: 12, uvIndex: 8, sunrise: '06:14 AM', sunset: '06:42 PM' },
    ];
  }

  async getWeatherAlerts(lat = 15.4989, lng = 73.7725): Promise<WeatherAlertItem[]> {
    return [
      {
        id: 'alert-monsoon-1',
        title: 'Heavy Rainfall Warning',
        description: 'Heavy monsoon showers expected between 02:00 PM and 05:00 PM. High precipitation may affect outdoor activities.',
        severity: 'warning',
        startTime: '2026-08-22T14:00:00Z',
        endTime: '2026-08-22T17:00:00Z',
        source: 'India Meteorological Department (IMD)',
      },
    ];
  }

  async getTripWeather(tripId: string) {
    const current = await this.getCurrentWeather();
    const hourly = await this.getHourlyForecast();
    const daily = await this.getDailyForecast();
    const alerts = await this.getWeatherAlerts();

    return {
      tripId,
      destination: 'Goa, India',
      current,
      hourly,
      daily,
      alerts,
      updatedAt: new Date().toISOString(),
    };
  }
}
