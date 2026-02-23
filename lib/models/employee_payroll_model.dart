// class EmployeePayrollModel {
//   final String employeeId;
//   final String employeeName;
//   final String department;
//   final String designation;

//   final int month;
//   final int year;

//   final double baseSalary;

//   final int totalDays;
//   int workedDays;
//   int lopDays;

//   double bonus;
//   double overtime;

//   bool isPaid;
//   DateTime? paidDate;

//   EmployeePayrollModel({
//     required this.employeeId,
//     required this.employeeName,
//     required this.department,
//     required this.designation,
//     required this.month,
//     required this.year,
//     required this.baseSalary,
//     required this.totalDays,
//     required this.workedDays,
//     required this.lopDays,
//     this.bonus = 0,
//     this.overtime = 0,
//     this.isPaid = false,
//     this.paidDate,
//   });

//   double get perDaySalary => baseSalary / totalDays;

//   double get netSalary =>
//       (perDaySalary * workedDays) + bonus + overtime;

//   String get monthYear => "$month / $year";

//   String get paymentText => isPaid ? "PAID" : "UNPAID";

//   String get formattedPaidDate {
//     if (paidDate == null) return "-";
//     return "${paidDate!.day.toString().padLeft(2, '0')}-"
//         "${paidDate!.month.toString().padLeft(2, '0')}-"
//         "${paidDate!.year}";
//   }
// }


class EmployeePayrollModel {
  final String employeeId;
  final String employeeName;
  final String department;
  final String designation;

  final int month;
  final int year;

  final double baseSalary;

  int totalDays;
  int workedDays;
  int lopDays;

  double bonus;
  double overtime;

  bool isPaid;
  DateTime? paidDate;

  EmployeePayrollModel({
    required this.employeeId,
    required this.employeeName,
    required this.department,
    required this.designation,
    required this.month,
    required this.year,
    required this.baseSalary,
    this.totalDays = 30,
    this.workedDays = 0,
    this.lopDays = 0,
    this.bonus = 0,
    this.overtime = 0,
    this.isPaid = false,
    this.paidDate,
  });

  double get perDaySalary => baseSalary / totalDays;

  double get netSalary =>
      (workedDays * perDaySalary) + bonus + overtime;

  String get formattedPaidDate {
    if (paidDate == null) return "-";
    return "${paidDate!.day}-${paidDate!.month}-${paidDate!.year}";
  }
}
