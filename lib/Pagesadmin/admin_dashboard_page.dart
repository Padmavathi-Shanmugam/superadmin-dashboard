// import 'package:flutter/material.dart';
// import 'package:serv_app/Pagesusers/login_page.dart';
// import 'company_setup_page.dart';
// import 'live_attendance_page.dart';
// import 'leave_approval_screen.dart';
// import 'employee_management_page.dart';
// import 'attendance_report_page.dart';
// import 'others_page.dart';
// import 'settings_page.dart'; // 
// import 'package:serv_app/Pagesadmin/employee_onboarding_page.dart';

// class AdminDashboard extends StatefulWidget {
//   final CompanyProfile companyProfile;

//   const AdminDashboard({super.key, required this.companyProfile});

//   @override
//   State<AdminDashboard> createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   int selectedIndex = 0;

//   static const Color kPurple = Color(0xFF6A1B9A);

//   final List<String> pageTitles = [
//     "Live Attendance",
//     "Request and Leave Approvals",
//     "Employee Onboarding",
//     "Employee Management",
//     "Attendance Reports",
//     "Others",
//     "Settings",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(pageTitles[selectedIndex]),
//         backgroundColor: kPurple,
//         actions: [
//           // IconButton(
//           //   icon: const Icon(Icons.notifications_none),
//           //   onPressed: () {},
//           // ),
//           PopupMenuButton(
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 child: const Row(
//                   children: [
//                     Icon(Icons.logout, color: Colors.red),
//                     SizedBox(width: 8),
//                     Text("Logout"),
//                   ],
//                 ),
//                 onTap: () {
//                   Future.delayed(Duration.zero, () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const LoginPage(),
//                       ),
//                     );
//                   });
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             _buildDrawerHeader(),
//             _buildDrawerItem(Icons.check_circle, "Live Attendance", 0),
//             _buildDrawerItem(Icons.calendar_today, "Request and Leave Approvals", 1),
//             _buildDrawerItem(Icons.how_to_reg, "Employee Onboarding", 2),
//             _buildDrawerItem(Icons.group, "Employee Management", 3),
//             _buildDrawerItem(Icons.bar_chart, "Attendance Reports", 4),
//             _buildDrawerItem(Icons.chat, "Others", 5),
//             _buildDrawerItem(Icons.settings, "Settings", 6),
//           ],
//         ),
//       ),
//       body: _buildPageContent(),
//     );
//   }

//   Widget _buildDrawerHeader() {
//     return UserAccountsDrawerHeader(
//       decoration: const BoxDecoration(color: kPurple),
//       accountName: Text(widget.companyProfile.name),
//       accountEmail: Text("Admin: ${widget.companyProfile.adminName}"),
//       currentAccountPicture: widget.companyProfile.hasLogo
//           ? CircleAvatar(
//               backgroundImage: NetworkImage(widget.companyProfile.logoUrl!),
//             )
//           : CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Text(
//                 widget.companyProfile.initials,
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.deepPurple,
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildDrawerItem(IconData icon, String title, int index) {
//     return ListTile(
//       leading: Icon(
//         icon,
//         color: selectedIndex == index ? Colors.deepPurple : Colors.black54,
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.normal,
//           color: selectedIndex == index ? Colors.deepPurple : Colors.black87,
//         ),
//       ),
//       selected: selectedIndex == index,
//       onTap: () {
//         setState(() {
//           selectedIndex = index;
//         });
//         Navigator.pop(context);
//       },
//     );
//   }

//   Widget _buildPageContent() {
//     switch (selectedIndex) {
//       case 0:
//         return LiveAttendancePage(companyProfile: widget.companyProfile);
//       case 1:
//         return const LeaveApprovalsScreen();
//       case 2:
//         // Employee Onboarding
//         return const EmployeeOnboardingPage();
//       case 3:
//         return const EmployeeListScreen();
//       case 4:
//         return const AttendanceReportScreen(initialFilter: '',);
//       case 5:
//         return const OthersPage();
//       case 6:
//         return const SettingsPage(); // Navigate to settings
//       default:
//         return const Center(child: Text("Unknown page"));
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:serv_app/Pagesusers/login_page.dart';
import 'company_setup_page.dart';
import 'live_attendance_page.dart';
import 'leave_approval_screen.dart';
import 'employee_management_page.dart';
import 'attendance_report_page.dart';
import 'others_page.dart';
import 'settings_page.dart';
import 'package:serv_app/Pagesadmin/employee_onboarding_page.dart';

// ✅ ADD: Import your payroll page (update path/class if different)
import 'employee_payroll_page.dart';


class AdminDashboard extends StatefulWidget {
  final CompanyProfile companyProfile;

  const AdminDashboard({super.key, required this.companyProfile});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;

  static const Color kPurple = Color(0xFF6A1B9A);

  final List<String> pageTitles = [
    "Live Attendance",
    "Request and Leave Approvals",
    "Employee Onboarding",
    "Employee Payroll", // ✅ ADD
    "Employee Management",
    "Attendance Reports",
    "Others",
    "Settings",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitles[selectedIndex]),
        backgroundColor: kPurple,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Logout"),
                  ],
                ),
                onTap: () {
                  Future.delayed(Duration.zero, () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginPage(),
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            _buildDrawerHeader(),
            _buildDrawerItem(Icons.check_circle, "Live Attendance", 0),
            _buildDrawerItem(Icons.calendar_today, "Request and Leave Approvals", 1),
            _buildDrawerItem(Icons.how_to_reg, "Employee Onboarding", 2),

            // ✅ ADD: Payroll button right below onboarding
            _buildDrawerItem(Icons.payments, "Employee Payroll", 3),

            // Indices shifted by +1 after inserting payroll
            _buildDrawerItem(Icons.group, "Employee Management", 4),
            _buildDrawerItem(Icons.bar_chart, "Attendance Reports", 5),
            _buildDrawerItem(Icons.chat, "Others", 6),
            _buildDrawerItem(Icons.settings, "Settings", 7),
          ],
        ),
      ),
      body: _buildPageContent(),
    );
  }

  Widget _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(color: kPurple),
      accountName: Text(widget.companyProfile.name),
      accountEmail: Text("Admin: ${widget.companyProfile.adminName}"),
      currentAccountPicture: widget.companyProfile.hasLogo
          ? CircleAvatar(
              backgroundImage: NetworkImage(widget.companyProfile.logoUrl!),
            )
          : CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                widget.companyProfile.initials,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(
        icon,
        color: selectedIndex == index ? Colors.deepPurple : Colors.black54,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.normal,
          color: selectedIndex == index ? Colors.deepPurple : Colors.black87,
        ),
      ),
      selected: selectedIndex == index,
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _buildPageContent() {
    switch (selectedIndex) {
      case 0:
        return LiveAttendancePage(companyProfile: widget.companyProfile);
      case 1:
        return const LeaveApprovalsScreen();
      case 2:
        return const EmployeeOnboardingPage();

      // ✅ ADD: Payroll page route
      case 3:
        return const EmployeePayrollPage();

      // Indices shifted by +1 after inserting payroll
      case 4:
        return const EmployeeListScreen();
      case 5:
        return const AttendanceReportScreen(initialFilter: '');
      case 6:
        return const OthersPage();
      case 7:
        return const SettingsPage();
      default:
        return const Center(child: Text("Unknown page"));
    }
  }
}