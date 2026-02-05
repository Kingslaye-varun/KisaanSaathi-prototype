import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? AppLocalizations(const Locale('en'));
  }
  
  // Crop Recommendation Screen Strings
  String get tellUsAboutYourFarm {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'നിങ്ങളുടെ കൃഷിയെക്കുറിച്ച് ഞങ്ങളോട് പറയൂ';
      case 'kn': // Kannada
        return 'ನಿಮ್ಮ ಕೃಷಿಯ ಬಗ್ಗೆ ನಮಗೆ ತಿಳಿಸಿ';
      case 'hi': // Hindi
        return 'अपने खेत के बारे में हमें बताएं';
      case 'pa': // Punjabi
        return 'ਆਪਣੇ ਖੇਤ ਬਾਰੇ ਸਾਨੂੰ ਦੱਸੋ';
      case 'bn': // Bengali
        return 'আপনার খামার সম্পর্কে আমাদের বলুন';
      case 'gu': // Gujarati
        return 'તમારા ખેતર વિશે અમને જણાવો';
      case 'mr': // Marathi
        return 'तुमच्या शेताबद्दल आम्हाला सांगा';
      case 'te': // Telugu
        return 'మీ పొలం గురించి మాకు చెప్పండి';
      case 'ta': // Tamil
        return 'உங்கள் பண்ணை பற்றி எங்களிடம் சொல்லுங்கள்';
      case 'en': // English
        return 'Tell us about your farm';
      default:
        return 'Tell us about your farm';
    }
  }
  
  String get whatTypeOfCrops {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'എന്ത് തരം വിളകളാണ് നിങ്ങൾക്ക് വേണ്ടത്?';
      case 'kn': // Kannada
        return 'ನಿಮಗೆ ಯಾವ ರೀತಿಯ ಬೆಳೆಗಳು ಬೇಕು?';
      case 'hi': // Hindi
        return 'आपको किस प्रकार की फसलें चाहिए?';
      case 'pa': // Punjabi
        return 'ਤੁਹਾਨੂੰ ਕਿਸ ਕਿਸਮ ਦੀਆਂ ਫਸਲਾਂ ਚਾਹੀਦੀਆਂ ਹਨ?';
      case 'bn': // Bengali
        return 'আপনি কি ধরনের ফসল চান?';
      case 'gu': // Gujarati
        return 'તમને કયા પ્રકારના પાક જોઈએ છે?';
      case 'mr': // Marathi
        return 'तुम्हाला कोणत्या प्रकारची पिके हवी आहेत?';
      case 'te': // Telugu
        return 'మీకు ఏ రకమైన పంటలు కావాలి?';
      case 'ta': // Tamil
        return 'உங்களுக்கு எந்த வகையான பயிர்கள் வேண்டும்?';
      case 'en': // English
        return 'What type of crops do you want?';
      default:
        return 'What type of crops do you want?';
    }
  }
  
  String get howToGrow {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'എങ്ങനെ വളർത്താം';
      case 'kn': // Kannada
        return 'ಹೇಗೆ ಬೆಳೆಸುವುದು';
      case 'hi': // Hindi
        return 'कैसे उगाएं';
      case 'pa': // Punjabi
        return 'ਕਿਵੇਂ ਉਗਾਉਣਾ ਹੈ';
      case 'bn': // Bengali
        return 'কিভাবে চাষ করবেন';
      case 'gu': // Gujarati
        return 'કેવી રીતે ઉગાડવું';
      case 'mr': // Marathi
        return 'कसे वाढवावे';
      case 'te': // Telugu
        return 'ఎలా పెంచాలి';
      case 'ta': // Tamil
        return 'எப்படி வளர்ப்பது';
      case 'en': // English
        return 'How to Grow';
      default:
        return 'How to Grow';
    }
  }
  
  String get moneyMatters {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'സാമ്പത്തിക കാര്യങ്ങൾ';
      case 'kn': // Kannada
        return 'ಹಣಕಾಸು ವಿಷಯಗಳು';
      case 'hi': // Hindi
        return 'आर्थिक मामले';
      case 'pa': // Punjabi
        return 'ਵਿੱਤੀ ਮਾਮਲੇ';
      case 'bn': // Bengali
        return 'অর্থনৈতিক বিষয়';
      case 'gu': // Gujarati
        return 'નાણાકીય બાબતો';
      case 'mr': // Marathi
        return 'आर्थिक बाबी';
      case 'te': // Telugu
        return 'ఆర్థిక విషయాలు';
      case 'ta': // Tamil
        return 'பண விவகாரங்கள்';
      case 'en': // English
        return 'Money Matters';
      default:
        return 'Money Matters';
    }
  }
  
  String get extraBenefits {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'അധിക ആനുകൂല്യങ്ങൾ';
      case 'kn': // Kannada
        return 'ಹೆಚ್ಚುವರಿ ಪ್ರಯೋಜನಗಳು';
      case 'hi': // Hindi
        return 'अतिरिक्त लाभ';
      case 'pa': // Punjabi
        return 'ਵਾਧੂ ਲਾਭ';
      case 'bn': // Bengali
        return 'অতিরিক্ত সুবিধা';
      case 'gu': // Gujarati
        return 'વધારાના લાભો';
      case 'mr': // Marathi
        return 'अतिरिक्त फायदे';
      case 'te': // Telugu
        return 'అదనపు ప్రయోజనాలు';
      case 'ta': // Tamil
        return 'கூடுதல் நன்மைகள்';
      case 'en': // English
        return 'Extra Benefits';
      default:
        return 'Extra Benefits';
    }
  }
  
  String get locationAccessNeeded {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'മികച്ച ശുപാർശകൾക്കായി ലൊക്കേഷൻ ആക്സസ് ആവശ്യമാണ്';
      case 'kn': // Kannada
        return 'ಉತ್ತಮ ಶಿಫಾರಸುಗಳಿಗಾಗಿ ಸ್ಥಳ ಪ್ರವೇಶ ಅಗತ್ಯವಿದೆ';
      case 'hi': // Hindi
        return 'बेहतर सिफारिशों के लिए स्थान का उपयोग आवश्यक है';
      case 'pa': // Punjabi
        return 'ਵਧੀਆ ਸਿਫਾਰਸ਼ਾਂ ਲਈ ਸਥਾਨ ਤੱਕ ਪਹੁੰਚ ਦੀ ਲੋੜ ਹੈ';
      case 'bn': // Bengali
        return 'সেরা সুপারিশের জন্য অবস্থান অ্যাক্সেস প্রয়োজন';
      case 'gu': // Gujarati
        return 'શ્રેષ્ઠ ભલામણો માટે સ્થાન ઍક્સેસની જરૂર છે';
      case 'mr': // Marathi
        return 'सर्वोत्तम शिफारसींसाठी स्थान अ‍ॅक्सेस आवश्यक आहे';
      case 'te': // Telugu
        return 'ఉత్తమ సిఫార్సుల కోసం స్థాన యాక్సెస్ అవసరం';
      case 'ta': // Tamil
        return 'சிறந்த பரிந்துரைகளுக்கு இருப்பிட அணுகல் தேவை';
      case 'en': // English
        return 'Location access needed for best recommendations';
      default:
        return 'Location access needed for best recommendations';
    }
  }
  
  String get enableLocationForCrops {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'വിള നിർദ്ദേശങ്ങൾക്കായി ലൊക്കേഷൻ പ്രവർത്തനക്ഷമമാക്കുക';
      case 'kn': // Kannada
        return 'ಬೆಳೆ ಸಲಹೆಗಳಿಗಾಗಿ ಸ್ಥಳವನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಿ';
      case 'hi': // Hindi
        return 'फसल सुझावों के लिए स्थान सक्षम करें';
      case 'pa': // Punjabi
        return 'ਫਸਲ ਸੁਝਾਵਾਂ ਲਈ ਸਥਾਨ ਨੂੰ ਸਮਰੱਥ ਬਣਾਓ';
      case 'bn': // Bengali
        return 'ফসলের পরামর্শের জন্য অবস্থান সক্ষম করুন';
      case 'gu': // Gujarati
        return 'પાક સૂચનો માટે સ્થાન સક્ષમ કરો';
      case 'mr': // Marathi
        return 'पीक सूचनांसाठी स्थान सक्षम करा';
      case 'te': // Telugu
        return 'పంట సూచనల కోసం స్థానాన్ని ప్రారంభించండి';
      case 'ta': // Tamil
        return 'பயிர் பரிந்துரைகளுக்கு இருப்பிடத்தை இயக்கவும்';
      case 'en': // English
        return 'Please enable location for crop suggestions';
      default:
        return 'Please enable location for crop suggestions';
    }
  }
  
  String get weatherDataUnavailable {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'കാലാവസ്ഥാ ഡാറ്റ ലഭ്യമല്ല';
      case 'kn': // Kannada
        return 'ಹವಾಮಾನ ಡೇಟಾ ಲಭ್ಯವಿಲ್ಲ';
      case 'hi': // Hindi
        return 'मौसम डेटा अनुपलब्ध';
      case 'pa': // Punjabi
        return 'ਮੌਸਮ ਡਾਟਾ ਉਪਲਬਧ ਨਹੀਂ';
      case 'bn': // Bengali
        return 'আবহাওয়া ডেটা অনুপলব্ধ';
      case 'gu': // Gujarati
        return 'હવામાન ડેટા અનુપલબ્ધ';
      case 'mr': // Marathi
        return 'हवामान डेटा अनुपलब्ध';
      case 'te': // Telugu
        return 'వాతావరణ డేటా అందుబాటులో లేదు';
      case 'ta': // Tamil
        return 'வானிலை தரவு கிடைக்கவில்லை';
      case 'en': // English
        return 'Weather data unavailable';
      default:
        return 'Weather data unavailable';
    }
  }
  
  String get getRecommendations {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ശുപാർശകൾ നേടുക';
      case 'kn': // Kannada
        return 'ಶಿಫಾರಸುಗಳನ್ನು ಪಡೆಯಿರಿ';
      case 'hi': // Hindi
        return 'सिफारिशें प्राप्त करें';
      case 'pa': // Punjabi
        return 'ਸਿਫਾਰਸ਼ਾਂ ਪ੍ਰਾਪਤ ਕਰੋ';
      case 'bn': // Bengali
        return 'সুপারিশ পান';
      case 'gu': // Gujarati
        return 'ભલામણો મેળવો';
      case 'mr': // Marathi
        return 'शिफारसी मिळवा';
      case 'te': // Telugu
        return 'సిఫార్సులను పొందండి';
      case 'ta': // Tamil
        return 'பரிந்துரைகளைப் பெறுங்கள்';
      case 'en': // English
        return 'Get Recommendations';
      default:
        return 'Get Recommendations';
    }
  }
  
  String get recommendedCrops {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'നിങ്ങൾക്കായി ശുപാർശ ചെയ്യുന്ന വിളകൾ:';
      case 'kn': // Kannada
        return 'ನಿಮಗಾಗಿ ಶಿಫಾರಸು ಮಾಡಲಾದ ಬೆಳೆಗಳು:';
      case 'hi': // Hindi
        return 'आपके लिए अनुशंसित फसलें:';
      case 'pa': // Punjabi
        return 'ਤੁਹਾਡੇ ਲਈ ਸਿਫਾਰਸ਼ ਕੀਤੀਆਂ ਫਸਲਾਂ:';
      case 'bn': // Bengali
        return 'আপনার জন্য প্রস্তাবিত ফসল:';
      case 'gu': // Gujarati
        return 'તમારા માટે ભલામણ કરેલ પાકો:';
      case 'mr': // Marathi
        return 'तुमच्यासाठी शिफारस केलेली पिके:';
      case 'te': // Telugu
        return 'మీకు సిఫార్సు చేయబడిన పంటలు:';
      case 'ta': // Tamil
        return 'உங்களுக்கான பரிந்துரைக்கப்பட்ட பயிர்கள்:';
      case 'en': // English
        return 'Recommended Crops for You:';
      default:
        return 'Recommended Crops for You:';
    }
  }

String get lessThan1Acre {
  switch (locale.languageCode) {
    case 'ml': return '1 ഏക്കറിൽ താഴെ';
    case 'kn': return '1 ಎಕರೆಗಿಂತ ಕಡಿಮೆ';
    case 'hi': return '1 एकड़ से कम';
    case 'pa': return '1 ਏਕੜ ਤੋਂ ਘੱਟ';
    case 'bn': return '১ একরের কম';
    case 'gu': return '1 એકરથી ઓછું';
    case 'mr': return '1 एकरपेक्षा कमी';
    case 'te': return '1 ఎకరా కంటే తక్కువ';
    case 'ta': return '1 ஏக்கருக்கு குறைவாக';
    case 'en': return 'Less than 1 Acre';
    default: return 'Less than 1 Acre';
  }
}

String get oneToFiveAcres {
  switch (locale.languageCode) {
    case 'ml': return '1 മുതൽ 5 ഏക്കർ വരെ';
    case 'kn': return '1 ರಿಂದ 5 ಎಕರೆಗಳವರೆಗೆ';
    case 'hi': return '1 से 5 एकड़ तक';
    case 'pa': return '1 ਤੋਂ 5 ਏਕੜ ਤੱਕ';
    case 'bn': return '১ থেকে ৫ একর পর্যন্ত';
    case 'gu': return '1 થી 5 એકર સુધી';
    case 'mr': return '1 ते 5 एकरांपर्यंत';
    case 'te': return '1 నుండి 5 ఎకరాల వరకు';
    case 'ta': return '1 முதல் 5 ஏக்கர் வரை';
    case 'en': return '1 to 5 Acres';
    default: return '1 to 5 Acres';
  }
}

String get fiveToTenAcres {
  switch (locale.languageCode) {
    case 'ml': return '5 മുതൽ 10 ഏക്കർ വരെ';
    case 'kn': return '5 ರಿಂದ 10 ಎಕರೆಗಳವರೆಗೆ';
    case 'hi': return '5 से 10 एकड़ तक';
    case 'pa': return '5 ਤੋਂ 10 ਏਕੜ ਤੱਕ';
    case 'bn': return '৫ থেকে ১০ একর পর্যন্ত';
    case 'gu': return '5 થી 10 એકર સુધી';
    case 'mr': return '5 ते 10 एकरांपर्यंत';
    case 'te': return '5 నుండి 10 ఎకరాల వరకు';
    case 'ta': return '5 முதல் 10 ஏக்கர் வரை';
    case 'en': return '5 to 10 Acres';
    default: return '5 to 10 Acres';
  }
}

String get moreThanTenAcres {
  switch (locale.languageCode) {
    case 'ml': return '10 ഏക്കറിൽ കൂടുതൽ';
    case 'kn': return '10 ಎಕರೆಗಿಂತ ಹೆಚ್ಚು';
    case 'hi': return '10 एकड़ से अधिक';
    case 'pa': return '10 ਏਕੜ ਤੋਂ ਵੱਧ';
    case 'bn': return '১০ একরের বেশি';
    case 'gu': return '10 એકરથી વધુ';
    case 'mr': return '10 एकरांपेक्षा जास्त';
    case 'te': return '10 ఎకరాలకు మించి';
    case 'ta': return '10 ஏக்கருக்கு மேல்';
    case 'en': return 'More than 10 Acres';
    default: return 'More than 10 Acres';
  }
}

String get good {
  switch (locale.languageCode) {
    case 'ml': return 'നല്ലത്';
    case 'kn': return 'ಉತ್ತಮ';
    case 'hi': return 'अच्छा';
    case 'pa': return 'ਵਧੀਆ';
    case 'bn': return 'ভালো';
    case 'gu': return 'સારું';
    case 'mr': return 'चांगले';
    case 'te': return 'మంచిది';
    case 'ta': return 'நன்று';
    case 'en': return 'Good';
    default: return 'Good';
  }
}

String get moderate {
  switch (locale.languageCode) {
    case 'ml': return 'മിതമായത്';
    case 'kn': return 'ಮಧ್ಯಮ';
    case 'hi': return 'मध्यम';
    case 'pa': return 'ਦਰਮਿਆਨਾ';
    case 'bn': return 'মধ্যম';
    case 'gu': return 'મધ્યમ';
    case 'mr': return 'मध्यम';
    case 'te': return 'మోస్తరు';
    case 'ta': return 'மிதமானது';
    case 'en': return 'Moderate';
    default: return 'Moderate';
  }
}

String get limited {
  switch (locale.languageCode) {
    case 'ml': return 'പരിമിതമായത്';
    case 'kn': return 'ಸೀಮಿತ';
    case 'hi': return 'सीमित';
    case 'pa': return 'ਸੀਮਿਤ';
    case 'bn': return 'সীমিত';
    case 'gu': return 'મર્યાદિત';
    case 'mr': return 'मर्यादित';
    case 'te': return 'పరిమితమైన';
    case 'ta': return 'குறைக்கப்பட்ட';
    case 'en': return 'Limited';
    default: return 'Limited';
  }
}

