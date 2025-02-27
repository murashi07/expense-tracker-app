import 'package:expense_tracker_app/models/expense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/utils/currency_formatter.dart';

class ReportScreen extends StatefulWidget {
  final List<Expense> expenses;

  const ReportScreen({Key? key, required this.expenses}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _selectedReportType = 'Category';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedReportType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedReportType = newValue!;
                });
              },
              items: <String>['Category', 'Date', 'Amount']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Expanded(
              child: _buildReport(_selectedReportType),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReport(String reportType) {
    switch (reportType) {
      case 'Category':
        return _buildCategoryReport();
      case 'Date':
        return _buildDateReport();
      case 'Amount':
        return _buildAmountReport();
      default:
        return const Center(child: Text('Invalid report type'));
    }
  }

  Widget _buildCategoryReport() {
    // Group expenses by category and sum the amounts
    Map<String, double> categoryTotals = {};
    for (var expense in widget.expenses) {
      if (categoryTotals.containsKey(expense.category)) {
        categoryTotals[expense.category] =
            categoryTotals[expense.category]! + expense.amount;
      } else {
        categoryTotals[expense.category] = expense.amount;
      }
    }

    List<PieChartSectionData> sections = categoryTotals.entries.map((entry) {
      return PieChartSectionData(
        color: Colors.primaries[categoryTotals.keys.toList().indexOf(entry.key) % Colors.primaries.length],
        value: entry.value,
        title: '${entry.key}\n${currencyFormatter.format(entry.value)}',
        radius: 50,
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 0,
      ),
    );
  }

  Widget _buildDateReport() {
    return const Center(child: Text('Date Report Coming Soon'));
  }

  Widget _buildAmountReport() {
    return const Center(child: Text('Amount Report Coming Soon'));
  }
}