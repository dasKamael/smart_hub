/// What the sky does, simplified from the WMO weather codes.
enum WeatherCondition {
  clear,
  partlyCloudy,
  cloudy,
  fog,
  drizzle,
  rain,
  snow,
  thunderstorm;

  bool get isWet => this == drizzle || this == rain || this == snow || this == thunderstorm;
}
