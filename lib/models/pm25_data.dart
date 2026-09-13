class Pm25Simple {
  final double pm25;
  final int aqi;
  final String category;
  final double confidence;

  Pm25Simple({
    required this.pm25,
    required this.aqi,
    required this.category,
    required this.confidence,
  });

  factory Pm25Simple.fromJson(Map<String, dynamic> json) {
    return Pm25Simple(
      pm25: (json['pm25'] as num?)?.toDouble() ?? 0.0,
      aqi: (json['aqi'] as num?)?.toInt() ?? 0,
      category: json['category']?.toString() ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ForecastHour {
  final String hour;
  final double pm25;
  final int aqi;

  ForecastHour({
    required this.hour,
    required this.pm25,
    required this.aqi,
  });

  factory ForecastHour.fromJson(Map<String, dynamic> json) {
    return ForecastHour(
      hour: json['time']?.toString() ?? json['hour']?.toString() ?? '',
      pm25: (json['pm25'] as num?)?.toDouble() ?? 0.0,
      aqi: (json['aqi'] as num?)?.toInt() ?? 0,
    );
  }
}

class Attribution {
  final double fire;
  final double traffic;
  final double crossBorder;
  final double background;

  Attribution({
    required this.fire,
    required this.traffic,
    required this.crossBorder,
    required this.background,
  });

  factory Attribution.fromJson(Map<String, dynamic> json) {
    return Attribution(
      fire: (json['fire'] as num?)?.toDouble() ?? 0.0,
      traffic: (json['traffic'] as num?)?.toDouble() ?? 0.0,
      crossBorder: (json['cross_border'] as num?)?.toDouble() ?? 0.0,
      background: (json['background'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class Pm25Detail {
  final double pm25Value;
  final String pm25Unit;
  final double pm25Confidence;
  final int pm25SourcesUsed;
  
  final int aqiUs;
  final String aqiCategory;
  
  final Attribution attribution;
  final List<ForecastHour> forecastHourly;
  
  final double windSpeed;
  final double windDirection;

  Pm25Detail({
    required this.pm25Value,
    required this.pm25Unit,
    required this.pm25Confidence,
    required this.pm25SourcesUsed,
    required this.aqiUs,
    required this.aqiCategory,
    required this.attribution,
    required this.forecastHourly,
    required this.windSpeed,
    required this.windDirection,
  });

  factory Pm25Detail.fromJson(Map<String, dynamic> json) {
    final pm25 = json['pm25'] as Map<String, dynamic>? ?? {};
    final aqi = json['aqi'] as Map<String, dynamic>? ?? {};
    final attribution = json['attribution'] as Map<String, dynamic>? ?? {};
    final forecast = json['forecast'] as Map<String, dynamic>? ?? {};
    final hourly = forecast['hourly'] as List<dynamic>? ?? [];
    final calculation = json['calculation'] as Map<String, dynamic>? ?? {};

    return Pm25Detail(
      pm25Value: (pm25['value'] as num?)?.toDouble() ?? 0.0,
      pm25Unit: pm25['unit']?.toString() ?? '',
      pm25Confidence: (pm25['confidence'] as num?)?.toDouble() ?? 0.0,
      pm25SourcesUsed: (pm25['sources_used'] is List) ? (pm25['sources_used'] as List).length : ((pm25['sources_used'] as num?)?.toInt() ?? 0),
      aqiUs: (aqi['us'] as num?)?.toInt() ?? 0,
      aqiCategory: aqi['category']?.toString() ?? '',
      attribution: Attribution.fromJson(attribution),
      forecastHourly: hourly.map((e) => ForecastHour.fromJson(e as Map<String, dynamic>)).toList(),
      windSpeed: (calculation['wind_speed'] as num?)?.toDouble() ?? 0.0,
      windDirection: (calculation['wind_direction'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