String get budgetHint {
  switch (locale.languageCode) {
    case 'ml': // Malayalam
      return 'തുക നൽകുക (ഐച്ഛികം)';
    case 'kn': // Kannada
      return 'ಮೊತ್ತವನ್ನು ನಮೂದಿಸಿ (ಐಚ್ಛಿಕ)';
    case 'hi': // Hindi
      return 'राशि दर्ज करें (वैकल्पिक)';
    case 'pa': // Punjabi
      return 'ਰਕਮ ਦਰਜ ਕਰੋ (ਵਿਕਲਪਿਕ)';
    case 'bn': // Bengali
      return 'পরিমাণ লিখুন (ঐচ্ছিক)';
    case 'gu': // Gujarati
      return 'રકમ દાખલ કરો (વૈકલ્પિક)';
    case 'mr': // Marathi
      return 'रक्कम प्रविष्ट करा (पर्यायी)';
    case 'te': // Telugu
      return 'మొత్తాన్ని నమోదు చేయండి (ఐచ్ఛికం)';
    case 'ta': // Tamil
      return 'தொகையை உள்ளிடவும் (விருப்பம்)';
    case 'en': // English
    default:
      return 'Enter Amount (optional)';
  }
}

  
  // Fertilizer Recommendation Screen Strings
  String get fertilizerGuide {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'വളം ഗൈഡ്';
      case 'kn': // Kannada
        return 'ರಸಗೊಬ್ಬರ ಮಾರ್ಗದರ್ಶಿ';
      case 'hi': // Hindi
        return 'उर्वरक गाइड';
      case 'pa': // Punjabi
        return 'ਖਾਦ ਗਾਈਡ';
      case 'bn': // Bengali
        return 'সার গাইড';
      case 'gu': // Gujarati
        return 'ખાતર માર્ગદર્શિકા';
      case 'mr': // Marathi
        return 'खत मार्गदर्शक';
      case 'te': // Telugu
        return 'ఎరువుల గైడ్';
      case 'ta': // Tamil
        return 'உர வழிகாட்டி';
      case 'en': // English
        return 'Fertilizer Guide';
      default:
        return 'Fertilizer Guide';
    }
  }
  
  String get selectYourCrop {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'നിങ്ങളുടെ വിള തിരഞ്ഞെടുക്കുക';
      case 'kn': // Kannada
        return 'ನಿಮ್ಮ ಬೆಳೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ';
      case 'hi': // Hindi
        return 'अपनी फसल चुनें';
      case 'pa': // Punjabi
        return 'ਆਪਣੀ ਫਸਲ ਚੁਣੋ';
      case 'bn': // Bengali
        return 'আপনার ফসল নির্বাচন করুন';
      case 'gu': // Gujarati
        return 'તમારો પાક પસંદ કરો';
      case 'mr': // Marathi
        return 'तुमची पीक निवडा';
      case 'te': // Telugu
        return 'మీ పంటను ఎంచుకోండి';
      case 'ta': // Tamil
        return 'உங்கள் பயிரைத் தேர்ந்தெடுக்கவும்';
      case 'en': // English
        return 'Select Your Crop';
      default:
        return 'Select Your Crop';
    }
  }
  
  String get selectSoilType {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'മണ്ണിന്റെ തരം തിരഞ്ഞെടുക്കുക';
      case 'kn': // Kannada
        return 'ಮಣ್ಣಿನ ಪ್ರಕಾರವನ್ನು ಆಯ್ಕೆಮಾಡಿ';
      case 'hi': // Hindi
        return 'मिट्टी का प्रकार चुनें';
      case 'pa': // Punjabi
        return 'ਮਿੱਟੀ ਦੀ ਕਿਸਮ ਚੁਣੋ';
      case 'bn': // Bengali
        return 'মাটির ধরন নির্বাচন করুন';
      case 'gu': // Gujarati
        return 'જમીનનો પ્રકાર પસંદ કરો';
      case 'mr': // Marathi
        return 'मातीचा प्रकार निवडा';
      case 'te': // Telugu
        return 'నేల రకాన్ని ఎంచుకోండి';
      case 'ta': // Tamil
        return 'மண் வகையைத் தேர்ந்தெடுக்கவும்';
      case 'en': // English
        return 'Select Soil Type';
      default:
        return 'Select Soil Type';
    }
  }

  
  String get getFertilizerRecommendation {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'വള ശുപാർശ നേടുക';
      case 'kn': // Kannada
        return 'ರಸಗೊಬ್ಬರ ಶಿಫಾರಸನ್ನು ಪಡೆಯಿರಿ';
      case 'hi': // Hindi
        return 'उर्वरक अनुशंसा प्राप्त करें';
      case 'pa': // Punjabi
        return 'ਖਾਦ ਸਿਫਾਰਸ਼ ਪ੍ਰਾਪਤ ਕਰੋ';
      case 'bn': // Bengali
        return 'সার সুপারিশ পান';
      case 'gu': // Gujarati
        return 'ખાતર ભલામણ મેળવો';
      case 'mr': // Marathi
        return 'खत शिफारस मिळवा';
      case 'te': // Telugu
        return 'ఎరువుల సిఫార్సును పొందండి';
      case 'ta': // Tamil
        return 'உர பரிந்துரையைப் பெறுங்கள்';
      case 'en': // English
        return 'Get Fertilizer Recommendation';
      default:
        return 'Get Fertilizer Recommendation';
    }
  }
  
  String get newsScreen {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'വാർത്തകൾ';
      case 'kn': // Kannada
        return 'ಸುದ್ದಿ';
      case 'hi':
        return 'समाचार';
      case 'pa':
        return 'ਖ਼ਬਰ';
      case 'bn':
        return 'সংবাদ';
      case 'gu':
        return 'સમાચાર';
      case 'mr':
        return 'बातम्या';
      case 'te':
        return 'వార్తలు';
      case 'ta':
        return 'செய்திகள்';
      case 'en':
        return 'News';
      default:
        return 'News'; // Default fallback value
    }
  }

  String get takePhoto {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'മൊത്ത് φω്ടോ';
      case 'kn': // Kannada
        return 'ಕೋಟ್ φω್ಟೊ';
      case 'hi': // Hindi
        return 'फोटो लें';
      case 'pa': // Punjabi
        return 'ਫੋਟੋ ਲੇਨੋ';
      case 'bn': // Bengali
        return 'ফটো লেন';
      case 'gu': // Gujarati
        return 'ફોટો લેં';
      case 'mr': // Marathi
        return 'फोटो लेन';
      case 'te': // Telugu
        return 'ఫొటో లెను';
      case 'ta': // Tamil
        return 'படிமை எடுத்துக் கொள்ளுங்கள்';
      case 'en': // English
        return 'Take Photo';
      default:
        return 'Take Photo'; // Default fallback value
    }
  }

  String get chooseFromGallery {
  switch (locale.languageCode) {
    case 'ml': return 'ഗാലറിയിൽ നിന്ന് തിരഞ്ഞെടുക്കുക'; // Malayalam
    case 'kn': return 'ಗ್ಯಾಲರಿಯಿಂದ ಆಯ್ಕೆಮಾಡಿ'; // Kannada
    case 'hi': return 'गैलरी से चुनें'; // Hindi
    case 'pa': return 'ਗੈਲਰੀ ਵਿਚੋਂ ਚੁਣੋ'; // Punjabi
    case 'bn': return 'গ্যালারি থেকে বেছে নিন'; // Bengali
    case 'gu': return 'ગેલેરીમાંથી પસંદ કરો'; // Gujarati
    case 'mr': return 'गॅलरीतून निवडा'; // Marathi
    case 'te': return 'గ్యాలరీ నుండి ఎంచుకోండి'; // Telugu
    case 'ta': return 'கேலரியிலிருந்து தேர்ந்தெடுக்கவும்'; // Tamil
    default: return 'Choose from Gallery';
  }
}

  String get plantDiseaseDetection {
  switch (locale.languageCode) {
    case 'ml': return 'സസ്യരോഗം കണ്ടെത്തൽ';
    case 'kn': return 'ಸಸ್ಯರೋಗ ಪತ್ತೆಹಚ್ಚು';
    case 'hi': return 'पौधों की बीमारी का पता लगाएं';
    case 'pa': return 'ਪੌਦੇ ਦੀ ਬਿਮਾਰੀ ਦੀ ਪਛਾਣ';
    case 'bn': return 'উদ্ভিদের রোগ শনাক্তকরণ';
    case 'gu': return 'વનસ્પતિ રોગ શોધ';
    case 'mr': return 'वनस्पती रोग शोध';
    case 'te': return 'మొక్కల వ్యాధి గుర్తింపు';
    case 'ta': return 'தாவர நோய் கண்டறிதல்';
    default: return 'Plant Disease Detection';
  }
}

  String get tapToSelectPlantImage {
  switch (locale.languageCode) {
    case 'ml': return 'സസ്യത്തിന്റെ ചിത്രം തിരഞ്ഞെടുക്കാൻ ടാപ്പ് ചെയ്യുക';
    case 'kn': return 'ಸಸ್ಯದ ಚಿತ್ರವನ್ನು ಆಯ್ಕೆಮಾಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ';
    case 'hi': return 'पौधे की छवि चुनने के लिए टैप करें';
    case 'pa': return 'ਪੌਦੇ ਦੀ ਤਸਵੀਰ ਚੁਣਨ ਲਈ ਟੈਪ ਕਰੋ';
    case 'bn': return 'গাছের ছবি বেছে নিতে ট্যাপ করুন';
    case 'gu': return ' છોડની છબી પસંદ કરવા માટે ટેપ કરો';
    case 'mr': return 'वनस्पतीचे चित्र निवडण्यासाठी टॅप करा';
    case 'te': return 'మొక్క చిత్రాన్ని ఎంచుకోవడానికి ట్యాప్ చేయండి';
    case 'ta': return 'தாவரப் படத்தைத் தேர்ந்தெடுக்க தட்டவும்';
    default: return 'Tap to select plant image';
  }
}

 String get detectingDisease {
  switch (locale.languageCode) {
    case 'ml': return 'രോഗം കണ്ടെത്തുന്നു...';
    case 'kn': return 'ರೋಗವನ್ನು ಪತ್ತೆಹಚ್ಚಲಾಗುತ್ತಿದೆ...';
    case 'hi': return 'रोग का पता लगाया जा रहा है...';
    case 'pa': return 'ਬਿਮਾਰੀ ਦੀ ਪਛਾਣ ਹੋ ਰਹੀ ਹੈ...';
    case 'bn': return 'রোগ সনাক্ত করা হচ্ছে...';
    case 'gu': return 'રોગ શોધી રહ્યા છીએ...';
    case 'mr': return 'रोग शोधला जात आहे...';
    case 'te': return 'వ్యాధిని గుర్తిస్తోంది...';
    case 'ta': return 'நோயை கண்டறிகிறது...';
    default: return 'Detecting disease...';
  }
}

  String get changeImage {
  switch (locale.languageCode) {
    case 'ml': return 'ചിത്രം മാറ്റുക';
    case 'kn': return 'ಚಿತ್ರವನ್ನು ಬದಲಿಸಿ';
    case 'hi': return 'छवि बदलें';
    case 'pa': return 'ਤਸਵੀਰ ਬਦਲੋ';
    case 'bn': return 'ছবি পরিবর্তন করুন';
    case 'gu': return 'છબી બદલો';
    case 'mr': return 'प्रतिमा बदला';
    case 'te': return 'చిత్రాన్ని మార్చండి';
    case 'ta': return 'படத்தை மாற்றவும்';
    default: return 'Change Image';
  }
}

  String get typeMessage {
  switch (locale.languageCode) {
    case 'ml': return 'നിങ്ങളുടെ കൃഷി ചോദ്യം ടൈപ്പ് ചെയ്യുക...';
    case 'kn': return 'ನಿಮ್ಮ ಕೃಷಿ ಪ್ರಶ್ನೆಯನ್ನು ಟೈಪ್ ಮಾಡಿ...';
    case 'hi': return 'अपना कृषि प्रश्न टाइप करें...';
    case 'pa': return 'ਆਪਣਾ ਖੇਤੀਬਾੜੀ ਸਵਾਲ ਟਾਈਪ ਕਰੋ...';
    case 'bn': return 'আপনার কৃষি প্রশ্ন টাইপ করুন...';
    case 'gu': return 'તમારો કૃષિ પ્રશ્ન લખો...';
    case 'mr': return 'आपला शेतीचा प्रश्न टाइप करा...';
    case 'te': return 'మీ వ్యవసాయ ప్రశ్నను టైప్ చేయండి...';
    case 'ta': return 'உங்கள் விவசாய கேள்வியை தட்டச்சு செய்யவும்...';
    default: return 'Type your farming query...';
  }
}

String get findNearbyStorage {
  switch (locale.languageCode) {
    case 'ml': return 'സമീപമുള്ള സംഭരണ ​​കേന്ദ്രങ്ങൾ കണ്ടെത്തുന്നു...';
    case 'kn': return 'ಸಮೀಪದ ಸಂಗ್ರಹಣಾ ಕೇಂದ್ರಗಳನ್ನು ಹುಡುಕಲಾಗುತ್ತಿದೆ...';
    case 'hi': return 'निकटवर्ती भंडारण केंद्र खोज रहे हैं...';
    case 'pa': return 'ਨੇੜਲੇ ਸਟੋਰੇਜ ਕੇਂਦਰ ਲੱਭੇ ਜਾ ਰਹੇ ਹਨ...';
    case 'bn': return 'নিকটবর্তী সংরক্ষণ কেন্দ্রগুলি খোঁজা হচ্ছে...';
    case 'gu': return 'નજીકના સ્ટોરેજ સેન્ટરો શોધી રહ્યા છીએ...';
    case 'mr': return 'जवळील साठवण केंद्रे शोधत आहे...';
    case 'te': return 'సమీపంలోని నిల్వ కేంద్రాలను కనుగొంటోంది...';
    case 'ta': return 'அருகிலுள்ள சேமிப்பு மையங்களை கண்டறிதல்...';
    default: return 'Finding nearby storage centers...';
  }
}

String get coldStorage {
  switch (locale.languageCode) {
    case 'ml': return 'കൊൾഡ് സ്റ്റോറേജ്';
    case 'kn': return 'ಕೋಲ್ಡ್ ಸ್ಟೋರೇಜ್';
    case 'hi': return 'कोल्ड स्टोरेज';
    case 'pa': return 'ਠੰਢਾ ਸਟੋਰੇਜ';
    case 'bn': return 'কোল্ড স্টোরেজ';
    case 'gu': return 'ઠંડુ સ્ટોરેજ';
    case 'mr': return 'कोल्ड स्टोरेज';
    case 'te': return 'శీతల గది';
    case 'ta': return 'குளிர் சேமிப்பு';
    default: return 'Cold Storage';
  }
}

String get warehouse {
  switch (locale.languageCode) {
    case 'ml': return 'ഗൊഡൗൺ';
    case 'kn': return 'ಗೋದಾಮು';
    case 'hi': return 'वेयरहाउस';
    case 'pa': return 'ਗੋਦਾਮ';
    case 'bn': return 'গুদাম';
    case 'gu': return 'ગોડાઉન';
    case 'mr': return 'गोदाम';
    case 'te': return 'గిడ్డంగి';
    case 'ta': return 'கிடங்கு';
    default: return 'Warehouse';
  }
}

String get refrigeratedStorage {
  switch (locale.languageCode) {
    case 'ml': return 'തണുപ്പിച്ച സംഭരണം';
    case 'kn': return 'ಶೀತಲೀಕೃತ ಸಂಗ್ರಹಣೆ';
    case 'hi': return 'शीत भंडारण';
    case 'pa': return 'ਠੰਢਾ ਸਟੋਰੇਜ';
    case 'bn': return 'রেফ্রিজারেটেড স্টোরেজ';
    case 'gu': return 'શીતળ સ્ટોરેજ';
    case 'mr': return 'शीतगृह';
    case 'te': return 'ఫ్రిజ్ నిల్వ';
    case 'ta': return 'குளிரூட்டப்பட்ட சேமிப்பு';
    default: return 'Refrigerated Storage';
  }
}

String get agriculturalStorage {
  switch (locale.languageCode) {
    case 'ml': return 'കൃഷി സംഭരണം';
    case 'kn': return 'ಕೃಷಿ ಸಂಗ್ರಹಣೆ';
    case 'hi': return 'कृषि भंडारण';
    case 'pa': return 'ਕ੍ਰਿਸ਼ੀ ਸਟੋਰੇਜ';
    case 'bn': return 'কৃষি সংরক্ষণ';
    case 'gu': return 'કૃષિ સંગ્રહ';
    case 'mr': return 'कृषी साठवण';
    case 'te': return 'వ్యవసాయ నిల్వ';
    case 'ta': return 'விவசாய சேமிப்பு';
    default: return 'Agricultural Storage';
  }
}

