import 'package:expense_tracker_app/models/category.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  final List<Category> categories;
  final String selectedCategory;
  final Function(Category) onCategorySelected;

  const CategorySelector({super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 60.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.categories.length,
            itemBuilder: (context, index) {
              final category = widget.categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    widget.onCategorySelected(category);
                  },
                  child: Chip(
                    label: Text(category.name),
                    avatar: CircleAvatar(
                      child: Icon(Icons.icecream),
                    ),
                    backgroundColor: widget.selectedCategory == category.name
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}