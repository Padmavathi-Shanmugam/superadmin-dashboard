



// import 'package:flutter/material.dart';
// import '../models/employee_payroll_model.dart';
// import '../widgets/employee_payroll_card.dart';

// class EmployeePayrollPage extends StatefulWidget {
//   const EmployeePayrollPage({super.key});

//   @override
//   State<EmployeePayrollPage> createState() => _EmployeePayrollPageState();
// }

// class _EmployeePayrollPageState extends State<EmployeePayrollPage> {
//   late EmployeePayrollModel emp;

//   @override
//   void initState() {
//     super.initState();
//     emp = EmployeePayrollModel(
//       employeeId: "EMP001",
//       employeeName: "Sujitha",
//       department: "IT",
//       designation: "Developer",
//       month: 2,
//       year: 2026,
//       baseSalary: 25000,
//       totalDays: 28,
//       workedDays: 26,
//       lopDays: 2,
//     );
//   }

//   // ================= EDIT POPUP =================
//   void _editPayroll(EmployeePayrollModel emp) {
//     final workedCtrl =
//         TextEditingController(text: emp.workedDays.toString());
//     final lopCtrl = TextEditingController(text: emp.lopDays.toString());
//     final bonusCtrl = TextEditingController(text: emp.bonus.toString());
//     final otCtrl = TextEditingController(text: emp.overtime.toString());

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Edit Payroll"),
//         content: SingleChildScrollView(
//           child: Column(
//             children: [
//               _field("Worked Days", workedCtrl),
//               _field("LOP Days", lopCtrl),
//               _field("Bonus", bonusCtrl),
//               _field("Overtime", otCtrl),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel")),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 emp.workedDays = int.parse(workedCtrl.text);
//                 emp.lopDays = int.parse(lopCtrl.text);
//                 emp.bonus = double.parse(bonusCtrl.text);
//                 emp.overtime = double.parse(otCtrl.text);
//               });
//               Navigator.pop(context);
//             },
//             child: const Text("Save"),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _field(String label, TextEditingController ctrl) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextField(
//         controller: ctrl,
//         keyboardType: TextInputType.number,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }

//   // ================= VIEW =================
//   void _viewPayroll(EmployeePayrollModel emp) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Payroll Full Details"),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Employee: ${emp.employeeName}"),
//               Text("ID: ${emp.employeeId}"),
//               Text("Department: ${emp.department}"),
//               Text("Designation: ${emp.designation}"),
//               const Divider(),
//               Text("Month: ${emp.month} / ${emp.year}"),
//               Text("Base Salary: ₹${emp.baseSalary}"),
//               Text("Total Days: ${emp.totalDays}"),
//               Text("Worked Days: ${emp.workedDays}"),
//               Text("LOP Days: ${emp.lopDays}"),
//               Text("Per Day Salary: ₹${emp.perDaySalary.toStringAsFixed(0)}"),
//               Text("Bonus: ₹${emp.bonus}"),
//               Text("Overtime: ₹${emp.overtime}"),
//               const Divider(),
//               Text("Net Salary: ₹${emp.netSalary.toStringAsFixed(0)}"),
//               Text("Paid Date: ${emp.formattedPaidDate}"),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Close"))
//         ],
//       ),
//     );
//   }

//   void _confirmPaid(EmployeePayrollModel emp) {
//     setState(() {
//       emp.isPaid = true;
//       emp.paidDate = DateTime.now();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Employee Payroll")),
//       body: EmployeePayrollCard(
//         emp: emp,
//         onView: () => _viewPayroll(emp),
//         onEdit: () => _editPayroll(emp),
//         onConfirmPaid: () => _confirmPaid(emp),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../models/employee_payroll_model.dart';
import '../widgets/employee_payroll_card.dart';

class EmployeePayrollPage extends StatefulWidget {
  const EmployeePayrollPage({super.key});

  @override
  State<EmployeePayrollPage> createState() => _EmployeePayrollPageState();
}