String get showingStorageWithRadius {
  switch (locale.languageCode) {
    case 'ml': return 'നിർദ്ദിഷ്ട പരിധിയിലുള്ള സംഭരണങ്ങൾ പ്രദർശിപ്പിക്കുന്നു';
    case 'kn': return 'ನಿರ್ದಿಷ್ಟ ವ್ಯಾಪ್ತಿಯೊಳಗಿನ ಸಂಗ್ರಹಣೆಯನ್ನು ತೋರಿಸಲಾಗುತ್ತಿದೆ';
    case 'hi': return 'निर्दिष्ट सीमा के भीतर भंडारण दिखा रहा है';
    case 'pa': return 'ਨਿਰਧਾਰਤ ਹੱਦ ਵਿੱਚ ਸਟੋਰੇਜ ਦਿਖਾਇਆ ਜਾ ਰਿਹਾ ਹੈ';
    case 'bn': return 'নির্দিষ্ট সীমার মধ্যে স্টোরেজ দেখানো হচ্ছে';
    case 'gu': return 'નિર્ધારિત વ્યાસની અંદર સ્ટોરેજ બતાવી રહ્યું છે';
    case 'mr': return 'निर्धारित त्रिज्येतील साठवण दाखवत आहे';
    case 'te': return 'నిర్దిష్ట పరిధిలో నిల్వను చూపుతోంది';
    case 'ta': return 'குறிப்பிட்ட ஆரை உள்ளே சேமிப்பைக் காட்டுகிறது';
    default: return 'Showing storage within specified radius';
  }
}

String get findStorage {
  switch (locale.languageCode) {
    case 'ml': // Malayalam
      return 'സംഭരണ ​​സ്ഥലം കണ്ടെത്തുക';
    case 'kn': // Kannada
      return 'ಸಂಗ್ರಹಣಾ ಸ್ಥಳವನ್ನು ಹುಡುಕಿ';
    case 'hi': // Hindi
      return 'भंडारण स्थान खोजें';
    case 'pa': // Punjabi
      return 'ਸਟੋਰੇਜ ਥਾਂ ਲੱਭੋ';
    case 'bn': // Bengali
      return 'সংরক্ষণের স্থান খুঁজুন';
    case 'gu': // Gujarati
      return 'સંગ્રહ સ્થાન શોધો';
    case 'mr': // Marathi
      return 'साठवण स्थान शोधा';
    case 'te': // Telugu
      return 'నిల్వ స్థలాన్ని కనుగొనండి';
    case 'ta': // Tamil
      return 'சேமிப்பு இடத்தை கண்டறியவும்';
    case 'en': // English
      return 'Find Storage';
    default:
      return 'Find Storage';
  }
}

String get searchRadius {
  switch (locale.languageCode) {
    case 'ml': // Malayalam
      return 'തിരച്ചിലിന്റെ പരിധി';
    case 'kn': // Kannada
      return 'ಹುಡುಕಾಟ ವ್ಯಾಪ್ತಿ';
    case 'hi': // Hindi
      return 'खोज त्रिज्या';
    case 'pa': // Punjabi
      return 'ਖੋਜ ਅਰਧਵਿਆਸ';
    case 'bn': // Bengali
      return 'অনুসন্ধান ব্যাসার্ধ';
    case 'gu': // Gujarati
      return 'શોધ વ્યાસ';
    case 'mr': // Marathi
      return 'शोध व्यास';
    case 'te': // Telugu
      return 'శోధన వ్యాసార్థం';
    case 'ta': // Tamil
      return 'தேடல் வட்டாரம்';
    case 'en': // English
      return 'Search Radius';
    default:
      return 'Search Radius';
  }
}


String get cropTraderFinder {
  switch (locale.languageCode) {
    case 'ml': return 'വിള വ്യാപാരിയെ കണ്ടെത്തുക';
    case 'kn': return 'ಬೆಳೆ ವ್ಯಾಪಾರಿಯನ್ನು ಹುಡುಕಿ';
    case 'hi': return 'फसल व्यापारी खोजें';
    case 'pa': return 'ਫਸਲ ਵਪਾਰੀ ਲੱਭੋ';
    case 'bn': return 'ফসল ব্যবসায়ী খুঁজুন';
    case 'gu': return 'પાક વેપારી શોધો';
    case 'mr': return 'पिक व्यापारी शोधा';
    case 'te': return 'పంట వ్యాపారిని కనుగొనండి';
    case 'ta': return 'பயிர் வர்த்தகரை கண்டறியவும்';
    default: return 'Crop Trader Finder';
  }
}

String get findNearbyTraders {
  switch (locale.languageCode) {
    case 'ml': return 'അടുത്ത വിള വ്യാപാരികളെ കണ്ടെത്തുക!';
    case 'kn': return 'ಹತ್ತಿರದ ಬೆಳೆ ವ್ಯಾಪಾರಿಗಳನ್ನು ಹುಡುಕಿ!';
    case 'hi': return 'नज़दीकी फसल व्यापारियों को खोजें!';
    case 'pa': return 'ਨੇੜਲੇ ਫਸਲ ਵਪਾਰੀਆਂ ਨੂੰ ਲੱਭੋ!';
    case 'bn': return 'নিকটবর্তী ফসল ব্যবসায়ীদের খুঁজুন!';
    case 'gu': return 'નજીકના પાક વેપારીઓ શોધો!';
    case 'mr': return 'जवळचे पिक व्यापारी शोधा!';
    case 'te': return 'సమీపంలోని పంట వ్యాపారులను కనుగొనండి!';
    case 'ta': return 'அருகிலுள்ள பயிர் வர்த்தகர்களைக் கண்டறியவும்!';
    default: return 'Find nearby crop traders!';
  }
}

// Add these methods to your AppLocalizations class

// String get cropTraderFinder {
//   switch (locale.languageCode) {
//     case 'ml': return 'വിള വ്യാപാരിയെ കണ്ടെത്തുക';
//     case 'kn': return 'ಬೆಳೆ ವ್ಯಾಪಾರಿಯನ್ನು ಹುಡುಕಿ';
//     case 'hi': return 'फसल व्यापारी खोजें';
//     case 'pa': return 'ਫਸਲ ਵਪਾਰੀ ਲੱਭੋ';
//     case 'bn': return 'ফসল ব্যবসায়ী খুঁজুন';
//     case 'gu': return 'પાક વેપારી શોધો';
//     case 'mr': return 'पिक व्यापारी शोधा';
//     case 'te': return 'పంట వ్యాపారిని కనుగొనండి';
//     case 'ta': return 'பயிர் வர்த்தகரை கண்டறியவும்';
//     default: return 'Crop Trader Finder';
//   }
// }

// String get findNearbyTraders {
//   switch (locale.languageCode) {
//     case 'ml': return 'അടുത്തുള്ള വിള വ്യാപാരികളെ കണ്ടെത്തുക!';
//     case 'kn': return 'ಹತ್ತಿರದ ಬೆಳೆ ವ್ಯಾಪಾರಿಗಳನ್ನು ಹುಡುಕಿ!';
//     case 'hi': return 'पास के फसल व्यापारी खोजें!';
//     case 'pa': return 'ਨੇੜੇ ਦੇ ਫਸਲ ਵਪਾਰੀ ਲੱਭੋ!';
//     case 'bn': return 'কাছাকাছি ফসল ব্যবসায়ী খুঁজুন!';
//     case 'gu': return 'નજીકના પાક વેપારીઓ શોધો!';
//     case 'mr': return 'जवळचे पिक व्यापारी शोधा!';
//     case 'te': return 'సమీపంలో ఉన్న పంట వ్యాపారులను కనుగొనండి!';
//     case 'ta': return 'அருகிலுள்ள பயிர் வர்த்தகர்களைக் கண்டறியவும்!';
//     default: return 'Find nearby crop traders!';
//   }
// }

String get commissionAgent {
  switch (locale.languageCode) {
    case 'ml': return 'കമ്മീഷൻ ഏജന്റ്';
    case 'kn': return 'ಕಮಿಷನ್ ಏಜೆಂಟ್';
    case 'hi': return 'कमीशन एजेंट';
    case 'pa': return 'ਕਮਿਸ਼ਨ ਏਜੰਟ';
    case 'bn': return 'কমিশন এজেন্ট';
    case 'gu': return 'કમિશન એજન્ટ';
    case 'mr': return 'कमिशन एजंट';
    case 'te': return 'కమీషన్ ఏజెంట్';
    case 'ta': return 'கமிஷன் ஏஜென்ட்';
    default: return 'Commission Agent';
  }
}

String get mandiTrader {
  switch (locale.languageCode) {
    case 'ml': return 'മണ്ഡി വ്യാപാരി';
    case 'kn': return 'ಮಂಡಿ ವ್ಯಾಪಾರಿ';
    case 'hi': return 'मंडी व्यापारी';
    case 'pa': return 'ਮੰਡੀ ਵਪਾਰੀ';
    case 'bn': return 'মান্ডি ব্যবসায়ী';
    case 'gu': return 'મંડી વેપારી';
    case 'mr': return 'मंडी व्यापारी';
    case 'te': return 'మండి వ్యాపారి';
    case 'ta': return 'மண்டி வர்த்தகர்';
    default: return 'Mandi Trader';
  }
}

String get bulkBuyer {
  switch (locale.languageCode) {
    case 'ml': return 'മൊത്ത വാങ്ങുന്നവർ';
    case 'kn': return 'ಬೃಹತ್ ಖರೀದಿದಾರ';
    case 'hi': return 'थोक खरीदार';
    case 'pa': return 'ਥੋਕ ਖਰੀਦਦਾਰ';
    case 'bn': return 'বাল্ক ক্রেতা';
    case 'gu': return 'બલ્ક ખરીદદાર';
    case 'mr': return 'मोठ्या प्रमाणात खरेदीदार';
    case 'te': return 'బల్క్ కొనుగోలుదారు';
    case 'ta': return 'மொத்த வாங்குபவர்';
    default: return 'Bulk Buyer';
  }
}

String get exportTrader {
  switch (locale.languageCode) {
    case 'ml': return 'കയറ്റുമതി വ്യാപാരി';
    case 'kn': return 'ರಫ್ತು ವ್ಯಾಪಾರಿ';
    case 'hi': return 'निर्यात व्यापारी';
    case 'pa': return 'ਨਿਰਯਾਤ ਵਪਾਰੀ';
    case 'bn': return 'রপ্তানি ব্যবসায়ী';
    case 'gu': return 'નિકાસ વેપારી';
    case 'mr': return 'निर्यात व्यापारी';
    case 'te': return 'ఎగుమతి వ్యాపారి';
    case 'ta': return 'ஏற்றுமதி வர்த்தகர்';
    default: return 'Export Trader';
  }
}

String get processingUnit {
  switch (locale.languageCode) {
    case 'ml': return 'സംസ്കരണ യൂണിറ്റ്';
    case 'kn': return 'ಸಂಸ್ಕರಣಾ ಘಟಕ';
    case 'hi': return 'प्रसंस्करण इकाई';
    case 'pa': return 'ਪ੍ਰੋਸੈਸਿੰਗ ਯੂਨਿਟ';
    case 'bn': return 'প্রক্রিয়াকরণ ইউনিট';
    case 'gu': return 'પ્રોસેસિંગ યુનિટ';
    case 'mr': return 'प्रक्रिया युनिट';
    case 'te': return 'ప్రాసెసింగ్ యూనిట్';
    case 'ta': return 'செயலாக்க அலகு';
    default: return 'Processing Unit';
  }
}

String get cooperativeSociety {
  switch (locale.languageCode) {
    case 'ml': return 'സഹകരണ സംഘം';
    case 'kn': return 'ಸಹಕಾರ ಸಂಘ';
    case 'hi': return 'सहकारी समिति';
    case 'pa': return 'ਸਹਿਕਾਰੀ ਸੋਸਾਇਟੀ';
    case 'bn': return 'সমবায় সমিতি';
    case 'gu': return 'સહકારી સંસ્થા';
    case 'mr': return 'सहकारी संस्था';
    case 'te': return 'సహకార సంఘం';
    case 'ta': return 'கூட்டுறவு சங்கம்';
    default: return 'Cooperative Society';
  }
}

// String get searchRadius {
//   switch (locale.languageCode) {
//     case 'ml': return 'തിരയൽ ദൂരം';
//     case 'kn': return 'ಹುಡುಕಾಟ ತ್ರಿಜ್ಯ';
//     case 'hi': return 'खोज त्रिज्या';
//     case 'pa': return 'ਖੋਜ ਦਾਇਰਾ';
//     case 'bn': return 'অনুসন্ধান ব্যাসার্ধ';
//     case 'gu': return 'શોધ ત્રિજ્યા';
//     case 'mr': return 'शोध त्रिज्या';
//     case 'te': return 'శోధన వ్యాసార్థం';
//     case 'ta': return 'தேடல் ஆரம்';
//     default: return 'Search Radius';
//   }
// }

String get findTraders {
  switch (locale.languageCode) {
    case 'ml': return 'വ്യാപാരികളെ കണ്ടെത്തുക';
    case 'kn': return 'ವ್ಯಾಪಾರಿಗಳನ್ನು ಹುಡುಕಿ';
    case 'hi': return 'व्यापारी खोजें';
    case 'pa': return 'ਵਪਾਰੀ ਲੱਭੋ';
    case 'bn': return 'ব্যবসায়ী খুঁজুন';
    case 'gu': return 'વેપારીઓ શોધો';
    case 'mr': return 'व्यापारी शोधा';
    case 'te': return 'వ్యాపారులను కనుగొనండి';
    case 'ta': return 'வர்த்தகர்களைக் கண்டறியவும்';
    default: return 'Find Traders';
  }
}

String get locatingPosition {
  switch (locale.languageCode) {
    case 'ml': return 'നിങ്ങളുടെ സ്ഥാനം കണ്ടെത്തുന്നു...';
    case 'kn': return 'ನಿಮ್ಮ ಸ್ಥಾನವನ್ನು ಪತ್ತೆಹಚ್ಚಲಾಗುತ್ತಿದೆ...';
    case 'hi': return 'आपकी स्थिति का पता लगाया जा रहा है...';
    case 'pa': return 'ਤੁਹਾਡੀ ਸਥਿਤੀ ਲੱਭੀ ਜਾ ਰਹੀ ਹੈ...';
    case 'bn': return 'আপনার অবস্থান খুঁজে বের করা হচ্ছে...';
    case 'gu': return 'તમારી સ્થિતિ શોધી રહ્યા છીએ...';
    case 'mr': return 'तुमची स्थिती शोधत आहे...';
    case 'te': return 'మీ స్థానాన్ని గుర్తిస్తోంది...';
    case 'ta': return 'உங்கள் இருப்பிடத்தைக் கண்டறிகிறது...';
    default: return 'Locating your position...';
  }
}

String get enableLocationServices {
  switch (locale.languageCode) {
    case 'ml': return 'ദയവായി ലൊക്കേഷൻ സേവനങ്ങൾ പ്രവർത്തനക്ഷമമാക്കുക';
    case 'kn': return 'ದಯವಿಟ್ಟು ಸ್ಥಳ ಸೇವೆಗಳನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಿ';
    case 'hi': return 'कृपया लोकेशन सेवाएं सक्षम करें';
    case 'pa': return 'ਕਿਰਪਾ ਕਰਕੇ ਟਿਕਾਣਾ ਸੇਵਾਵਾਂ ਸਮਰੱਥ ਕਰੋ';
    case 'bn': return 'অনুগ্রহ করে অবস্থান পরিষেবা সক্ষম করুন';
    case 'gu': return 'કૃપા કરીને સ્થાન સેવાઓ સક્ષમ કરો';
    case 'mr': return 'कृपया स्थान सेवा सक्षम करा';
    case 'te': return 'దయచేసి స్థాన సేవలను ప్రారంభించండి';
    case 'ta': return 'இருப்பிட சேவைகளை இயக்கவும்';
    default: return 'Please enable location services';
  }
}

String get locationPermissionsDenied {
  switch (locale.languageCode) {
    case 'ml': return 'ലൊക്കേഷൻ അനുമതികൾ സ്ഥിരമായി നിരസിച്ചു. ആപ്പ് ക്രമീകരണങ്ങളിൽ പ്രവർത്തനക്ഷമമാക്കുക.';
    case 'kn': return 'ಸ್ಥಳ ಅನುಮತಿಗಳನ್ನು ಶಾಶ್ವತವಾಗಿ ನಿರಾಕರಿಸಲಾಗಿದೆ. ಆ್ಯಪ್ ಸೆಟ್ಟಿಂಗ್‌ಗಳಲ್ಲಿ ಸಕ್ರಿಯಗೊಳಿಸಿ.';
    case 'hi': return 'लोकेशन अनुमतियाँ स्थायी रूप से अस्वीकृत। कृपया ऐप सेटिंग्स में सक्षम करें।';
    case 'pa': return 'ਟਿਕਾਣਾ ਅਨੁਮਤੀਆਂ ਸਥਾਈ ਤੌਰ ਤੇ ਇਨਕਾਰ ਕੀਤੀਆਂ ਗਈਆਂ। ਐਪ ਸੈਟਿੰਗਾਂ ਵਿੱਚ ਸਮਰੱਥ ਕਰੋ।';
    case 'bn': return 'অবস্থান অনুমতি স্থায়ীভাবে প্রত্যাখ্যান করা হয়েছে। অনুগ্রহ করে অ্যাপ সেটিংসে সক্ষম করুন।';
    case 'gu': return 'સ્થાન પરવાનગીઓ કાયમી રીતે નકારવામાં આવી છે. કૃપા કરીને એપ સેટિંગ્સમાં સક્ષમ કરો.';
    case 'mr': return 'स्थान परवानग्या कायमची नाकारल्या. कृपया अॅप सेटिंग्जमध्ये सक्षम करा.';
    case 'te': return 'స్థాన అనుమతులు శాశ్వతంగా తిరస్కరించబడ్డాయి. దయచేసి యాప్ సెట్టింగ్‌లలో ప్రారంభించండి.';
    case 'ta': return 'இருப்பிட அனுமதிகள் நிரந்தரமாக மறுக்கப்பட்டன. பயன்பாட்டு அமைப்புகளில் இயக்கவும்.';
    default: return 'Location permissions permanently denied. Please enable in app settings.';
  }
}

