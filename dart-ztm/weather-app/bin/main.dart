import 'dart:io';

import 'weather_api_client.dart';

void main(List<String> arg) async {
  if (arg.length != 1) {
    print("Syntax: dart bin/main.dart <city>");
    return;
  }
  final city = arg.first;
  final api = WeatherApiClient();
  try {
  final weather = await api.getLocationId(city);
  print(weather);
  } on WeatherApiException catch (e) {
    print(e.message);
  } on SocketException catch (_) {
    print("Could not fetch data. Check your connection");
  } catch (e) {
    print(e);
  }
}