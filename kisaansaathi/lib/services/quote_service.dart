import 'dart:math';

class QuoteService {
  static final List<Map<String, String>> _farmingQuotes = [
    {
      'quote': 'खेती करना सबसे अच्छा काम है, क्योंकि यह हमें प्रकृति के करीब लाता है।',
      'quote_en': 'Farming is the noblest of all professions, as it brings us closer to nature.',
      'author': 'भारतीय कहावत',
      'author_en': 'Indian Proverb'
    },
    {
      'quote': 'किसान देश की रीढ़ हैं।',
      'quote_en': 'Farmers are the backbone of the nation.',
      'author': 'महात्मा गांधी',
      'author_en': 'Mahatma Gandhi'
    },
    {
      'quote': 'जो बोओगे वही काटोगे।',
      'quote_en': 'As you sow, so shall you reap.',
      'author': 'संस्कृत सूक्ति',
      'author_en': 'Sanskrit Saying'
    },
    {
      'quote': 'कृषि ही संस्कृति है।',
      'quote_en': 'Agriculture is culture.',
      'author': 'भारतीय दर्शन',
      'author_en': 'Indian Philosophy'
    },
    {
      'quote': 'धरती माता है, उसका सम्मान करो।',
      'quote_en': 'Earth is our mother, respect her.',
      'author': 'वैदिक ज्ञान',
      'author_en': 'Vedic Wisdom'
    },
    {
      'quote': 'अच्छी फसल के लिए मेहनत और धैर्य दोनों जरूरी हैं।',
      'quote_en': 'Good harvest requires both hard work and patience.',
      'author': 'किसान की सीख',
      'author_en': 'Farmer\'s Wisdom'
    },
    {
      'quote': 'जल ही जीवन है, इसे बचाएं।',
      'quote_en': 'Water is life, conserve it.',
      'author': 'पर्यावरण संदेश',
      'author_en': 'Environmental Message'
    },
    {
      'quote': 'जैविक खेती से स्वस्थ भविष्य।',
      'quote_en': 'Organic farming for a healthy future.',
      'author': 'आधुनिक कृषि',
      'author_en': 'Modern Agriculture'
    },
    {
      'quote': 'मिट्टी की सेहत, फसल की सेहत।',
      'quote_en': 'Healthy soil, healthy crops.',
      'author': 'कृषि विज्ञान',
      'author_en': 'Agricultural Science'
    },
    {
      'quote': 'तकनीक और परंपरा का संगम ही सफलता की कुंजी है।',
      'quote_en': 'The blend of technology and tradition is the key to success.',
      'author': 'आधुनिक किसान',
      'author_en': 'Modern Farmer'
    },
  ];

  static Map<String, String> getDailyQuote() {
    final random = Random();
    return _farmingQuotes[random.nextInt(_farmingQuotes.length)];
  }

  static Map<String, String> getRandomQuote() {
    return getDailyQuote();
  }
}