String get locationPermissionsRequired {
  switch (locale.languageCode) {
    case 'ml': return 'ലൊക്കേഷൻ അനുമതികൾ ആവശ്യമാണ്';
    case 'kn': return 'ಸ್ಥಳ ಅನುಮತಿಗಳು ಅಗತ್ಯವಿದೆ';
    case 'hi': return 'लोकेशन अनुमतियाँ आवश्यक हैं';
    case 'pa': return 'ਟਿਕਾਣਾ ਅਨੁਮਤੀਆਂ ਲੋੜੀਂਦੀਆਂ ਹਨ';
    case 'bn': return 'অবস্থান অনুমতি প্রয়োজন';
    case 'gu': return 'સ્થાન પરવાનગીઓ જરૂરી છે';
    case 'mr': return 'स्थान परवानग्या आवश्यक आहेत';
    case 'te': return 'స్థాన అనుమతులు అవసరం';
    case 'ta': return 'இருப்பிட அனுமதிகள் தேவை';
    default: return 'Location permissions required';
  }
}

String get findingNearbyTraders {
  switch (locale.languageCode) {
    case 'ml': return 'അടുത്തുള്ള വ്യാപാരികളെ കണ്ടെത്തുന്നു...';
    case 'kn': return 'ಹತ್ತಿರದ ವ್ಯಾಪಾರಿಗಳನ್ನು ಹುಡುಕುತ್ತಿದೆ...';
    case 'hi': return 'पास के व्यापारी खोज रहे हैं...';
    case 'pa': return 'ਨੇੜੇ ਦੇ ਵਪਾਰੀ ਲੱਭ ਰਹੇ ਹਾਂ...';
    case 'bn': return 'কাছাকাছি ব্যবসায়ী খুঁজছি...';
    case 'gu': return 'નજીકના વેપારીઓ શોધી રહ્યા છીએ...';
    case 'mr': return 'जवळचे व्यापारी शोधत आहे...';
    case 'te': return 'సమీపంలో ఉన్న వ్యాపారులను కనుగొంటోంది...';
    case 'ta': return 'அருகிலுள்ள வர்த்தகர்களைத் தேடுகிறது...';
    default: return 'Finding nearby traders...';
  }
}

String showingTraders(String traderType, int radius) {
  switch (locale.languageCode) {
    case 'ml': return '$radius കിലോമീറ്ററിനുള്ളിൽ $traderType കാണിക്കുന്നു';
    case 'kn': return '$radius ಕಿಲೋಮೀಟರ್‌ಗಳಲ್ಲಿ $traderType ತೋರಿಸಲಾಗುತ್ತಿದೆ';
    case 'hi': return '$radius किमी के भीतर $traderType दिखा रहे हैं';
    case 'pa': return '$radius ਕਿਲੋਮੀਟਰ ਦੇ ਅੰਦਰ $traderType ਦਿਖਾ ਰਹੇ ਹਾਂ';
    case 'bn': return '$radius কিমি এর মধ্যে $traderType দেখাচ্ছে';
    case 'gu': return '$radius કિમીની અંદર $traderType બતાવી રહ્યા છે';
    case 'mr': return '$radius किमी मध्ये $traderType दाखवत आहे';
    case 'te': return '$radius కి.మీ. పరిధిలో $traderType చూపిస్తోంది';
    case 'ta': return '$radius கி.மீ. க்குள் $traderType காட்டுகிறது';
    default: return 'Showing $traderType within $radius km';
  }
}

String get couldNotLaunchMaps {
  switch (locale.languageCode) {
    case 'ml': return 'മാപ്സ് ആപ്ലിക്കേഷൻ തുറക്കാനായില്ല';
    case 'kn': return 'ನಕ್ಷೆ ಅಪ್ಲಿಕೇಶನ್ ತೆರೆಯಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ';
    case 'hi': return 'मैप्स एप्लिकेशन खोल नहीं सका';
    case 'pa': return 'ਨਕਸ਼ੇ ਐਪਲੀਕੇਸ਼ਨ ਖੋਲ੍ਹ ਨਹੀਂ ਸਕਿਆ';
    case 'bn': return 'মানচিত্র অ্যাপ্লিকেশন খুলতে পারেনি';
    case 'gu': return 'નકશા એપ્લિકેશન ખોલી શક્યું નહીં';
    case 'mr': return 'नकाशे अॅप्लिकेशन उघडू शकले नाही';
    case 'te': return 'మ్యాప్స్ అప్లికేషన్ తెరవలేకపోయింది';
    case 'ta': return 'வரைபடப் பயன்பாட்டைத் திறக்க முடியவில்லை';
    default: return 'Could not launch maps application';
  }
}

String get error {
  switch (locale.languageCode) {
    case 'ml': return 'പിശക്';
    case 'kn': return 'ದೋಷ';
    case 'hi': return 'त्रुटि';
    case 'pa': return 'ਗਲਤੀ';
    case 'bn': return 'ত্রুটি';
    case 'gu': return 'ભૂલ';
    case 'mr': return 'त्रुटी';
    case 'te': return 'లోపం';
    case 'ta': return 'பிழை';
    default: return 'Error';
  }
}



String get landSizeAndBudget {
  switch (locale.languageCode) {
    case 'ml': return 'ഭൂമിയുടെ വലുപ്പവും ബജറ്റും';
    case 'kn': return 'ಭೂಮಿ ಗಾತ್ರ ಮತ್ತು ಬಜೆಟ್';
    case 'hi': return 'भूमि का आकार और बजट';
    case 'pa': return 'ਜ਼ਮੀਨ ਦਾ ਆਕਾਰ ਅਤੇ ਬਜਟ';
    case 'bn': return 'জমির আকার এবং বাজেট';
    case 'gu': return 'જમીનનું કદ અને બજેટ';
    case 'mr': return 'जमीन आकार आणि बजेट';
    case 'te': return 'భూమి పరిమాణం మరియు బడ్జెట్';
    case 'ta': return 'நில அளவு மற்றும் பட்ஜெட்';
    default: return 'Land Size & Budget';
  }
}

String get landSize {
  switch (locale.languageCode) {
    case 'ml': return 'ഭൂമിയുടെ വലുപ്പം';
    case 'kn': return 'ಭೂಮಿ ಗಾತ್ರ';
    case 'hi': return 'भूमि का आकार';
    case 'pa': return 'ਜ਼ਮੀਨ ਦਾ ਆਕਾਰ';
    case 'bn': return 'জমির আকার';
    case 'gu': return 'જમીનનું કદ';
    case 'mr': return 'जमीन आकार';
    case 'te': return 'భూమి పరిమాణం';
    case 'ta': return 'நில அளவு';
    default: return 'Land Size';
  }
}

String get acres {
  switch (locale.languageCode) {
    case 'ml': return 'ഏക്കർ';
    case 'kn': return 'ಎಕರೆ';
    case 'hi': return 'एकड़';
    case 'pa': return 'ਏਕੜ';
    case 'bn': return 'একর';
    case 'gu': return 'એકર';
    case 'mr': return 'एकर';
    case 'te': return 'ఎకరాలు';
    case 'ta': return 'ஏக்கர்';
    default: return 'acres';
  }
}

String get budget {
  switch (locale.languageCode) {
    case 'ml': return 'ബജറ്റ്';
    case 'kn': return 'ಬಜೆಟ್';
    case 'hi': return 'बजट';
    case 'pa': return 'ਬਜਟ';
    case 'bn': return 'বাজেট';
    case 'gu': return 'બજેટ';
    case 'mr': return 'बजेट';
    case 'te': return 'బడ్జెట్';
    case 'ta': return 'பட்ஜெட்';
    default: return 'Budget';
  }
}

String get plantingMonth {
  switch (locale.languageCode) {
    case 'ml': return 'നടീൽ മാസം';
    case 'kn': return 'ನೆಡುವ ತಿಂಗಳು';
    case 'hi': return 'रोपण माह';
    case 'pa': return 'ਬੀਜਣ ਦਾ ਮਹੀਨਾ';
    case 'bn': return 'রোপণের মাস';
    case 'gu': return 'વાવણીનો મહિનો';
    case 'mr': return 'लागवड महिना';
    case 'te': return 'నాటడం నెల';
    case 'ta': return 'நடவு மாதம்';
    default: return 'Planting Month';
  }
}

String get selectPlantingMonth {
  switch (locale.languageCode) {
    case 'ml': return 'നടീൽ മാസം തിരഞ്ഞെടുക്കുക';
    case 'kn': return 'ನೆಡುವ ತಿಂಗಳನ್ನು ಆಯ್ಕೆಮಾಡಿ';
    case 'hi': return 'रोपण माह चुनें';
    case 'pa': return 'ਬੀਜਣ ਦਾ ਮਹੀਨਾ ਚੁਣੋ';
    case 'bn': return 'রোপণের মাস নির্বাচন করুন';
    case 'gu': return 'વાવણીનો મહિનો પસંદ કરો';
    case 'mr': return 'लागवड महिना निवडा';
    case 'te': return 'నాటడం నెలను ఎంచుకోండి';
    case 'ta': return 'நடவு மாதத்தைத் தேர்ந்தெடுக்கவும்';
    default: return 'Select planting month';
  }
}

String get fertilizerRecommendation {
  switch (locale.languageCode) {
    case 'ml': return 'വള ശുപാർശ';
    case 'kn': return 'ಗೊಬ್ಬರ ಶಿಫಾರಸು';
    case 'hi': return 'उर्वरक की सिफारिश';
    case 'pa': return 'ਖਾਦ ਦੀ ਸਿਫਾਰਸ਼';
    case 'bn': return 'সার সুপারিশ';
    case 'gu': return 'ખાતરની ભલામણ';
    case 'mr': return 'खत शिफारस';
    case 'te': return 'ఎరువుల సిఫార్సు';
    case 'ta': return 'உர பரிந்துரை';
    default: return 'Fertilizer Recommendation';
  }
}

// Crop Names
String get rice {
  switch (locale.languageCode) {
    case 'ml': return 'നെല്ല്';
    case 'kn': return 'ಅಕ್ಕಿ';
    case 'hi': return 'चावल';
    case 'pa': return 'ਚਾਵਲ';
    case 'bn': return 'ধান';
    case 'gu': return 'ચોખા';
    case 'mr': return 'तांदूळ';
    case 'te': return 'వరి';
    case 'ta': return 'நெல்';
    default: return 'Rice';
  }
}

String get coconut {
  switch (locale.languageCode) {
    case 'ml': return 'തേങ്ങ';
    case 'kn': return 'ತೆಂಗಿನಕಾಯಿ';
    case 'hi': return 'नारियल';
    case 'pa': return 'ਨਾਰੀਅਲ';
    case 'bn': return 'নারকেল';
    case 'gu': return 'નાળિયેર';
    case 'mr': return 'नारळ';
    case 'te': return 'కొబ్బరి';
    case 'ta': return 'தேங்காய்';
    default: return 'Coconut';
  }
}

String get rubber {
  switch (locale.languageCode) {
    case 'ml': return 'റബ്ബർ';
    case 'kn': return 'ರಬ್ಬರ್';
    case 'hi': return 'रबड़';
    case 'pa': return 'ਰਬੜ';
    case 'bn': return 'রাবার';
    case 'gu': return 'રબર';
    case 'mr': return 'रबर';
    case 'te': return 'రబ్బరు';
    case 'ta': return 'ரப்பர்';
    default: return 'Rubber';
  }
}

String get spices {
  switch (locale.languageCode) {
    case 'ml': return 'മസാല';
    case 'kn': return 'ಮಸಾಲೆ';
    case 'hi': return 'मसाले';
    case 'pa': return 'ਮਸਾਲੇ';
    case 'bn': return 'মশলা';
    case 'gu': return 'મસાલા';
    case 'mr': return 'मसाले';
    case 'te': return 'మసాలా';
    case 'ta': return 'மசாலா';
    default: return 'Spices';
  }
}

String get banana {
  switch (locale.languageCode) {
    case 'ml': return 'വാഴ';
    case 'kn': return 'ಬಾಳೆಹಣ್ಣು';
    case 'hi': return 'केला';
    case 'pa': return 'ਕੇਲਾ';
    case 'bn': return 'কলা';
    case 'gu': return 'કેળું';
    case 'mr': return 'केळी';
    case 'te': return 'అరటి';
    case 'ta': return 'வாழை';
    default: return 'Banana';
  }
}

String get tapioca {
  switch (locale.languageCode) {
    case 'ml': return 'കപ്പ';
    case 'kn': return 'ಮರಗೆಣಸು';
    case 'hi': return 'टैपिओका';
    case 'pa': return 'ਟੈਪੀਓਕਾ';
    case 'bn': return 'ট্যাপিওকা';
    case 'gu': return 'ટેપિઓકા';
    case 'mr': return 'टॅपिओका';
    case 'te': return 'కరగడుంప';
    case 'ta': return 'மரவள்ளிக்கிழங்கு';
    default: return 'Tapioca';
  }
}

String get vegetables {
  switch (locale.languageCode) {
    case 'ml': return 'പച്ചക്കറി';
    case 'kn': return 'ತರಕಾರಿಗಳು';
    case 'hi': return 'सब्जियाँ';
    case 'pa': return 'ਸਬਜ਼ੀਆਂ';
    case 'bn': return 'সবজি';
    case 'gu': return 'શાકભાજી';
    case 'mr': return 'भाज्या';
    case 'te': return 'కూరగాయలు';
    case 'ta': return 'காய்கறிகள்';
    default: return 'Vegetables';
  }
}

String get ginger {
  switch (locale.languageCode) {
    case 'ml': return 'ഇഞ്ചി';
    case 'kn': return 'ಶುಂಠಿ';
    case 'hi': return 'अदरक';
    case 'pa': return 'ਅਦਰਕ';
    case 'bn': return 'আদা';
    case 'gu': return 'આદુ';
    case 'mr': return 'आले';
    case 'te': return 'అల్లం';
    case 'ta': return 'இஞ்சி';
    default: return 'Ginger';
  }
}

// Soil Types
String get lateriteSoil {
  switch (locale.languageCode) {
    case 'ml': return 'ലാറ്ററൈറ്റ് മണ്ണ്';
    case 'kn': return 'ಲ್ಯಾಟರೈಟ್ ಮಣ್ಣು';
    case 'hi': return 'लैटेराइट मिट्टी';
    case 'pa': return 'ਲੈਟਰਾਈਟ ਮਿੱਟੀ';
    case 'bn': return 'ল্যাটেরাইট মাটি';
    case 'gu': return 'લેટેરાઇટ માટી';
    case 'mr': return 'लॅटेराईट माती';
    case 'te': return 'లాటరైట్ మట్టి';
    case 'ta': return 'லேட்டரைட் மண்';
    default: return 'Laterite Soil';
  }
}

String get alluvialSoil {
  switch (locale.languageCode) {
    case 'ml': return 'എക്കൽ മണ്ണ്';
    case 'kn': return 'ಮೆಕ್ಕಲು ಮಣ್ಣು';
    case 'hi': return 'जलोढ़ मिट्टी';
    case 'pa': return 'ਦਰਿਆਈ ਮਿੱਟੀ';
    case 'bn': return 'পলিমাটি';
    case 'gu': return 'કાંપવાળી માટી';
    case 'mr': return 'पाणमाती';
    case 'te': return 'ఒండ్రు మట్టి';
    case 'ta': return 'வண்டல் மண்';
    default: return 'Alluvial Soil';
  }
}

String get coastalSandy {
  switch (locale.languageCode) {
    case 'ml': return 'തീരദേശ മണൽ';
    case 'kn': return 'ಕರಾವಳಿ ಮರಳು';
    case 'hi': return 'तटीय रेतीली';
    case 'pa': return 'ਤਟਵਰਤੀ ਰੇਤਲੀ';
    case 'bn': return 'উপকূলীয় বালুকাময়';
    case 'gu': return 'દરિયાકાંઠાની રેતાળ';
    case 'mr': return 'किनारी वालुकामय';
    case 'te': return 'తీరప్రాంత ఇసుక';
    case 'ta': return 'கடலோர மணல்';
    default: return 'Coastal Sandy';
  }
}

