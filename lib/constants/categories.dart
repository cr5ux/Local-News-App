class NewsCategories {
  // List of all available categories
  static const List<String> allCategories = [
    'Politics',
    'Sports',
    'Entertainment',
    'Technology',
    'Health',
    'Education',
    'Business',
    'Environment',
    'Science',
    'Local',
    'Fashion',       // New category
    'International',  // New category
  ];
  
  // Map to store user preferences (interested or not)
  static Map<String, bool> userPreferences = {};
  
  // Initialize preferences (all false by default)
  static void initPreferences() {
    for (var category in allCategories) {
      userPreferences[category] = false;
    }
  }
  
  // Get categories the user is interested in
  static List<String> getInterestedCategories() {
    return allCategories.where((category) => 
      userPreferences[category] == true).toList();
  }
  
  // Toggle user preference for a category
  static void togglePreference(String category) {
    if (userPreferences.containsKey(category)) {
      userPreferences[category] = !userPreferences[category]!;
    }
  }
}