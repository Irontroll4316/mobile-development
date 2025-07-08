import 'package:http/http.dart' as http;
import 'dart:convert';
import 'weather.dart';

class WeatherApiException implements Exception {
  const WeatherApiException(this.message);
   final String message;
}

class WeatherApiClient {
  static const weatherbaseUrl = 'https://api.open-meteo.com';
  static const geolocationbaseUrl = 'https://geocoding-api.open-meteo.com';

  Future<Weather> getLocationId(String city) async {
    // Get the latitude and longitude coordinates from geocoding-api
    final geolocationUrl = Uri.parse("$geolocationbaseUrl/v1/search?name=$city");
    final geoResponse = await http.get(geolocationUrl);
    if (geoResponse.statusCode != 200) {
      throw WeatherApiException("Error getting latitude and longitude for city: $city");
    }
    final geoData = jsonDecode(geoResponse.body);
    if (geoData.length <= 1) {
      throw WeatherApiException("No location found for $city");
    }
    final latitude = geoData['results'][1]['latitude'];
    final longitude = geoData['results'][1]['longitude'];

    // Get the weather data from open-meteo api
    final locationUrl = Uri.parse('$weatherbaseUrl/v1/forecast?latitude=$latitude&longitude=$longitude&temperature_unit=fahrenheit&daily=apparent_temperature_max,apparent_temperature_min'); 
    final locationResponse = await http.get(locationUrl);
    if (locationResponse.statusCode != 200) {
      throw WeatherApiException("Error getting weather for city: $city");
    }
    if (locationResponse.body.isEmpty) {
      throw WeatherApiException("Weather data not avaiable for coordinates $latitude, $longitude");
    }
    final weatherJson = jsonDecode(locationResponse.body);
    final dailyWeather = weatherJson['daily'];
    return Weather.fromJson(dailyWeather);
  }
}