String get forestSoil {
  switch (locale.languageCode) {
    case 'ml': return 'കാട്ടു മണ്ണ്';
    case 'kn': return 'ಅರಣ್ಯ ಮಣ್ಣು';
    case 'hi': return 'वन मिट्टी';
    case 'pa': return 'ਜੰਗਲੀ ਮਿੱਟੀ';
    case 'bn': return 'বন মাটি';
    case 'gu': return 'જંગલ માટી';
    case 'mr': return 'वन माती';
    case 'te': return 'అటవీ మట్టి';
    case 'ta': return 'காடு மண்';
    default: return 'Forest Soil';
  }
}

// Soil Descriptions
String get redClaySoil {
  switch (locale.languageCode) {
    case 'ml': return 'ചുവന്ന കളിമണ്ണ്';
    case 'kn': return 'ಕೆಂಪು ಜೇಡಿ ಮಣ್ಣು';
    case 'hi': return 'लाल मिट्टी';
    case 'pa': return 'ਲਾਲ ਮਿੱਟੀ';
    case 'bn': return 'লাল কাদা মাটি';
    case 'gu': return 'લાલ માટી';
    case 'mr': return 'लाल माती';
    case 'te': return 'ఎరుపు మట్టి';
    case 'ta': return 'சிவப்பு களிமண்';
    default: return 'Red clay soil';
  }
}

String get riverSoil {
  switch (locale.languageCode) {
    case 'ml': return 'നദീതീര മണ്ണ്';
    case 'kn': return 'ನದಿ ಮಣ್ಣು';
    case 'hi': return 'नदी की मिट्टी';
    case 'pa': return 'ਨਦੀ ਦੀ ਮਿੱਟੀ';
    case 'bn': return 'নদীর মাটি';
    case 'gu': return 'નદીની માટી';
    case 'mr': return 'नदीची माती';
    case 'te': return 'నది మట్టి';
    case 'ta': return 'ஆற்று மண்';
    default: return 'River soil';
  }
}

String get beachAreaSoil {
  switch (locale.languageCode) {
    case 'ml': return 'കടൽത്തീര മണ്ണ്';
    case 'kn': return 'ಕಡಲತೀರದ ಮಣ್ಣು';
    case 'hi': return 'समुद्र तटीय मिट्टी';
    case 'pa': return 'ਸਮੁੰਦਰੀ ਤੱਟ ਦੀ ਮਿੱਟੀ';
    case 'bn': return 'সৈকত অঞ্চলের মাটি';
    case 'gu': return 'બીચ વિસ્તારની માટી';
    case 'mr': return 'समुद्रकिनारा माती';
    case 'te': return 'తీర ప్రాంత మట్టి';
    case 'ta': return 'கடற்கரை பகுதி மண்';
    default: return 'Beach area soil';
  }
}

String get hillAreaSoil {
  switch (locale.languageCode) {
    case 'ml': return 'മലയോര മണ്ണ്';
    case 'kn': return 'ಬೆಟ್ಟದ ಪ್ರದೇಶದ ಮಣ್ಣು';
    case 'hi': return 'पहाड़ी क्षेत्र की मिट्टी';
    case 'pa': return 'ਪਹਾੜੀ ਖੇਤਰ ਦੀ ਮਿੱਟੀ';
    case 'bn': return 'পাহাড়ী এলাকার মাটি';
    case 'gu': return 'ટેકરી વિસ્તારની માટી';
    case 'mr': return 'डोंगराळ प्रदेशाची माती';
    case 'te': return 'కొండ ప్రాంత మట్టి';
    case 'ta': return 'மலைப் பகுதி மண்';
    default: return 'Hill area soil';
  }
}

// Months
String get january {
  switch (locale.languageCode) {
    case 'ml': return 'ജനുവരി';
    case 'kn': return 'ಜನವರಿ';
    case 'hi': return 'जनवरी';
    case 'pa': return 'ਜਨਵਰੀ';
    case 'bn': return 'জানুয়ারি';
    case 'gu': return 'જાન્યુઆરી';
    case 'mr': return 'जानेवारी';
    case 'te': return 'జనవరి';
    case 'ta': return 'ஜனவரி';
    default: return 'January';
  }
}

String get february {
  switch (locale.languageCode) {
    case 'ml': return 'ഫെബ്രുവരി';
    case 'kn': return 'ಫೆಬ್ರವರಿ';
    case 'hi': return 'फरवरी';
    case 'pa': return 'ਫਰਵਰੀ';
    case 'bn': return 'ফেব্রুয়ারি';
    case 'gu': return 'ફેબ્રુઆરી';
    case 'mr': return 'फेब्रुवारी';
    case 'te': return 'ఫిబ్రవరి';
    case 'ta': return 'பிப்ரவரி';
    default: return 'February';
  }
}

String get march {
  switch (locale.languageCode) {
    case 'ml': return 'മാർച്ച്';
    case 'kn': return 'ಮಾರ್ಚ್';
    case 'hi': return 'मार्च';
    case 'pa': return 'ਮਾਰਚ';
    case 'bn': return 'মার্চ';
    case 'gu': return 'માર્ચ';
    case 'mr': return 'मार्च';
    case 'te': return 'మార్చి';
    case 'ta': return 'மார்ச்';
    default: return 'March';
  }
}

String get april {
  switch (locale.languageCode) {
    case 'ml': return 'ഏപ്രിൽ';
    case 'kn': return 'ಏಪ್ರಿಲ್';
    case 'hi': return 'अप्रैल';
    case 'pa': return 'ਅਪ੍ਰੈਲ';
    case 'bn': return 'এপ্রিল';
    case 'gu': return 'એપ્રિલ';
    case 'mr': return 'एप्रिल';
    case 'te': return 'ఏప్రిల్';
    case 'ta': return 'ஏப்ரல்';
    default: return 'April';
  }
}

String get may {
  switch (locale.languageCode) {
    case 'ml': return 'മേയ്';
    case 'kn': return 'ಮೇ';
    case 'hi': return 'मई';
    case 'pa': return 'ਮਈ';
    case 'bn': return 'মে';
    case 'gu': return 'મે';
    case 'mr': return 'मे';
    case 'te': return 'మే';
    case 'ta': return 'மே';
    default: return 'May';
  }
}

String get june {
  switch (locale.languageCode) {
    case 'ml': return 'ജൂൺ';
    case 'kn': return 'ಜೂನ್';
    case 'hi': return 'जून';
    case 'pa': return 'ਜੂਨ';
    case 'bn': return 'জুন';
    case 'gu': return 'જૂન';
    case 'mr': return 'जून';
    case 'te': return 'జూన్';
    case 'ta': return 'ஜூன்';
    default: return 'June';
  }
}

String get july {
  switch (locale.languageCode) {
    case 'ml': return 'ജൂലൈ';
    case 'kn': return 'ಜುಲೈ';
    case 'hi': return 'जुलाई';
    case 'pa': return 'ਜੁਲਾਈ';
    case 'bn': return 'জুলাই';
    case 'gu': return 'જુલાઈ';
    case 'mr': return 'जुलै';
    case 'te': return 'జూలై';
    case 'ta': return 'ஜூலை';
    default: return 'July';
  }
}

String get august {
  switch (locale.languageCode) {
    case 'ml': return 'ഓഗസ്റ്റ്';
    case 'kn': return 'ಆಗಸ್ಟ್';
    case 'hi': return 'अगस्त';
    case 'pa': return 'ਅਗਸਤ';
    case 'bn': return 'আগস্ট';
    case 'gu': return 'ઓગસ્ટ';
    case 'mr': return 'ऑगस्ट';
    case 'te': return 'ఆగస్టు';
    case 'ta': return 'ஆகஸ்ட்';
    default: return 'August';
  }
}

String get september {
  switch (locale.languageCode) {
    case 'ml': return 'സെപ്റ്റംബർ';
    case 'kn': return 'ಸೆಪ್ಟೆಂಬರ್';
    case 'hi': return 'सितंबर';
    case 'pa': return 'ਸਤੰਬਰ';
    case 'bn': return 'সেপ্টেম্বর';
    case 'gu': return 'સપ્ટેમ્બર';
    case 'mr': return 'सप्टेंबर';
    case 'te': return 'సెప్టెంబర్';
    case 'ta': return 'செப்டம்பர்';
    default: return 'September';
  }
}

String get october {
  switch (locale.languageCode) {
    case 'ml': return 'ഒക്ടോബർ';
    case 'kn': return 'ಅಕ್ಟೋಬರ್';
    case 'hi': return 'अक्टूबर';
    case 'pa': return 'ਅਕਤੂਬਰ';
    case 'bn': return 'অক্টোবর';
    case 'gu': return 'ઓક્ટોબર';
    case 'mr': return 'ऑक्टोबर';
    case 'te': return 'అక్టోబర్';
    case 'ta': return 'அக்டோபர்';
    default: return 'October';
  }
}

String get november {
  switch (locale.languageCode) {
    case 'ml': return 'നവംബർ';
    case 'kn': return 'ನವೆಂಬರ್';
    case 'hi': return 'नवंबर';
    case 'pa': return 'ਨਵੰਬਰ';
    case 'bn': return 'নভেম্বর';
    case 'gu': return 'નવેમ્બર';
    case 'mr': return 'नोव्हेंबर';
    case 'te': return 'నవంబర్';
    case 'ta': return 'நவம்பர்';
    default: return 'November';
  }
}

String get december {
  switch (locale.languageCode) {
    case 'ml': return 'ഡിസംബർ';
    case 'kn': return 'ಡಿಸೆಂಬರ್';
    case 'hi': return 'दिसंबर';
    case 'pa': return 'ਦਸੰਬਰ';
    case 'bn': return 'ডিসেম্বর';
    case 'gu': return 'ડિસેમ્બર';
    case 'mr': return 'डिसेंबर';
    case 'te': return 'డిసెంబర్';
    case 'ta': return 'டிசம்பர்';
    default: return 'December';
  }
}

// Status Messages
String get unknownLocation {
  switch (locale.languageCode) {
    case 'ml': return 'അജ്ഞാത സ്ഥലം';
    case 'kn': return 'ಅಜ್ಞಾತ ಸ್ಥಳ';
    case 'hi': return 'अज्ञात स्थान';
    case 'pa': return 'ਅਣਜਾਣ ਸਥਾਨ';
    case 'bn': return 'অজানা অবস্থান';
    case 'gu': return 'અજ્ઞાત સ્થાન';
    case 'mr': return 'अज्ञात स्थान';
    case 'te': return 'తెలియని స్థానం';
    case 'ta': return 'தெரியாத இடம்';
    default: return 'Unknown location';
  }
}

String get currentLocation {
  switch (locale.languageCode) {
    case 'ml': return 'നിലവിലെ സ്ഥലം';
    case 'kn': return 'ಪ್ರಸ್ತುತ ಸ್ಥಳ';
    case 'hi': return 'वर्तमान स्थान';
    case 'pa': return 'ਮੌਜੂਦਾ ਸਥਾਨ';
    case 'bn': return 'বর্তমান অবস্থান';
    case 'gu': return 'વર્તમાન સ્થાન';
    case 'mr': return 'सध्याचे स्थान';
    case 'te': return 'ప్రస్తుత స్థానం';
    case 'ta': return 'தற்போதைய இடம்';
    default: return 'Current location';
  }
}

String get waterAvailability {
  switch (locale.languageCode) {
    case 'ml': return 'ജല ലഭ്യത';
    case 'kn': return 'ನೀರಿನ ಲಭ್ಯತೆ';
    case 'hi': return 'जल उपलब्धता';
    case 'pa': return 'ਪਾਣੀ ਦੀ ਉਪਲਬਧਤਾ';
    case 'bn': return 'জল প্রাপ্যতা';
    case 'gu': return 'પાણીની ઉપલબ્ધતા';
    case 'mr': return 'पाणी उपलब्धता';
    case 'te': return 'నీటి లభ్యత';
    case 'ta': return 'நீர் இருப்பு';
    default: return 'Water Availability';
  }
}

String get gettingWeather {
  switch (locale.languageCode) {
    case 'ml': return 'കാലാവസ്ഥ ലഭിക്കുന്നു...';
    case 'kn': return 'ಹವಾಮಾನ ಪಡೆಯಲಾಗುತ್ತಿದೆ...';
    case 'hi': return 'मौसम की जानकारी मिल रही है...';
    case 'pa': return 'ਮੌਸਮ ਦੀ ਜਾਣਕਾਰੀ ਪ੍ਰਾਪਤ ਕੀਤੀ ਜਾ ਰਹੀ ਹੈ...';
    case 'bn': return 'আবহাওয়া তথ্য পাওয়া যাচ্ছে...';
    case 'gu': return 'હવામાન મેળવી રહ્યા છીએ...';
    case 'mr': return 'हवामान माहिती मिळवत आहे...';
    case 'te': return 'వాతావరణ సమాచారం పొందుతోంది...';
    case 'ta': return 'வானிலை பெறப்படுகிறது...';
    default: return 'Getting weather...';
  }
}

String get humidity {
  switch (locale.languageCode) {
    case 'ml': return 'ആർദ്രത';
    case 'kn': return 'ತೇವಾಂಶ';
    case 'hi': return 'आर्द्रता';
    case 'pa': return 'ਨਮੀ';
    case 'bn': return 'আর্দ্রতা';
    case 'gu': return 'ભેજ';
    case 'mr': return 'आर्द्रता';
    case 'te': return 'తేమ';
    case 'ta': return 'ஈரப்பதம்';
    default: return 'Humidity';
  }
}

String get pleaseFillAllFields {
  switch (locale.languageCode) {
    case 'ml': return 'ദയവായി എല്ലാ ഫീൽഡുകളും പൂരിപ്പിക്കുക';
    case 'kn': return 'ದಯವಿಟ್ಟು ಎಲ್ಲಾ ಕ್ಷೇತ್ರಗಳನ್ನು ಭರ್ತಿ ಮಾಡಿ';
    case 'hi': return 'कृपया सभी फील्ड भरें';
    case 'pa': return 'ਕਿਰਪਾ ਕਰਕੇ ਸਾਰੇ ਖੇਤਰ ਭਰੋ';
    case 'bn': return 'অনুগ্রহ করে সমস্ত ক্ষেত্র পূরণ করুন';
    case 'gu': return 'કૃપા કરીને બધા ક્ષેત્રો ભરો';
    case 'mr': return 'कृपया सर्व फील्ड भरा';
    case 'te': return 'దయచేసి అన్ని ఫీల్డ్‌లను పూరించండి';
    case 'ta': return 'அனைத்து புலங்களையும் நிரப்பவும்';
    default: return 'Please fill all required fields';
  }
}

String get noRecommendationAvailable {
  switch (locale.languageCode) {
    case 'ml': return 'ശുപാർശകൾ ലഭ്യമല്ല';
    case 'kn': return 'ಶಿಫಾರಸು ಲಭ್ಯವಿಲ್ಲ';
    case 'hi': return 'सिफारिश उपलब्ध नहीं';
    case 'pa': return 'ਸਿਫਾਰਸ਼ ਉਪਲਬਧ ਨਹੀਂ';
    case 'bn': return 'সুপারিশ উপলব্ধ নয়';
    case 'gu': return 'ભલામણ ઉપલબ્ધ નથી';
    case 'mr': return 'शिफारस उपलब्ध नाही';
    case 'te': return 'సిఫార్సు అందుబాటులో లేదు';
    case 'ta': return 'பரிந்துரை கிடைக்கவில்லை';
    default: return 'No recommendation available';
  }
}

String get errorGettingRecommendation {
  switch (locale.languageCode) {
    case 'ml': return 'ശുപാർശ ലഭിക്കുന്നതിൽ പിശക്. ദയവായി വീണ്ടും ശ്രമിക്കുക.';
    case 'kn': return 'ಶಿಫಾರಸು ಪಡೆಯುವಲ್ಲಿ ದೋಷ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';
    case 'hi': return 'सिफारिश प्राप्त करने में त्रुटि। कृपया पुनः प्रयास करें।';
    case 'pa': return 'ਸਿਫਾਰਸ਼ ਪ੍ਰਾਪਤ ਕਰਨ ਵਿੱਚ ਗਲਤੀ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';
    case 'bn': return 'সুপারিশ পেতে ত্রুটি। অনুগ্রহ করে আবার চেষ্টা করুন।';
    case 'gu': return 'ભલામણ મેળવવામાં ભૂલ. કૃપા કરીને ફરી પ્રયાસ કરો.';
    case 'mr': return 'शिफारस मिळवण्यात त्रुटी. कृपया पुन्हा प्रयत्न करा.';
    case 'te': return 'సిఫార్సు పొందడంలో లోపం. దయచేసి మళ్లీ ప్రయత్నించండి.';
    case 'ta': return 'பரிந்துரை பெறுவதில் பிழை. மீண்டும் முயற்சிக்கவும்.';
    default: return 'Error getting recommendation. Please try again.';
  }
}

