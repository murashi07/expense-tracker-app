import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/widgets/expense_card.dart';
import 'package:expense_tracker_app/widgets/no_data.dart';
import 'package:flutter/material.dart';

class ExpenseListScreen extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseListScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return expenses.isEmpty
        ? const NoData(message: 'No expenses added yet.')
        : ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return ExpenseCard(expense: expense);
      },
    );
  }
}