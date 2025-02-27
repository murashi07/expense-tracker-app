import 'package:expense_tracker_app/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class TransactionSummary extends StatelessWidget {
  const TransactionSummary({
    super.key,
    required double totalExpenses,
    required double totalIncome,
  })  : _totalExpenses = totalExpenses,
        _totalIncome = totalIncome;

  final double _totalExpenses;
  final double _totalIncome;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Expenses: ${currencyFormatter.format(_totalExpenses)}',
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 8),
            Text(
              'Income: ${currencyFormatter.format(_totalIncome)}',
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              'Balance: ${currencyFormatter.format(_totalIncome - _totalExpenses)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}