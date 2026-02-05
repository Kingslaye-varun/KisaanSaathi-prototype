class DataSourceInfo {
  final String name;
  final String url;
  final String description;
  final bool isGovernmentVerified;
  final String category;

  DataSourceInfo({
    required this.name,
    required this.url,
    required this.description,
    required this.isGovernmentVerified,
    required this.category,
  });
}

class DataSourceService {
  // Official Government Data Sources
  static final Map<String, DataSourceInfo> dataSources = {
    'market_prices': DataSourceInfo(
      name: 'data.gov.in - Agmarknet',
      url: 'https://data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070',
      description: 'Official market prices from Agricultural Marketing Department',
      isGovernmentVerified: true,
      category: 'Market Data',
    ),
    'weather': DataSourceInfo(
      name: 'OpenWeatherMap API',
      url: 'https://openweathermap.org',
      description: 'Real-time weather data from commercial API',
      isGovernmentVerified: false,
      category: 'Weather',
    ),
    'imd_weather': DataSourceInfo(
      name: 'India Meteorological Department',
      url: 'https://mausam.imd.gov.in',
      description: 'Official weather forecasts and alerts from IMD',
      isGovernmentVerified: true,
      category: 'Weather',
    ),
    'government_schemes': DataSourceInfo(
      name: 'National Portal of India',
      url: 'https://www.india.gov.in',
      description: 'Official government schemes and programs',
      isGovernmentVerified: true,
      category: 'Schemes',
    ),
    'pmkisan': DataSourceInfo(
      name: 'PM-KISAN Portal',
      url: 'https://pmkisan.gov.in',
      description: 'Pradhan Mantri Kisan Samman Nidhi Yojana',
      isGovernmentVerified: true,
      category: 'Schemes',
    ),
    'soil_health': DataSourceInfo(
      name: 'Soil Health Card Portal',
      url: 'https://soilhealth.dac.gov.in',
      description: 'Department of Agriculture & Cooperation',
      isGovernmentVerified: true,
      category: 'Soil',
    ),
    'enam': DataSourceInfo(
      name: 'National Agriculture Market (eNAM)',
      url: 'https://enam.gov.in',
      description: 'Unified national agriculture market platform',
      isGovernmentVerified: true,
      category: 'Market Data',
    ),
    'agrimarket': DataSourceInfo(
      name: 'Agri-Market Intelligence',
      url: 'https://agmarknet.gov.in',
      description: 'Agricultural marketing information network',
      isGovernmentVerified: true,
      category: 'Market Data',
    ),
    'kisan_suvidha': DataSourceInfo(
      name: 'Kisan Suvidha Portal',
      url: 'https://kisansuvidha.gov.in',
      description: 'Farmer welfare and information portal',
      isGovernmentVerified: true,
      category: 'General',
    ),
    'crop_insurance': DataSourceInfo(
      name: 'PM Fasal Bima Yojana',
      url: 'https://pmfby.gov.in',
      description: 'Crop insurance scheme portal',
      isGovernmentVerified: true,
      category: 'Insurance',
    ),
    'mandi_prices': DataSourceInfo(
      name: 'Mandi Prices - data.gov.in',
      url: 'https://data.gov.in/catalog/mandi-prices',
      description: 'Daily mandi prices across India',
      isGovernmentVerified: true,
      category: 'Market Data',
    ),
    'krishi_vigyan': DataSourceInfo(
      name: 'Krishi Vigyan Kendra',
      url: 'https://kvk.icar.gov.in',
      description: 'Agricultural extension services',
      isGovernmentVerified: true,
      category: 'Education',
    ),
  };

  static DataSourceInfo? getSource(String key) {
    return dataSources[key];
  }

  static List<DataSourceInfo> getAllSources() {
    return dataSources.values.toList();
  }

  static List<DataSourceInfo> getSourcesByCategory(String category) {
    return dataSources.values
        .where((source) => source.category == category)
        .toList();
  }

  static List<DataSourceInfo> getVerifiedSources() {
    return dataSources.values
        .where((source) => source.isGovernmentVerified)
        .toList();
  }
}