class _EmployeePayrollPageState extends State<EmployeePayrollPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  List<EmployeePayrollModel> allEmployees = [];
  List<EmployeePayrollModel> filteredEmployees = [];

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    allEmployees = [
      EmployeePayrollModel(
        employeeId: "EMP001",
        employeeName: "Sujitha",
        department: "IT",
        designation: "Developer",
        month: 2,
        year: 2026,
        baseSalary: 25000,
        totalDays: 28,
        workedDays: 26,
        lopDays: 2,
      ),
      EmployeePayrollModel(
        employeeId: "EMP002",
        employeeName: "Rahul",
        department: "HR",
        designation: "Manager",
        month: 2,
        year: 2026,
        baseSalary: 30000,
        totalDays: 28,
        workedDays: 28,
        lopDays: 0,
      ),
    ];

    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchCtrl.text.toLowerCase();

    setState(() {
      filteredEmployees = allEmployees.where((emp) {
        final matchesSearch =
            emp.employeeName.toLowerCase().contains(query) ||
                emp.designation.toLowerCase().contains(query);

        final matchesDate =
            emp.month == selectedMonth && emp.year == selectedYear;

        return matchesSearch && matchesDate;
      }).toList();
    });
  }

  void _pickMonthYear() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(selectedYear, selectedMonth),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      helpText: "Select Month & Year",
    );

    if (picked != null) {
      setState(() {
        selectedMonth = picked.month;
        selectedYear = picked.year;
      });
      _applyFilters();
    }
  }

  // ================= VIEW =================
  void _viewPayroll(EmployeePayrollModel emp) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Payroll Full Details"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Employee: ${emp.employeeName}",
                   style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("ID: ${emp.employeeId}"),
              Text("Department: ${emp.department}"),
              Text("Designation: ${emp.designation}"),
              const Divider(),
              Text("Month/Year: ${emp.month}/${emp.year}"),
              Text("Base Salary: ₹${emp.baseSalary.toStringAsFixed(0)}"),
              Text("Total Days: ${emp.totalDays}"),
              Text("Worked Days: ${emp.workedDays}"),
              Text("LOP Days: ${emp.lopDays}"),
              Text("Per Day Salary: ₹${emp.perDaySalary.toStringAsFixed(0)}"),
              Text("Bonus: ₹${emp.bonus.toStringAsFixed(0)}"),
              Text("Overtime: ₹${emp.overtime.toStringAsFixed(0)}"),
              const Divider(),
              Text("Net Salary: ₹${emp.netSalary.toStringAsFixed(0)}",
                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("Status: ${emp.isPaid ? 'Paid' : 'Unpaid'}",
                   style: TextStyle(
                     color: emp.isPaid ? Colors.green : Colors.orange,
                     fontWeight: FontWeight.bold,
                   )),
              Text("Paid Date: ${emp.formattedPaidDate}"),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"))
        ],
      ),
    );
  }

  void _confirmPaid(EmployeePayrollModel emp) {
    setState(() {
      emp.isPaid = true;
      emp.paidDate = DateTime.now();
    });
  }

  void _editPayroll(EmployeePayrollModel emp) {
    final workedCtrl = TextEditingController(text: emp.workedDays.toString());
    final lopCtrl = TextEditingController(text: emp.lopDays.toString());
    final bonusCtrl = TextEditingController(text: emp.bonus.toString());
    final otCtrl = TextEditingController(text: emp.overtime.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Payroll"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _field("Worked Days", workedCtrl),
              _field("LOP Days", lopCtrl),
              _field("Bonus", bonusCtrl),
              _field("Overtime", otCtrl),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                emp.workedDays = int.parse(workedCtrl.text);
                emp.lopDays = int.parse(lopCtrl.text);
                emp.bonus = double.parse(bonusCtrl.text);
                emp.overtime = double.parse(otCtrl.text);
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Employee Payroll")),
      body: Column(
        children: [

          // ================= SEARCH + MONTH =================
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [

                // Search Field
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => _applyFilters(),
                    decoration: const InputDecoration(
                      hintText: "Search by name / role",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Month Picker
                ElevatedButton.icon(
                  onPressed: _pickMonthYear,
                  icon: const Icon(Icons.calendar_month),
                  label: Text("$selectedMonth/$selectedYear"),
                )
              ],
            ),
          ),

          // ================= LIST =================
          Expanded(
            child: filteredEmployees.isEmpty
                ? const Center(child: Text("No payroll records found"))
                : ListView.builder(
              itemCount: filteredEmployees.length,
              itemBuilder: (context, index) {
                final emp = filteredEmployees[index];
                return EmployeePayrollCard(
                  emp: emp,
                  onView: () => _viewPayroll(emp),
                  onEdit: emp.isPaid ? null : () => _editPayroll(emp),
                  onConfirmPaid: emp.isPaid ? null : () => _confirmPaid(emp),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}