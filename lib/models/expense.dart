class Expense {
  int? id;
  String title;
  double amount;
  DateTime date;
  String category;
  String? description;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'description': description,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: map['category'],
      description: map['description'],
    );
  }

  @override
  String toString() {
    return 'Expense{id: $id, title: $title, amount: $amount, date: $date, category: $category, description: $description}';
  }
}