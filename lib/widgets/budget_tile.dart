import 'package:expense_tracker_app/models/budget.dart';
import 'package:expense_tracker_app/services/database_helper.dart';
import 'package:expense_tracker_app/utils/currency_formatter.dart';
import 'package:expense_tracker_app/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class BudgetTile extends StatelessWidget {
  final Budget budget;
  final VoidCallback onBudgetUpdated;
  final VoidCallback onBudgetDeleted;

  const BudgetTile({super.key,
    required this.budget,
    required this.onBudgetUpdated,
    required this.onBudgetDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Category: ${budget.category}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  currencyFormatter.format(budget.amount),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text('Start Date: ${dateFormatter.format(budget.startDate)}'),
            Text('End Date: ${dateFormatter.format(budget.endDate)}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditBudgetDialog(context, budget);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    bool confirmDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm Delete"),
                          content: const Text("Are you sure you want to delete this budget?"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: const Text("Delete"),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        );
                      },
                    ) ?? false;

                    if (confirmDelete) {
                      await DatabaseHelper.instance.deleteBudget(budget.id!);
                      onBudgetDeleted(); // Callback to refresh the list
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Budget deleted')),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBudgetDialog(BuildContext context, Budget budget) {
    final _formKey = GlobalKey<FormState>();
    String _category = budget.category;
    final _amountController = TextEditingController(text: budget.amount.toString());
    DateTime _startDate = budget.startDate;
    DateTime _endDate = budget.endDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Budget'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Category'),
                    value: _category,
                    items: <String>['Food', 'Transport', 'Rent', 'Entertainment']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      _category = newValue!;
                    },
                    validator: (value) => value == null ? 'Category required' : null,
                  ),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Amount required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid amount';
                      }
                      return null;
                    },
                  ),
                  ListTile(
                    title: const Text('Start Date'),
                    subtitle: Text('${_startDate.toLocal()}'.split(' ')[0]),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2025),
                      );
                      if (pickedDate != null && pickedDate != _startDate) {
                        _startDate = pickedDate;
                      }
                    },
                  ),
                  ListTile(
                    title: const Text('End Date'),
                    subtitle: Text('${_endDate.toLocal()}'.split(' ')[0]),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2025),
                      );
                      if (pickedDate != null && pickedDate != _endDate) {
                        _endDate = pickedDate;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final updatedBudget = Budget(
                    id: budget.id,
                    category: _category,
                    amount: double.parse(_amountController.text),
                    startDate: _startDate,
                    endDate: _endDate,
                  );
                  await DatabaseHelper.instance.updateBudget(updatedBudget);
                  Navigator.of(context).pop();
                  onBudgetUpdated(); // Callback to refresh the list
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Budget updated')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}