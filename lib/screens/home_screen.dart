import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/screens/add_expense_screen.dart';
import 'package:expense_tracker_app/screens/budget_screen.dart';
import 'package:expense_tracker_app/screens/expense_list_screen.dart';
import 'package:expense_tracker_app/screens/report_screen.dart';
import 'package:expense_tracker_app/screens/savings_screen.dart';
import 'package:expense_tracker_app/screens/settings_screen.dart';
import 'package:expense_tracker_app/services/database_helper.dart';
import 'package:expense_tracker_app/widgets/transaction_summary.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Expense> _expenses = [];
  double _totalExpenses = 0.0;
  double _totalIncome = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    setState(() {
      _isLoading = true;
    });
    _expenses = await DatabaseHelper.instance.getExpenses();
    _calculateTotals();
    setState(() {
      _isLoading = false;
    });
  }

  void _calculateTotals() {
    _totalExpenses = 0.0;
    _totalIncome = 0.0;
    for (var expense in _expenses) {
      if (expense.amount > 0) {
        _totalExpenses += expense.amount;
      } else {
        _totalIncome += expense.amount.abs();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
        index: _currentIndex,
        children: [
          //Dashboard
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TransactionSummary(
                    totalExpenses: _totalExpenses, totalIncome: _totalIncome),
                const SizedBox(height: 20),
                Expanded(
                  child: ExpenseListScreen(expenses: _expenses),
                ),
              ],
            ),
          ),
          const BudgetScreen(),
          const SavingsScreen(),
          ReportScreen(expenses: _expenses),
        ],
      ),
      floatingActionButton: OpenContainer(
        transitionDuration: const Duration(milliseconds: 500),
        transitionType: ContainerTransitionType.fade,
        openBuilder: (BuildContext context, VoidCallback _) => AddExpenseScreen(
          onExpenseAdded: (newExpense) async {
            await _loadExpenses();
          },
        ),
        closedElevation: 6.0,
        closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return FloatingActionButton(
            onPressed: openContainer,
            child: const Icon(Icons.add),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Budget'),
          BottomNavigationBarItem(icon: Icon(Icons.savings), label: 'Savings'),
          BottomNavigationBarItem(icon: Icon(Icons.insert_chart), label: 'Reports'),
        ],
      ),
    );
  }
}