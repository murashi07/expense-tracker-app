import 'package:expense_tracker_app/models/saving_goal.dart';
import 'package:expense_tracker_app/services/database_helper.dart';
import 'package:expense_tracker_app/widgets/no_data.dart';
import 'package:expense_tracker_app/widgets/savings_goal_card.dart';
import 'package:flutter/material.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  List<SavingGoal> _savingsGoals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavingsGoals();
  }

  Future<void> _loadSavingsGoals() async {
    setState(() {
      _isLoading = true;
    });
    _savingsGoals = await DatabaseHelper.instance.getSavingGoals();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Goals'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _savingsGoals.isEmpty
          ? const NoData(message: 'No savings goals set yet.')
          : ListView.builder(
        itemCount: _savingsGoals.length,
        itemBuilder: (context, index) {
          final goal = _savingsGoals[index];
          return SavingsGoalCard(
            goal: goal,
            onSavingsGoalUpdated: () async {
              await _loadSavingsGoals();
            },
            onSavingsGoalDeleted: () async {
              await _loadSavingsGoals();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSavingsGoalDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddSavingsGoalDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController();
    final _targetAmountController = TextEditingController();
    final _currentAmountController = TextEditingController();
    final _deadlineController = TextEditingController();
    final _descriptionController = TextEditingController();
    DateTime _deadlineDate = DateTime.now().add(const Duration(days: 30));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Savings Goal'),
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
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _deadlineDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2025),
                      );
                      if (pickedDate != null && pickedDate != _deadlineDate) {
                        setState(() {
                          _deadlineDate = pickedDate;
                          _deadlineController.text =
                          '${_deadlineDate.toLocal()}'.split(' ')[0];
                        });
                      }
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
                  final newGoal = SavingGoal(
                    title: _titleController.text,
                    targetAmount: double.parse(_targetAmountController.text),
                    currentAmount: double.parse(_currentAmountController.text),
                    deadline: _deadlineDate,
                    description: _descriptionController.text,
                  );
                  await DatabaseHelper.instance.insertSavingGoal(newGoal);
                  Navigator.of(context).pop();
                  await _loadSavingsGoals();
                }
              },
            ),
          ],
        );
      },
    );
  }
}