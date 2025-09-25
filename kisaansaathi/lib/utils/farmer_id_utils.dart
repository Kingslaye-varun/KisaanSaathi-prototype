class FarmerIdUtils {
  /// Masks a farmer ID by showing only the first 2 characters (state code) 
  /// and last 4 digits, replacing the rest with asterisks
  static String maskFarmerId(String? farmerId) {
    if (farmerId == null || farmerId.isEmpty) {
      return '';
    }
    
    if (farmerId.length < 6) {
      return farmerId; // Too short to mask properly
    }
    
    // Extract state code (first 2 chars) and last 4 digits
    String stateCode = farmerId.substring(0, 2);
    String lastFourDigits = farmerId.substring(farmerId.length - 4);
    
    // Create masked version with asterisks in between
    return '$stateCode${'*' * 6}$lastFourDigits';
  }
  
  /// Checks if a farmer ID is valid (KL + 12 digits)
  static bool isValidFarmerId(String? farmerId) {
    if (farmerId == null || farmerId.isEmpty) {
      return false;
    }
    
    return RegExp(r'^KL\d{12}$').hasMatch(farmerId);
  }
}