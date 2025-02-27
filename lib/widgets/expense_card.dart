import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/services/database_helper.dart';
import 'package:expense_tracker_app/utils/currency_formatter.dart';
import 'package:expense_tracker_app/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({super.key, required this.expense});

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
                  expense.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  currencyFormatter.format(expense.amount),
                  style: TextStyle(
                    fontSize: 16,
                    color: expense.amount > 0 ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(dateFormatter.format(expense.date)),
            const SizedBox(height: 8.0),
            Text('Category: ${expense.category}'),
            if (expense.description != null && expense.description!.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Text('Description: ${expense.description}'),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Implement edit expense functionality
                    _showEditExpenseDialog(context, expense);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    // Show a confirmation dialog
                    bool confirmDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm Delete"),
                          content: const Text("Are you sure you want to delete this expense?"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop(false); // Return false if cancelled
                              },
                            ),
                            TextButton(
                              child: const Text("Delete"),
                              onPressed: () {
                                Navigator.of(context).pop(true); // Return true if confirmed
                              },
                            ),
                          ],
                        );
                      },
                    ) ?? false; // Handle if the dialog is dismissed

                    if (confirmDelete) {
                      await DatabaseHelper.instance.deleteExpense(expense.id!);
                      // Refresh the expense list (you might want to use a callback or stream)
                      // For example:
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Expense deleted')),
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

  void _showEditExpenseDialog(BuildContext context, Expense expense) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _titleController = TextEditingController(text: expense.title);
    final TextEditingController _amountController =
    TextEditingController(text: expense.amount.toString());
    final TextEditingController _dateController =
    TextEditingController(text: dateFormatter.format(expense.date));
    final TextEditingController _descriptionController =
    TextEditingController(text: expense.description);

    DateTime _selectedDate = expense.date;
    String _selectedCategory = expense.category;

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
      );
      if (picked != null && picked != _selectedDate) {
        //ignore: curly_braces_in_flow_control_structures
        _selectedDate = picked;
        _dateController.text = dateFormatter.format(_selectedDate);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Expense'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                  ),
                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: <String>['Food', 'Transport', 'Rent', 'Entertainment']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      _selectedCategory = newValue!;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description (Optional)'),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
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
                  final updatedExpense = Expense(
                    id: expense.id,
                    title: _titleController.text,
                    amount: double.parse(_amountController.text),
                    date: _selectedDate,
                    category: _selectedCategory,
                    description: _descriptionController.text,
                  );

                  await DatabaseHelper.instance.updateExpense(updatedExpense);

                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Expense updated')),
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