String get failedToSaveData {
  switch (locale.languageCode) {
    case 'ml': return 'ഡാറ്റ സംരക്ഷിക്കുന്നതിൽ പരാജയപ്പെട്ടു';
    case 'kn': return 'ಡೇಟಾ ಉಳಿಸಲು ವಿಫಲವಾಗಿದೆ';
    case 'hi': return 'डेटा सहेजने में विफल';
    case 'pa': return 'ਡਾਟਾ ਸੁਰੱਖਿਅਤ ਕਰਨ ਵਿੱਚ ਅਸਫਲ';
    case 'bn': return 'ডেটা সংরক্ষণ করতে ব্যর্থ';
    case 'gu': return 'ડેટા સાચવવામાં નિષ્ફળ';
    case 'mr': return 'डेटा जतन करण्यात अयशस्वी';
    case 'te': return 'డేటాను సేవ్ చేయడంలో విఫలమైంది';
    case 'ta': return 'தரவைச் சேமிக்க முடியவில்லை';
    default: return 'Failed to save data';
  }
}

  // AppLocalizations(this.locale);

  // static AppLocalizations of(BuildContext context) {
  //   return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  // }

  String get appName {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'കിസാൻസാഥി';
      case 'kn': // Kannada
        return 'ಕಿಸಾನ್ಸಾಥಿ';
      case 'hi': // Hindi
        return 'किसानसाथी';
      case 'pa': // Punjabi
        return 'ਕਿਸਾਨਸਾਥੀ';
      case 'bn': // Bengali
        return 'কিসানসাথি';
      case 'gu': // Gujarati
        return 'કિસાનસાથી';
      case 'mr': // Marathi
        return 'किसानसाथी';
      case 'te': // Telugu
        return 'కిసాన్సాథి';
      case 'ta': // Tamil
        return 'கிசான்சாதி';
      case 'en': // English
        return 'KisaanSaathi';
      default:
        return 'KisaanSaathi'; // Default fallback value
    }
  }

  String get agriStore {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'അഗ്രിസ്റ്റോർ';
      case 'kn': // Kannada
        return 'ಅಗ್ರಿಸ್ಟೋರ್';
      case 'hi':
        return 'एग्रीस्टोर';
      case 'pa':
        return 'ਐਗਰੀਸਟੋਰ';
      case 'bn':
        return 'এগ্রিস্টোর';
      case 'ta':
        return 'அக்ரிஸ்டோர்';
      case 'te':
        return 'అగ్రిస్టోర్';
      case 'mr':
        return 'अॅग्रीस्टोर';
      case 'gu':
        return 'એગ્રીસ્ટોર';
      default:
        return 'AgriStore';
    }
  }

  String get galleryOption {
    switch (locale.languageCode) {
      case 'ml':
        return 'ഗ്യാലറി'; // Malayalam
      case 'kn':
        return 'ಗ್ಯಾಲರಿ'; // Kannada
      case 'hi':
        return 'गैलरी'; // Hindi
      case 'pa':
        return 'ਗੈਲਰੀ'; // Punjabi
      case 'bn':
        return 'গ্যালারি'; // Bengali
      case 'gu':
        return 'ગેલરી'; // Gujarati
      case 'mr':
        return 'गॅलरी'; // Marathi
      case 'te':
        return 'గ్యాలరీ'; // Telugu
      case 'ta':
        return 'கேலரி'; // Tamil
      case 'en':
        return 'Gallery'; // English
      default:
        return 'Gallery';
    }
  }

  // New: Camera option
  String get cameraOption {
    switch (locale.languageCode) {
      case 'ml':
        return 'ക്യാമറ'; // Malayalam
      case 'kn':
        return 'ಕ್ಯಾಮೆರಾ'; // Kannada
      case 'hi':
        return 'कैमरा'; // Hindi
      case 'pa':
        return 'ਕੈਮਰਾ'; // Punjabi
      case 'bn':
        return 'ক্যামেরা'; // Bengali
      case 'gu':
        return 'કૅમેરા'; // Gujarati
      case 'mr':
        return 'कॅमेरा'; // Marathi
      case 'te':
        return 'కెమెరా'; // Telugu
      case 'ta':
        return 'கேமரா'; // Tamil
      case 'en':
        return 'Camera'; // English
      default:
        return 'Camera';
    }
  }

  String get nearbyStores {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'അടുത്തുള്ള തണുപ്പുമുറികൾ';
      case 'kn': // Kannada
        return 'ಹತ್ತಿರದ ಶೀತಲಗೃಹಗಳು';
      case 'hi': // Hindi
        return 'आसपास के कोल्ड स्टोरेज';
      case 'pa': // Punjabi
        return 'ਨੇੜਲੇ ਕੋਲਡ ਸਟੋਰੇਜ';
      case 'bn': // Bengali
        return 'পার্শ্ববর্তী কোল্ড স্টোরেজ';
      case 'ta': // Tamil
        return 'அருகிலுள்ள குளிர்சாதனங்கள்';
      case 'te': // Telugu
        return 'సమీపంలోని కోల్డ్ స్టోరేజ్‌లు';
      case 'mr': // Marathi
        return 'जवळच्या कोल्ड स्टोरेज';
      case 'gu': // Gujarati
        return 'નજીકના ઠંડા સ્ટોરેજ';
      default:
        return 'Nearby Cold Storages';
    }
  }

  String get nearbyTraders {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'അയൽപക്കത്തെ വ്യാപാരികൾ';
      case 'kn': // Kannada
        return 'ಹತ್ತಿರದ ವ್ಯಾಪಾರಿಗಳು';
      case 'hi':
        return 'आसपास के व्यापारी';
      case 'pa':
        return 'ਨੇੜੇ ਵਪਾਰੀ';
      case 'bn':
        return 'পার্শ্ববর্তী ব্যবসায়ী';
      case 'ta':
        return 'அருகிலுள்ள வணிகர்கள்';
      case 'te':
        return 'సమీప వ్యాపారులు';
      case 'mr':
        return 'जवळच्या व्यापारी';
      case 'gu':
        return 'નજીકના વ્યાપારી';
      default:
        return 'Nearby Traders';
    }
  }

  // Language names in their respective languages
  Map<String, String> get languageNames {
    return {
      'en': 'English', // English
      'hi': 'हिन्दी', // Hindi
      'ml': 'മലയാളം', // Malayalam
      'kn': 'ಕನ್ನಡ', // Kannada
      'pa': 'ਪੰਜਾਬੀ', // Punjabi
      'bn': 'বাংলা', // Bengali
      'ta': 'தமிழ்', // Tamil
      'te': 'తెలుగు', // Telugu
      'mr': 'मराठी', // Marathi
      'gu': 'ગુજરાતી', // Gujarati
    };
  }

  // Localized strings for login screen
  String get loginTitle {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ലോഗിൻ';
      case 'kn': // Kannada
        return 'ಲಾಗಿನ್';
      case 'hi':
        return 'लॉगिन';
      case 'pa':
        return 'ਲੌਗਿਨ';
      case 'bn':
        return 'লগইন';
      case 'ta':
        return 'உள்நுழைவு';
      case 'te':
        return 'లాగిన్';
      case 'mr':
        return 'लॉगिन';
      case 'gu':
        return 'લૉગિન';
      default:
        return 'Login';
    }
  }

  String get phoneNumberLabel {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ഫോൺ നമ്പർ';
      case 'kn': // Kannada
        return 'ಫೋನ್ ನಂಬರ್';
      case 'hi':
        return 'फोन नंबर';
      case 'pa':
        return 'ਫੋਨ ਨੰਬਰ';
      case 'bn':
        return 'ফোন নম্বর';
      case 'ta':
        return 'தொலைபேசி எண்';
      case 'te':
        return 'ఫోన్ నంబర్';
      case 'mr':
        return 'फोन नंबर';
      case 'gu':
        return 'ફોન નંબર';
      default:
        return 'Phone Number';
    }
  }

  String get phoneHint {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return '10 അക്ക നമ്പർ നൽകുക';
      case 'kn': // Kannada
        return '10 ಅಂಕಿಯ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ';
      case 'hi':
        return '10 अंकों का नंबर दर्ज करें';
      case 'pa':
        return '10 ਅੰਕਾਂ ਦਾ ਨੰਬਰ ਦਰਜ਼ ਕਰੋ';
      case 'bn':
        return '10 সংখ্যার নম্বর লিখুন';
      case 'ta':
        return '10 இலக்க எண்ணை உள்ளிடவும்';
      case 'te':
        return '10 అంకెల నంబర్ను నమోదు చేయండి';
      case 'mr':
        return '10 अंकी क्रमांक प्रविष्ट करा';
      case 'gu':
        return '10 અંક નો નંબર દાખલ કરો';
      default:
        return 'Enter 10-digit number';
    }
  }

  String get continueButtonText {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'തുടരുക';
      case 'kn': // Kannada
        return 'ಮುಂದುವರಿಸಿ';
      case 'hi':
        return 'जारी रखें';
      case 'pa':
        return 'ਜਾਰੀ ਰੱਖੋ';
      case 'bn':
        return 'চালিয়ে যান';
      case 'ta':
        return 'தொடரவும்';
      case 'te':
        return 'కొనసాగించండి';
      case 'mr':
        return 'सुरु ठेवा';
      case 'gu':
        return 'ચાલુ રાખો';
      default:
        return 'Continue';
    }
  }

  String get skipLoginText {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ലോഗിൻ ഒഴിവാക്കുക';
      case 'kn': // Kannada
        return 'ಲಾಗಿನ್ ಬಿಟ್ಟುಬಿಡಿ';
      case 'hi':
        return 'लॉगिन छोड़ें';
      case 'pa':
        return 'ਲੌਗਿਨ ਛੱਡੋ';
      case 'bn':
        return 'লগইন বাদ দিন';
      case 'ta':
        return 'உள்நுழைவை தவிர்க்கவும்';
      case 'te':
        return 'లాగిన్ వదలండి';
      case 'mr':
        return 'लॉगिन वगळा';
      case 'gu':
        return 'લૉગિન રદ કરો';
      default:
        return 'Skip Login';
    }
  }

  String get selectLanguageTitle {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ഭാഷ തിരഞ്ഞെടുക്കുക';
      case 'kn': // Kannada
        return 'ಭಾಷೆ ಆರಿಸಿ';
      case 'hi':
        return 'भाषा चुनें';
      case 'pa':
        return 'ਭਾਸ਼ਾ ਚੁਣੋ';
      case 'bn':
        return 'ভাষা নির্বাচন করুন';
      case 'ta':
        return 'மொழி தேர்ந்தெடுக்கவும்';
      case 'te':
        return 'భాషను ఎంచుకోండి';
      case 'mr':
        return 'भाषा निवडा';
      case 'gu':
        return 'ભાષા પસંદ કરો';
      default:
        return 'Select Language';
    }
  }

  String get voiceAssistantLanguageNote {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'നിങ്ങളുടെ പ്രിയങ്കര ഭാഷ വോയ്സ് അസിസ്റ്റന്റ് ഉപയോഗിക്കും';
      case 'kn': // Kannada
        return 'ನಿಮ್ಮ ಆದ್ಯತೆಯ ಭಾಷೆಯನ್ನು ವಾಯ್ಸ್ ಅಸಿಸ್ಟೆಂಟ್ ಬಳಸುತ್ತದೆ';
      case 'hi':
        return 'आपकी पसंदीदा भाषा वॉइस असिस्टेंट द्वारा उपयोग की जाएगी';
      case 'pa':
        return 'ਤੁਹਾਡੀ ਪਸੰਦੀਦਾ ਭਾਸ਼ਾ ਵੌਇਸ ਸਹਾਇਕ ਦੁਆਰਾ ਵਰਤੀ ਜਾਵੇਗੀ';
      case 'bn':
        return 'আপনার পছন্দসই ভাষা ভয়েস সাহায্যকারী দ্বারা ব্যবহৃত হবে';
      case 'ta':
        return 'உங்கள் விருப்பமான மொழி குரல் உதவியாளரால் பயன்படுத்தப்படும்';
      case 'te':
        return 'మీ preferred భాష వాయిస్ అసిస్టెంట్ ద్వారా ఉపయోగించబడుతుంది';
      case 'mr':
        return 'आपली प्राधान्य असलेली भाषा व्हॉइस असिस्टंटद्वारे वापरली जाईल';
      case 'gu':
        return 'તમારી પસંદની ભાષા વૉઇસ આસિસ્ટન્ટ દ્વારા વાપરવામાં આવશે';
      default:
        return 'Your preferred language will be used by the Voice Assistant';
    }
  }

  String get invalidPhoneNumber {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'സാധുവായ 10 അക്ക നമ്പർ നൽകുക';
      case 'kn': // Kannada
        return 'ಮಾನ್ಯ 10 ಅಂಕಿಯ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ';
      case 'hi':
        return 'वैध 10 अंकों का नंबर दर्ज करें';
      case 'pa':
        return 'ਵੈਧ 10 ਅੰਕਾਂ ਦਾ ਨੰਬर ਦਰਜ਼ ਕਰੋ';
      case 'bn':
        return 'বৈধ 10 সংখ্যার নম্বর লিখুন';
      case 'ta':
        return 'சரியான 10 இலக்க எண்ணை உள்ளிடவும்';
      case 'te':
        return 'చెల్లుబాటు అయ్యే 10 అంకెల నంబర్ను నमోదు చేయండి';
      case 'mr':
        return 'वैध 10 अंकी क्रमांक प्रविष्ट करा';
      case 'gu':
        return 'માન્ય 10 અંકનો નંબર દાખલ કરો';
      default:
        return 'Enter a valid 10-digit number';
    }
  }

  String get todaysWeather {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ഇന്നത്തെ കാലാവസ്ഥ';
      case 'kn': // Kannada
        return 'ಇಂದಿನ ಹವಾಮಾನ';
      case 'ta':
        return 'இன்று வானம்';
      case 'te':
        return 'ఇప్పుడు ప్రస్తుతం';
      case 'hi':
        return 'आज का मौसम';
      case 'pa':
        return 'ਅੱਜ ਦਾ ਮੌਸਮ';
      case 'bn':
        return 'আজকের আবহাওয়া';
      case 'gu':
        return 'આજનું હવામાન';
      case 'mr':
        return 'आजचे हवामान';
      default:
        return 'Today\'s Weather';
    }
  }

  String get humidityLabel {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ആർദ്രത';
      case 'kn': // Kannada
        return 'ಆರ್ದ್ರತೆ';
      case 'ta': // Tamil
        return 'ஈரப்பதம்';
      case 'te': // Telugu
        return 'తేమ';
      case 'hi': // Hindi
        return 'आर्द्रता';
      case 'pa': // Punjabi
        return 'ਨਮੀ';
      case 'bn': // Bengali
        return 'আর্দ্রতা';
      case 'gu': // Gujarati
        return 'આર્દ્રતા';
      case 'mr': // Marathi
        return 'आर्द्रता';
      default:
        return 'Humidity';
    }
  }

  String get windSpeedLabel {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'കാറ്റിൻ്റെ വേഗത';
      case 'kn': // Kannada
        return 'ಗಾಳಿಯ ವೇಗ';
      case 'ta': // Tamil
        return 'காற்றின் வேகம்';
      case 'te': // Telugu
        return 'గాలి వేగం';
      case 'hi': // Hindi
        return 'हवा की गति';
      case 'pa': // Punjabi
        return 'ਹਵਾ ਦੀ ਗਤੀ';
      case 'bn': // Bengali
        return 'বাতাসের গতি';
      case 'gu': // Gujarati
        return 'પવનની ગતિ';
      case 'mr': // Marathi
        return 'वारा वेग';
      default:
        return 'Wind Speed';
    }
  }

  String get rainChanceLabel {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'മഴ സാധ്യത';
      case 'kn': // Kannada
        return 'ಮಳೆ ಸಾಧ್ಯತೆ';
      case 'ta': // Tamil
        return 'மழை வாய்ப்பு';
      case 'te': // Telugu
        return 'వర్షపు అవకాశం';
      case 'hi': // Hindi
        return 'बारिश की संभावना';
      case 'pa': // Punjabi
        return 'ਬਾਰਸ਼ ਦੀ ਸੰਭਾਵਨਾ';
      case 'bn': // Bengali
        return 'বৃষ্টির সম্ভাবনা';
      case 'gu': // Gujarati
        return 'વરસાદની સંભાવના';
      case 'mr': // Marathi
        return 'पाऊस संभावना';
      default:
        return 'Rain Chance';
    }
  }

  String get detailedWeather {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'വിശദമായ കാലാവസ്ഥ';
      case 'kn': // Kannada
        return 'ವಿವರವಾದ ಹವಾಮಾನ';
      case 'ta':
        return 'இன்று வானம்';
      case 'te':
        return 'ఇప్పుడు ప్రస్తుతం';
      case 'hi':
        return 'विस्तृत मौसम';
      case 'pa':
        return 'ਵਿਸਥਾਰਤ ਮੌਸਮ';
      case 'bn':
        return 'বিস্তারিত আবহাওয়া';
      case 'gu':
        return 'વિગતવાર હવામાન';
      case 'mr':
        return 'तपशीलवार हवामान';
      default:
        return 'Detailed Weather';
    }
  }

  String get aiAssistant {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'AI അസിസ്റ്റന്റ്';
      case 'kn': // Kannada
        return 'AI ಸಹಾಯಕ';
      case 'ta':
        return 'இன்று வானம்';
      case 'te':
        return 'ఇప్పుడు ప్రస్తుతం';
      case 'hi':
        return 'एआई सहायक';
      case 'pa':
        return 'ਏਆਈ ਸहਾਇਕ';
      case 'bn':
        return 'AI সাহায্যকারী';
      case 'gu':
        return 'AI સહાયક';
      case 'mr':
        return 'एआय सहाय्यक';
      default:
        return 'AI Assistant';
    }
  }

  String get diseaseDetection {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'രോഗം കണ്ടെത്തൽ';
      case 'kn': // Kannada
        return 'ರೋಗ ಪತ್ತೆಹಚ್ಚುವಿಕೆ';
      case 'hi':
        return 'रोग पहचान';
      case 'pa':
        return 'ਰੋਗ ਪਛਾਣ';
      case 'bn':
        return 'রোগ সনাক্তকরণ';
      case 'gu':
        return 'રોગ શોધ';
      case 'mr':
        return 'रोग शोधन';
      default:
        return 'Disease Detection';
    }
  }

  String get cropRecommendations {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'വിള ശുപാർശകൾ';
      case 'kn': // Kannada
        return 'ಬೆಳೆ ಶಿಫಾರಸுகளು';
      case 'ta':
        return 'இன்று வானம்';
      case 'te':
        return 'ఇప్పుడు ప్రస్తుతం';
      case 'hi':
        return 'फसल सिफारिशें';
      case 'pa':
        return 'ਫਸਲ ਸਿਫਾਰਸ਼ਾਂ';
      case 'bn':
        return 'ফসলের পরামর্শ';
      case 'gu':
        return 'પાક ભલામણો';
      case 'mr':
        return 'पीक शिफारशी';
      default:
        return 'Crop Recommendations';
    }
  }

  String get marketPrices {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'വിപണി വിലകൾ';
      case 'kn': // Kannada
        return 'ಮಾರುಕಟ್ಟೆ ಬೆಲೆಗಳು';
      case 'ta':
        return 'இன்று வானம்';
      case 'te':
        return 'ఇప్పుడు ప్రస్తుతం';
      case 'hi':
        return 'बाजार भाव';
      case 'pa':
        return 'ਮੰਡੀ ਦੀਆਂ ਕੀਮਤਾਂ';
      case 'bn':
        return 'বাজার দাম';
      case 'gu':
        return 'બજાર ભાવ';
      case 'mr':
        return 'बाजार भाव';
      default:
        return 'Market Prices';
    }
  }

  String get governmentSchemes {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'സർക്കാർ പദ്ധതികൾ';
      case 'kn': // Kannada
        return 'ಸರ್ಕಾರಿ ಯೋಜನೆಗಳು';
      case 'ta':
        return 'இன்று வானம்';
      case 'te':
        return 'ఇప్పుడు ప్రస్తుతం';
      case 'hi':
        return 'सरकारी योजनाएं';
      case 'pa':
        return 'ਸਰਕਾਰੀ ਯੋਜਨਾਵਾਂ';
      case 'bn':
        return 'সরকারি প্রকল্প';
      case 'gu':
        return 'સરકારી યોજનાઓ';
      case 'mr':
        return 'शासकीय योजना';
      default:
        return 'Government Schemes';
    }
  }

  String get governmentSchemesTitle {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'കിസാൻസാഥി - സർക്കാർ പദ്ധതികൾ';
      case 'kn': // Kannada
        return 'ಕಿಸಾನ್ಸಾಥಿ - ಸರ್ಕಾರಿ ಯೋಜನೆಗಳು';
      case 'ta': // Tamil
        return 'கிசான்சாதி - அரசு திட்டங்கள்';
      case 'te': // Telugu
        return 'కిసాన్సాథి - ప్రభుత్వ పథకాలు';
      case 'hi': // Hindi
        return 'किसानसाथी - सरकारी योजनाएं';
      case 'pa': // Punjabi
        return 'ਕਿਸਾਨਸਾਥੀ - ਸਰਕਾਰੀ ਯੋਜਨਾਵਾਂ';
      case 'bn': // Bengali
        return 'কিসানসাথি - সরকারি প্রকল্প';
      case 'mr': // Marathi
        return 'किसानसाथी - शासकीय योजना';
      case 'gu': // Gujarati
        return 'કિસાનસાથી - સરકારી યોજનાઓ';
      default:
        return 'KisaanSaathi - Government Schemes';
    }
  }

  String get searchSchemesHint {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'പദ്ധതികൾ തിരയുക...';
      case 'kn': // Kannada
        return 'ಯೋಜನೆಗಳನ್ನು ಹುಡುಕಿ...';
      case 'ta':
        return 'இன்று வானம்';
      case 'te':
        return 'ఇప్పుడు ప్రస్తుతం';
      case 'hi':
        return 'योजनाएं खोजें...';
      case 'pa':
        return 'ਯੋਜਨਾਵਾਂ ਖੋਜੋ...';
      case 'bn':
        return 'স্কিম অনুসন্ধান করুন...';
      case 'mr':
        return 'योजना शोधा...';
      case 'gu':
        return 'યોજનાઓ શોધો...';
      default:
        return 'Search schemes...';
    }
  }

  String get helpline {
  switch (locale.languageCode) {
    case 'ml': // Malayalam
      return 'ഹെൽപ്പ് ലൈൻ';
    case 'kn': // Kannada
      return 'ಸಹಾಯ ಹೊತ್ತಿಗೆ';
    case 'hi': // Hindi
      return 'हेल्पलाइन';
    case 'pa': // Punjabi
      return 'ਹੈਲਪਲਾਈਨ';
    case 'bn': // Bengali
      return 'হেল্পলাইন';
    case 'ta': // Tamil
      return 'உதவி மையம்';
    case 'te': // Telugu
      return 'హెల్ప్ లైన్';
    case 'mr': // Marathi
      return 'मदत केंद्र';
    case 'gu': // Gujarati
      return 'હેલ્પલાઈન';
    default:
      return 'Helpline';
  }
}

  String get filterButton {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ഫിൽട്ടർ';
      case 'kn': // Kannada
        return 'ಫಿಲ್ಟರ್';
      case 'hi':
        return 'फ़िल्टर';
      case 'pa':
        return 'ਫਿਲਟਰ';
      case 'bn':
        return 'फिल्टर';
      case 'ta':
        return 'வடிகட்டி';
      case 'te':
        return 'ఫిల్టర్';
      case 'mr':
        return 'फिल्टर';
      case 'gu':
        return 'ફિલ્ટર';
      default:
        return 'Filter';
    }
  }

  String get clearFilters {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ഫിൽട്ടറുകൾ മായ്ക്കുക';
      case 'kn': // Kannada
        return 'ಫಿಲ್ಟರ್‌ಗಳನ್ನು ತೆರವುಗೊಳಿಸಿ';
      case 'hi':
        return 'फ़िल्टर साफ़ करें';
      case 'pa':
        return 'ਫਿਲਟਰ ਸਾਫ਼ ਕਰੋ';
      case 'bn':
        return 'ফিল্টার সাফ করুন';
      case 'ta':
        return 'வடிகட்டிகளை அழிக்கவும்';
      case 'te':
        return 'ఫిల్టర్లను క్లియర్ చేయండి';
      case 'mr':
        return 'फिल्टर साफ करा';
      case 'gu':
        return 'ફિલ્ટર્સ સાફ કરો';
      default:
        return 'Clear Filters';
    }
  }

  String get schemesAvailable {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'പദ്ധതികൾ ലഭ്യമാണ്';
      case 'kn': // Kannada
        return 'ಯೋಜನೆಗಳು ಲಭ್ಯವಿದೆ';
      case 'hi':
        return 'योजनाएं उपलब्ध';
      case 'pa':
        return 'ਯੋਜਨਾਵਾਂ ਉਪਲਬਧ';
      case 'bn':
        return 'স্কিম উপলব্ধ';
      case 'ta':
        return 'திட்டங்கள் கிடைக்கின்றன';
      case 'te':
        return 'పథకాలు అందుబాటులో ఉన్నాయి';
      case 'mr':
        return 'योजना उपलब्ध';
      case 'gu':
        return 'યોજનાઓ ઉपलબ્ધ છે';
      default:
        return 'Schemes Available';
    }
  }

  String get noSchemesFound {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'പദ്ധതികൾ കണ്ടെത്തിയില്ല!\nഫിൽട്ടറുകൾ മാറ്റി വീണ്ടും ശ്രമിക്കുക.';
      case 'kn': // Kannada
        return 'ಯೋಜನೆಗಳು ಕಂಡುಬಂದಿಲ್ಲ!\nಫಿಲ್ಟರ್‌ಗಳನ್ನು ಬದಲಾಯಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';
      case 'hi':
        return 'कोई योजना नहीं मिली!\nफ़िल्टर बदलकर पुनः प्रयास करें।';
      case 'pa':
        return 'ਕੋਈ ਯੋਜਨਾ ਨਹੀਂ ਮਿਲੀ!\nਫਿਲਟਰ ਬਦਲ ਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';
      case 'bn':
        return 'কোন স্কিম পাওয়া যায়নি!\nফিল্টার পরিবর্তন করে আবার চেষ্টা করুন।';
      case 'ta':
        return 'திட்டங்கள் எதுவும் கிடைக்கவில்லை!\nவடிகட்டிகளை மாற்றி மீண்டும் முயற்சிக்கவும்.';
      case 'te':
        return 'పథకాలు ఏవీ కనుగొనబడలేదు!\nఫిల్టర్లನ್ನು మార్చి మళ్లీ ప్రయత్నించండი.';
      case 'mr':
        return 'योजना सापडली नाही!\nफिल्टर बदलून पुन्हा प्रयत्न करा.';
      case 'gu':
        return 'કોઈ યોજના મળી નથી!\nફિલ્ટર્સ બદલીને ફરીથી પ્રયાસ કરો.';
      default:
        return 'No schemes found!\nTry changing the filters and try again.';
    }
  }

  String get moreInfo {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'കൂടുതൽ വിവരങ്ങൾ';
      case 'kn': // Kannada
        return 'ಹೆಚ್ಚಿನ ಮಾಹಿತಿ';
      case 'hi':
        return 'अधिक जानकारी';
      case 'pa':
        return 'ਹੋਰ ਜਾਣਕਾਰੀ';
      case 'bn':
        return 'আরও তথ্য';
      case 'ta':
        return 'மேலும் தகவல்';
      case 'te':
        return 'మరిన్ని వివరాలు';
      case 'mr':
        return 'अधिक माहिती';
      case 'gu':
        return 'વધુ માહિતી';
      default:
        return 'More Info';
    }
  }

  String get applyNow {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ഇപ്പോൾ അപേക്ഷിക്കുക';
      case 'kn': // Kannada
        return 'ಈಗಲೇ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ';
      case 'hi':
        return 'अभी आवेदन करें';
      case 'pa':
        return 'ਹੁਣੇ ਅਰਜ਼ੀ ਦਿਓ';
      case 'bn':
        return 'এখনই আবেদন করুন';
      case 'ta':
        return 'இப்போதே விண்ணப்பிக்கவும்';
      case 'te':
        return 'ఇప్పుడే దరఖాస్తు చేసుకోండి';
      case 'mr':
        return 'आत्ताच अर्ज करा';
      case 'gu':
        return 'હમણાં જ અરજી કરો';
      default:
        return 'Apply Now';
    }
  }

  String get description {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'വിവരണം';
      case 'kn': // Kannada
        return 'ವಿವರಣೆ';
      case 'hi':
        return 'विवरण';
      case 'pa':
        return 'ਵੇਰਵਾ';
      case 'bn':
        return 'বিবরণ';
      case 'ta':
        return 'விளக்கம்';
      case 'te':
        return 'వివరణ';
      case 'mr':
        return 'वर्णन';
      case 'gu':
        return 'વર્ણન';
      default:
        return 'Description';
    }
  }

  String get benefits {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'പ്രയോജനങ്ങൾ';
      case 'kn': // Kannada
        return 'ಲಾಭಗಳು';
      case 'hi':
        return 'लाभ';
      case 'pa':
        return 'ਫਾਇਦੇ';
      case 'bn':
        return 'সুবিধা';
      case 'ta':
        return 'நன்மைகள்';
      case 'te':
        return 'ప్రయోజనాలు';
      case 'mr':
        return 'फायदे';
      case 'gu':
        return 'લાભો';
      default:
        return 'Benefits';
    }
  }

  String get eligibilityCriteria {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'യോഗ്യതാ മാനദണ്ഡങ്ങൾ';
      case 'kn': // Kannada
        return 'ಅರ್ಹತೆಯ ಮಾನದಂಡಗಳು';
      case 'hi':
        return 'पात्रता मानदंड';
      case 'pa':
        return 'ਯੋਗਤਾ ਦੇ ਮਾਪਦੰਡ';
      case 'bn':
        return 'যোগ্যতার মানদণ্ড';
      case 'ta':
        return 'தகுதி விதிமுறைகள்';
      case 'te':
        return 'అర్హత నిబంధనలు';
      case 'mr':
        return 'पात्रता निकष';
      case 'gu':
        return 'યોગ્યતા માપદંડ';
      default:
        return 'Eligibility Criteria';
    }
  }



  String get aadharRequirement {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ആധാർ ആവശ്യകത';
      case 'kn': // Kannada
        return 'ಆಧಾರ್ ಅಗತ್ಯ';
      case 'hi':
        return 'आधार आवश्यकता';
      case 'pa':
        return 'ਆਧਾਰ ਲੋੜ';
      case 'bn':
        return 'আধার প্রয়োজন';
      case 'ta':
        return 'ஆதார் தேவை';
      case 'te':
        return 'ఆధార్ అవసరం';
      case 'mr':
        return 'आधार आवश्यकता';
      case 'gu':
        return 'આધાર જરૂરિયાત';
      default:
        return 'Aadhar Requirement';
    }
  }

  String get applicationProcess {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'അപേക്ഷ പ്രക്രിയ';
      case 'kn': // Kannada
        return 'ಅರ್ಜಿ ಪ್ರಕ್ರಿಯೆ';
      case 'hi':
        return 'आवेदन प्रक्रिया';
      case 'pa':
        return 'ਅਰਜ਼ੀ ਪ੍ਰਕਿਰਿਆ';
      case 'bn':
        return 'আবেদন প্রক্রिया';
      case 'ta':
        return 'விண்ணப்ப செயல்முறை';
      case 'te':
        return 'దరఖాస్తు ప్రక్రియ';
      case 'mr':
        return 'अर्ज प्रक्रिया';
      case 'gu':
        return 'અરજી પ્રક્રિયા';
      default:
        return 'Application Process';
    }
  }

  String get contactInformation {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ബന്ധപ്പെടാനുള്ള വിവരങ്ങൾ';
      case 'kn': // Kannada
        return 'ಸಂಪರ್ಕ ಮಾಹಿತಿ';
      case 'hi':
        return 'संपर्क जानकारी';
      case 'pa':
        return 'ਸੰਪਰਕ ਜਾਣਕਾਰੀ';
      case 'bn':
        return 'যোগাযোগের তথ্য';
      case 'ta':
        return 'தொடர்பு தகவல்';
      case 'te':
        return 'సంప్రదింపు సమాచారం';
      case 'mr':
        return 'संपर्क माहिती';
      case 'gu':
        return 'સંપર્ક માહિતી';
      default:
        return 'Contact Information';
    }
  }

  String get expires {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'കാലാവധി:';
      case 'kn': // Kannada
        return 'ಅವಧಿ:';
      case 'hi':
        return 'समाप्ति:';
      case 'pa':
        return 'ਮਿਆਦ:';
      case 'bn':
        return 'মেয়াদ শেষ:';
      case 'ta':
        return 'காலாவதி:';
      case 'te':
        return 'గడువు:';
      case 'mr':
        return 'कालबाह्य:';
      case 'gu':
        return 'સમાપ્ત:';
      default:
        return 'Expires:';
    }
  }

  String get filterSchemes {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'പദ്ധതികൾ ഫിൽട്ടർ ചെയ്യുക';
      case 'kn': // Kannada
        return 'ಯೋಜನೆಗಳನ್ನು ಫಿಲ್ಟರ್ ಮಾಡಿ';
      case 'hi':
        return 'योजनाएं फ़िल्टर करें';
      case 'pa':
        return 'ਯੋਜਨਾਵਾਂ ਫਿਲਟਰ ਕਰੋ';
      case 'bn':
        return 'স্কিম ফিল্টার করুন';
      case 'ta':
        return 'திட்டங்களை வடிகட்டவும்';
      case 'te':
        return 'పథకాలను ఫిల్టర్ చేయండి';
      case 'mr':
        return 'योजना फिल्टर करा';
      case 'gu':
        return 'યોજનાઓને ફિલ્ટર કરો';
      default:
        return 'Filter Schemes';
    }
  }

  String get department {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'വകുപ്പ്';
      case 'kn': // Kannada
        return 'ಇಲಾಖೆ';
      case 'hi':
        return 'विभाग';
      case 'pa':
        return 'ਵਿਭਾਗ';
      case 'bn':
        return 'বিভাগ';
      case 'ta':
        return 'துறை';
      case 'te':
        return 'శాఖ';
      case 'mr':
        return 'विभाग';
      case 'gu':
        return 'વિભાગ';
      default:
        return 'Department';
    }
  }

  String get farmingType {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'കൃഷി തരം';
      case 'kn': // Kannada
        return 'ಕೃಷಿ ಪ್ರಕಾರ';
      case 'hi':
        return 'कृषि प्रकार';
      case 'pa':
        return 'ਖੇਤੀ ਦੀ ਕਿਸਮ';
      case 'bn':
        return 'চাষের ধরন';
      case 'ta':
        return 'விவசாய வகை';
      case 'te':
        return 'వ్యవసాయ రకం';
      case 'mr':
        return 'शेतीचा प्रकार';
      case 'gu':
        return 'ખેતીનો પ્રકાર';
      default:
        return 'Farming Type';
    }
  }

  String get cropType {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'വിള തരം';
      case 'kn': // Kannada
        return 'ಬೆಳೆ ಪ್ರಕಾರ';
      case 'hi':
        return 'फसल प्रकार';
      case 'pa':
        return 'ਫਸਲ ਦੀ ਕਿਸਮ';
      case 'bn':
        return 'ফসলের ধরন';
      case 'ta':
        return 'பயிர் வகை';
      case 'te':
        return 'పంట రకం';
      case 'mr':
        return 'पिकाचा प्रकार';
      case 'gu':
        return 'પાકનો પ્રકાર';
      default:
        return 'Crop Type';
    }
  }

  String get cashCrops {
  switch (locale.languageCode) {
    case 'ml':
      return 'വിലക്കുള്ള വിളകൾ'; // Cash crops
    case 'kn':
      return 'ನಗದು ಬೆಳೆಗಳು';
    case 'hi':
      return 'नकदी फसलें';
    case 'pa':
      return 'ਨਕਦੀ ਫਸਲਾਂ';
    case 'bn':
      return 'নগদ ফসল';
    case 'ta':
      return 'பணப் பயிர்கள்';
    case 'te':
      return 'నగదు పంటలు';
    case 'mr':
      return 'नगदी पिके';
    case 'gu':
      return 'નગદ પાકો';
    default:
      return 'Cash Crops';
  }
}

