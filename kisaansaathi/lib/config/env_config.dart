class EnvConfig {
  // API URLs
  static const String flaskApiUrl = String.fromEnvironment(
    'FLASK_API_URL',
    defaultValue: 'http://10.99.111.180:5000',
  );
  
  static const String nodeApiUrl = String.fromEnvironment(
    'NODE_API_URL',
    defaultValue: 'https://kisaansaathi-backend-sq7f.onrender.com',
  );
}