class EnvConfig {
  // API URLs
  static const String flaskApiUrl = String.fromEnvironment(
    'FLASK_API_URL',
    defaultValue: 'https://kisaansaathi-flask.onrender.com',
  );
  
  static const String nodeApiUrl = String.fromEnvironment(
    'NODE_API_URL',
    defaultValue: 'https://kisaansaathi-backend.onrender.com',
  );
}