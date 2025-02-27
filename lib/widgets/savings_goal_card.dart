import 'package:expense_tracker_app/models/saving_goal.dart';
import 'package:expense_tracker_app/services/database_helper.dart';
import 'package:expense_tracker_app/utils/currency_formatter.dart';
import 'package:expense_tracker_app/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class SavingsGoalCard extends StatelessWidget {
  final SavingGoal goal;
  final VoidCallback onSavingsGoalUpdated;
  final VoidCallback onSavingsGoalDeleted;

  const SavingsGoalCard({super.key,
    required this.goal,
    required this.onSavingsGoalUpdated,
    required this.onSavingsGoalDeleted,
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
                  goal.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${currencyFormatter.format(goal.currentAmount)} / ${currencyFormatter.format(goal.targetAmount)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text('Deadline: ${dateFormatter.format(goal.deadline)}'),
            if (goal.description != null && goal.description!.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Text('Description: ${goal.description}'),
            ],
            LinearProgressIndicator(
              value: goal.progress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditSavingsGoalDialog(context, goal);
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
                          content: const Text("Are you sure you want to delete this savings goal?"),
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
                      await DatabaseHelper.instance.deleteSavingGoal(goal.id!);
                      onSavingsGoalDeleted(); // Callback to refresh the list
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Savings goal deleted')),
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

  void _showEditSavingsGoalDialog(BuildContext context, SavingGoal goal) {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController(text: goal.title);
    final _targetAmountController = TextEditingController(text: goal.targetAmount.toString());
    final _currentAmountController = TextEditingController(text: goal.currentAmount.toString());
    final _deadlineController = TextEditingController(text: dateFormatter.format(goal.deadline));
    final _descriptionController = TextEditingController(text: goal.description);
    DateTime _deadlineDate = goal.deadline;

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _deadlineDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
      );
      if (picked != null && picked != _deadlineDate) {
        _deadlineDate = picked;
        _deadlineController.text = dateFormatter.format(_deadlineDate);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Savings Goal'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _targetAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Target Amount'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Target amount required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid amount';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _currentAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Current Amount'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Current amount required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid amount';
                      }
                      return null;
                    },
                  ),
                  ListTile(
                    title: const Text('Deadline'),
                    subtitle: Text('${_deadlineDate.toLocal()}'.split(' ')[0]),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
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
                  final updatedGoal = SavingGoal(
                    id: goal.id,
                    title: _titleController.text,
                    targetAmount: double.parse(_targetAmountController.text),
                    currentAmount: double.parse(_currentAmountController.text),
                    deadline: _deadlineDate,
                    description: _descriptionController.text,
                  );
                  await DatabaseHelper.instance.updateSavingGoal(updatedGoal);
                  Navigator.of(context).pop();
                  onSavingsGoalUpdated(); // Callback to refresh the list
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Savings goal updated')),
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