String get foodCrops {
  switch (locale.languageCode) {
    case 'ml':
      return 'ഭക്ഷ്യ വിളകൾ';
    case 'kn':
      return 'ಆಹಾರ ಬೆಳೆಗಳು';
    case 'hi':
      return 'खाद्य फसलें';
    case 'pa':
      return 'ਖਾਦ ਫਸਲਾਂ';
    case 'bn':
      return 'খাদ্য ফসল';
    case 'ta':
      return 'உணவு பயிர்கள்';
    case 'te':
      return 'ఆహార పంటలు';
    case 'mr':
      return 'अन्न पिके';
    case 'gu':
      return 'અન્ન પાકો';
    default:
      return 'Food Crops';
  }
}

String get fruits {
  switch (locale.languageCode) {
    case 'ml':
      return 'ഫലങ്ങൾ';
    case 'kn':
      return 'ಹಣ್ಣುಗಳು';
    case 'hi':
      return 'फल';
    case 'pa':
      return 'ਫਲ';
    case 'bn':
      return 'ফল';
    case 'ta':
      return 'பழங்கள்';
    case 'te':
      return 'పండ్లు';
    case 'mr':
      return 'फळे';
    case 'gu':
      return 'ફળો';
    default:
      return 'Fruits';
  }
}

String get mixedFarming {
  switch (locale.languageCode) {
    case 'ml':
      return 'മിശ്രകൃഷി';
    case 'kn':
      return 'ಮಿಶ್ರ ಕೃಷಿ';
    case 'hi':
      return 'मिश्रित खेती';
    case 'pa':
      return 'ਮਿਸ਼ਰਤ ਖੇਤੀ';
    case 'bn':
      return 'মিশ্র কৃষি';
    case 'ta':
      return 'கலப்பு விவசாயம்';
    case 'te':
      return 'మిశ్ర వ్యవసాయం';
    case 'mr':
      return 'मिश्र शेती';
    case 'gu':
      return 'મિશ્ર ખેતી';
    default:
      return 'Mixed Farming';
  }
}

