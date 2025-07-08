class Weather {
  const Weather({required this.date, required this.maxTemp, required this.minTemp});
  final List<dynamic> date;
  final List<dynamic> maxTemp;
  final List<dynamic> minTemp;
  factory Weather.fromJson(Map<String, Object?> json) => Weather(date: json['time'] as List<dynamic>, maxTemp: json['apparent_temperature_max']as List<dynamic>, minTemp: json['apparent_temperature_min'] as List<dynamic>);
  @override
  String toString() => "Current Date: ${date[0]}\nHigh of ${maxTemp[0]} degrees Fahrenheit and a Low of ${minTemp[0]} degrees Fahrenheit";
}