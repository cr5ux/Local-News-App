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
    'Enviroment',
    'Science',
    'Local',
    'Fashion', // New category
    'International', // New category
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
    return allCategories
        .where((category) => userPreferences[category] == true)
        .toList();
  }

  static List<String> getUnselectedCategories() {
    return allCategories
        .where((category) => userPreferences[category] == false)
        .toList();
  }

  // Toggle user preference for a category
  static void togglePreference(String category) {
    if (userPreferences.containsKey(category)) {
      userPreferences[category] = !userPreferences[category]!;
    }
  }

  // Map category names to image asset paths or URLs
  static const Map<String, String> categoryImages = {
    'Politics':
        'https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'Sports':
        'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Placeholder URL
    'Entertainment':
        'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Placeholder URL
    'Technology':
        'https://images.unsplash.com/photo-1510519138101-570d1dca3d66?q=80&w=1747&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Placeholder URL
    'Health':
        'https://images.unsplash.com/photo-1494597564530-871f2b93ac55?q=80&w=1713&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Placeholder URL
    'Education':
        'https://images.unsplash.com/photo-1517673132405-a56a62b18caf?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fGVkdWNhdGlvbnxlbnwwfHwwfHx8MA%3D%3D', // Placeholder URL
    'Business':
        'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Placeholder URL
    'Environment':
        'https://images.unsplash.com/photo-1466611653911-95081537e5b7?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Placeholder URL
    'Science':
        'https://images.unsplash.com/photo-1628595351029-c2bf17511435?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Placeholder URL
    'Local':
        'https://images.unsplash.com/flagged/photo-1572644973628-e9be84915d59?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8ZXRoaW9waWF8ZW58MHx8MHx8fDA%3D', // Placeholder URL
    'Fashion':
        'https://images.unsplash.com/photo-1536924430914-91f9e2041b83?q=80&w=1888&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Placeholder URL
    'International':
        'https://images.unsplash.com/photo-1668120084348-efc2ba0ad31d?q=80&w=1742&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Placeholder URL
    // Add mappings for other categories as needed
  };
}