String get bestCropsForYou {
  switch (locale.languageCode) {
    case 'ml':
      return 'നിങ്ങൾക്കായി ഏറ്റവും അനുയോജ്യമായ വിളകൾ';
    case 'kn':
      return 'ನಿಮಗಾಗಿ ಉತ್ತಮ ಬೆಳೆಗಳು';
    case 'hi':
      return 'आपके लिए सर्वोत्तम फसलें';
    case 'pa':
      return 'ਤੁਹਾਡੇ ਲਈ ਸਭ ਤੋਂ ਵਧੀਆ ਫਸਲਾਂ';
    case 'bn':
      return 'আপনার জন্য সেরা ফসল';
    case 'ta':
      return 'உங்களுக்கு சிறந்த பயிர்கள்';
    case 'te':
      return 'మీకు అనుకూలమైన పంటలు';
    case 'mr':
      return 'तुमच्यासाठी सर्वोत्तम पिके';
    case 'gu':
      return 'તમારા માટે શ્રેષ્ઠ પાકો';
    default:
      return 'Best Crops For You';
  }
}




  String get hectares {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ഹെക്ടർ';
      case 'kn': // Kannada
        return 'ಹೆಕ್ಟೇರ್';
      case 'hi':
        return 'हेक्टेयर';
      case 'pa':
        return 'ਹੈਕਟੇਅਰ';
      case 'bn':
        return 'হেক্টর';
      case 'ta':
        return 'ஹெக்டேர்';
      case 'te':
        return 'హెక్టార్లు';
      case 'mr':
        return 'हेक्टर';
      case 'gu':
        return 'હેક્ટર';
      default:
        return 'hectares';
    }
  }

  String get aadharRequired {
    switch (locale.languageCode) {
      case 'bn': // Bengali
        return 'আধার প্রয়োজন';
      case 'gu': // Gujarati
        return 'આધાર જરૂરી';
      case 'hi': // Hindi
        return 'आधार आवश्यक';
      case 'kn': // Kannada
        return 'ಆಧಾರ್ ಅಗತ್ಯವಿದೆ';
      case 'ml': // Malayalam
        return 'ആധാർ ആവശ്യമാണ്';
      case 'mr': // Marathi
        return 'आधार आवश्यक';
      case 'pa': // Punjabi
        return 'ਆਧਾਰ ਲੋੜੀਂਦਾ';
      case 'ta': // Tamil
        return 'ஆதார் தேவை';
      case 'te': // Telugu
        return 'ఆధార్ అవసరం';
      default: // English
        return 'Aadhar Required';
    }
  }

  String get aadharNotRequired {
    switch (locale.languageCode) {
      case 'bn': // Bengali
        return 'আধার প্রয়োজন নেই';
      case 'gu': // Gujarati
        return 'આધાર જરૂરી નથી';
      case 'hi': // Hindi
        return 'आधार आवश्यक नहीं';
      case 'kn': // Kannada
        return 'ಆಧಾರ್ ಅಗತ್ಯವಿಲ್ಲ';
      case 'ml': // Malayalam
        return 'ആധാർ ആവശ്യമില്ല';
      case 'mr': // Marathi
        return 'आधार आवश्यक नाही';
      case 'pa': // Punjabi
        return 'ਆਧਾਰ ਲੋੜੀਂਦਾ ਨਹੀਂ';
      case 'ta': // Tamil
        return 'ஆதார் தேவையில்லை';
      case 'te': // Telugu
        return 'ఆధార్ అవసరం లేదు';
      default: // English
        return 'Aadhar Not Required';
    }
  }

  String get reset {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'പുനഃസജ്ജീകരിക്കുക';
      case 'kn': // Kannada
        return 'ಮರುಹೊಂದಿಸಿ';
      case 'hi':
        return 'रीसेट';
      case 'pa':
        return 'ਰੀਸੈੱਟ';
      case 'bn':
        return 'রিসেট';
      case 'ta':
        return 'மீட்டமை';
      case 'te':
        return 'రీసెట్';
      case 'mr':
        return 'रीसेट';
      case 'gu':
        return 'રીસેટ';
      default:
        return 'Reset';
    }
  }

  String get apply {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'പ്രയോഗിക്കുക';
      case 'kn': // Kannada
        return 'ಅನ್ವಯಿಸಿ';
      case 'hi':
        return 'लागू करें';
      case 'pa':
        return 'ਲਾਗੂ ਕਰੋ';
      case 'bn':
        return 'প্রয়োগ করুন';
      case 'ta':
        return 'விண்ணப்பிக்கவும்';
      case 'te':
        return 'దరఖాస్తు చేయండి';
      case 'mr':
        return 'लागू करा';
      case 'gu':
        return 'લાગુ કરો';
      default:
        return 'Apply';
    }
  }

  // Additional commonly used strings for agricultural apps

  String get home {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ഹോം';
      case 'kn': // Kannada
        return 'ಮುಖ್ಯ';
      case 'hi':
        return 'होम';
      case 'pa':
        return 'ਹੋਮ';
      case 'bn':
        return 'হোম';
      case 'ta':
        return 'முகப்பு';
      case 'te':
        return 'హోమ్';
      case 'mr':
        return 'होम';
      case 'gu':
        return 'હોમ';
      default:
        return 'Home';
    }
  }

  String get profile {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'പ്രൊഫൈൽ';
      case 'kn': // Kannada
        return 'ಪ್ರೊಫೈಲ್';
      case 'hi':
        return 'प्रोफ़ाइल';
      case 'pa':
        return 'ਪ੍ਰੋਫਾਈਲ';
      case 'bn':
        return 'প্রোফাইল';
      case 'ta':
        return 'சுயவிவரம்';
      case 'te':
        return 'ప్రొఫైల్';
      case 'mr':
        return 'प्रोफाईल';
      case 'gu':
        return 'પ્રોફાઇલ';
      default:
        return 'Profile';
    }
  }

  String get settings {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ക്രമീകരണങ്ങൾ';
      case 'kn': // Kannada
        return 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು';
      case 'hi':
        return 'सेटिंग्स';
      case 'pa':
        return 'ਸੈਟਿੰਗਾਂ';
      case 'bn':
        return 'সেটিংস';
      case 'ta':
        return 'அமைப்புகள்';
      case 'te':
        return 'సెట్టింగ్స్';
      case 'mr':
        return 'सेटिंग्स';
      case 'gu':
        return 'સેટિંગ્સ';
      default:
        return 'Settings';
    }
  }

  String get logout {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ലോഗൗട്ട്';
      case 'kn': // Kannada
        return 'ಲಾಗೌಟ್';
      case 'hi':
        return 'लॉगआउट';
      case 'pa':
        return 'ਲੌਗਆਊਟ';
      case 'bn':
        return 'লগআউট';
      case 'ta':
        return 'வெளியேறு';
      case 'te':
        return 'లాగౌట్';
      case 'mr':
        return 'लॉगआउट';
      case 'gu':
        return 'લૉગઆઉટ';
      default:
        return 'Logout';
    }
  }

  String get search {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'തിരയുക';
      case 'kn': // Kannada
        return 'ಹುಡುಕಿ';
      case 'hi':
        return 'खोजें';
      case 'pa':
        return 'ਖੋਜੋ';
      case 'bn':
        return 'অনুসন্ধান';
      case 'ta':
        return 'தேடு';
      case 'te':
        return 'వెతకండి';
      case 'mr':
        return 'शोधा';
      case 'gu':
        return 'શોધો';
      default:
        return 'Search';
    }
  }

  String get cancel {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'റദ്ദാക്കുക';
      case 'kn': // Kannada
        return 'ರದ್ದುಮಾಡಿ';
      case 'hi':
        return 'रद्द करें';
      case 'pa':
        return 'ਰਦ ਕਰੋ';
      case 'bn':
        return 'বাতিল';
      case 'ta':
        return 'ரத்து செய்';
      case 'te':
        return 'రద్దు చేయి';
      case 'mr':
        return 'रद्द करा';
      case 'gu':
        return 'રદ કરો';
      default:
        return 'Cancel';
    }
  }

  String get save {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'സേവ് ചെയ്യുക';
      case 'kn': // Kannada
        return 'ಉಳಿಸಿ';
      case 'hi':
        return 'सेव करें';
      case 'pa':
        return 'ਸੇਵ ਕਰੋ';
      case 'bn':
        return 'সংরক্ষণ';
      case 'ta':
        return 'சேமிக்கவும்';
      case 'te':
        return 'సేవ్ చేయండి';
      case 'mr':
        return 'सेव्ह करा';
      case 'gu':
        return 'સેવ કરો';
      default:
        return 'Save';
    }
  }

  String get edit {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'എഡിറ്റ് ചെയ്യുക';
      case 'kn': // Kannada
        return 'ಸಂಪಾದಿಸಿ';
      case 'hi':
        return 'संपादित करें';
      case 'pa':
        return 'ਸੰਪਾਦਿਤ ਕਰੋ';
      case 'bn':
        return 'সম্পাদনা';
      case 'ta':
        return 'திருத்து';
      case 'te':
        return 'సవరించు';
      case 'mr':
        return 'संपादित करा';
      case 'gu':
        return 'સંપાદિત કરો';
      default:
        return 'Edit';
    }
  }

  String get delete {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ഇല്ലാതാക്കുക';
      case 'kn': // Kannada
        return 'ಅಳಿಸಿ';
      case 'hi':
        return 'हटाएं';
      case 'pa':
        return 'ਮਿਟਾਓ';
      case 'bn':
        return 'মুছে ফেলুন';
      case 'ta':
        return 'அழி';
      case 'te':
        return 'తొలగించు';
      case 'mr':
        return 'हटवा';
      case 'gu':
        return 'કાઢી નાખો';
      default:
        return 'Delete';
    }
  }

  String get loading {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'ലോഡിംഗ്...';
      case 'kn': // Kannada
        return 'ಲೋಡ್ ಆಗುತ್ತಿದೆ...';
      case 'hi':
        return 'लोड हो रहा है...';
      case 'pa':
        return 'ਲੋਡ ਹੋ ਰਿਹਾ ਹੈ...';
      case 'bn':
        return 'লোড হচ্ছে...';
      case 'ta':
        return 'ஏற்றுகிறது...';
      case 'te':
        return 'లోడ్ అవుతోంది...';
      case 'mr':
        return 'लोड होत आहे...';
      case 'gu':
        return 'લોડ થઈ રહ્યું છે...';
      default:
        return 'Loading...';
    }
  }

 
  String get success {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'വിജയം';
      case 'kn': // Kannada
        return 'ಯಶಸ್ಸು';
      case 'hi':
        return 'सफलता';
      case 'pa':
        return 'ਸਫਲਤਾ';
      case 'bn':
        return 'সফলতা';
      case 'ta':
        return 'வெற்றி';
      case 'te':
        return 'విజయం';
      case 'mr':
        return 'यश';
      case 'gu':
        return 'સફળતા';
      default:
        return 'Success';
    }
  }

  String get warning {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'മുന്നറിയിപ്പ്';
      case 'kn': // Kannada
        return 'ಎಚ್ಚರಿಕೆ';
      case 'hi':
        return 'चेतावनी';
      case 'pa':
        return 'ਚੇਤਾਵਨੀ';
      case 'bn':
        return 'সতর্কতা';
      case 'ta':
        return 'எச்சரிக்கை';
      case 'te':
        return 'హెచ్చరిక';
      case 'mr':
        return 'इशारा';
      case 'gu':
        return 'ચેતવણી';
      default:
        return 'Warning';
    }
  }

  String get retry {
    switch (locale.languageCode) {
      case 'ml': // Malayalam
        return 'വീണ്ടും ശ്രമിക്കുക';
      case 'kn': // Kannada
        return 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';
      case 'hi':
        return 'पुनः प्रयास करें';
      case 'pa':
        return 'ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ';
      case 'bn':
        return 'আবার চেষ্টা করুন';
      case 'ta':
        return 'மீண்டும் முயற்சிக்கவும்';
      case 'te':
        return 'మళ్లీ ప్రయత్నించండి';
      case 'mr':
        return 'पुन्हा प्रयत्न करा';
      case 'gu':
        return 'ફરીથી પ્રયાસ કરો';
      default:
        return 'Retry';
    }
  }
}

// Localization Delegate
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      'en',
      'hi',
      'pa',
      'bn',
      'ta',
      'te',
      'mr',
      'gu',
      'kn',
      'ml',
    ].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
