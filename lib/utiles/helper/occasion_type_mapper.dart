class OccasionTypeMapper {
  // Map of occasion types to their English and Arabic names
  static const Map<String, Map<String, String>> _occasionTypeMap = {
    'birthday': {
      'en': 'Birthday',
      'ar': 'عيد الميلاد',
    },
    'wedding': {
      'en': 'Wedding',
      'ar': 'الزفاف',
    },
    'graduation': {
      'en': 'Graduation',
      'ar': 'التخرج',
    },
    'anniversary': {
      'en': 'Anniversary',
      'ar': 'الذكرى السنوية',
    },
    'baby_shower': {
      'en': 'Baby Shower',
      'ar': 'حفل استقبال المولود',
    },
    'engagement': {
      'en': 'Engagement',
      'ar': 'الخطوبة',
    },
    'house_warming': {
      'en': 'House Warming',
      'ar': 'حفل استقبال المنزل الجديد',
    },
    'promotion': {
      'en': 'Promotion',
      'ar': 'الترقية',
    },
    'retirement': {
      'en': 'Retirement',
      'ar': 'التقاعد',
    },
    'new_job': {
      'en': 'New Job',
      'ar': 'وظيفة جديدة',
    },
    'holiday': {
      'en': 'Holiday',
      'ar': 'العطلة',
    },
    'other': {
      'en': 'Other',
      'ar': 'أخرى',
    },
  };

  /// Get the English name for an occasion type
  static String getEnglishName(String occasionType) {
    if (occasionType.isEmpty) return '';
    
    // Try exact match first
    String lowerType = occasionType.toLowerCase();
    if (_occasionTypeMap.containsKey(lowerType)) {
      return _occasionTypeMap[lowerType]!['en']!;
    }
    
    // Try partial match for common patterns
    for (String key in _occasionTypeMap.keys) {
      if (lowerType.contains(key) || key.contains(lowerType)) {
        return _occasionTypeMap[key]!['en']!;
      }
    }
    
    // If no match found, return the original type
    return occasionType;
  }

  /// Get the Arabic name for an occasion type
  static String getArabicName(String occasionType) {
    if (occasionType.isEmpty) return '';
    
    // Try exact match first
    String lowerType = occasionType.toLowerCase();
    if (_occasionTypeMap.containsKey(lowerType)) {
      return _occasionTypeMap[lowerType]!['ar']!;
    }
    
    // Try partial match for common patterns
    for (String key in _occasionTypeMap.keys) {
      if (lowerType.contains(key) || key.contains(lowerType)) {
        return _occasionTypeMap[key]!['ar']!;
      }
    }
    
    // If no match found, return the original type
    return occasionType;
  }

  /// Get both English and Arabic names for an occasion type
  static Map<String, String> getBilingualNames(String occasionType) {
    final typeData = _occasionTypeMap[occasionType.toLowerCase()];
    if (typeData != null) {
      return {
        'en': typeData['en']!,
        'ar': typeData['ar']!,
      };
    }
    // If type not found in map, return the original type for both languages
    return {
      'en': occasionType,
      'ar': occasionType,
    };
  }

  /// Get all available occasion types
  static List<String> getAllOccasionTypes() {
    return _occasionTypeMap.keys.toList();
  }
}
