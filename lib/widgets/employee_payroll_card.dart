import 'package:flutter/material.dart';
import '../models/employee_payroll_model.dart';

class EmployeePayrollCard extends StatelessWidget {
  final EmployeePayrollModel emp;
  final VoidCallback onView;
  final VoidCallback? onEdit;
  final VoidCallback? onConfirmPaid;

  const EmployeePayrollCard({
    super.key,
    required this.emp,
    required this.onView,
    this.onEdit,
    this.onConfirmPaid,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  emp.employeeName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  emp.isPaid ? "PAID" : "UNPAID",
                  style: TextStyle(
                    color: emp.isPaid ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text("ID: ${emp.employeeId}"),
            Text("Department: ${emp.department}"),
            Text("Designation: ${emp.designation}"),
            Text("Month: ${emp.month}/${emp.year}"),
            Text("Net Salary: ₹${emp.netSalary.toStringAsFixed(0)}"),

            const SizedBox(height: 10),

            SizedBox(
              height: 36,
              child: Row(
                children: [
                  if (onEdit != null) ...[
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: onEdit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: const Text("Edit", overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (onConfirmPaid != null) ...[
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: onConfirmPaid,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: const Text("Confirm Paid", overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: OutlinedButton(
                        onPressed: onView,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: const Text("View", overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}