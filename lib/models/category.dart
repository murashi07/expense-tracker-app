class Category {
  String name;
  String icon; // Store icon name (e.g., 'food', 'transport') or path

  Category({required this.name, required this.icon});
}

// Example Category Data (you can load this from a file or database later)
List<Category> predefinedCategories = [
  Category(name: 'Food', icon: 'fastfood'),
  Category(name: 'Transport', icon: 'directions_bus'),
  Category(name: 'Rent', icon: 'home'),
  Category(name: 'Entertainment', icon: 'movie'),
  Category(name: 'Education', icon: 'school'),
  Category(name: 'Shopping', icon: 'shopping_cart'),
  Category(name: 'Other', icon: 'more_horiz'),
];