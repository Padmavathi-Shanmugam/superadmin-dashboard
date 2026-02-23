// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl_phone_field/countries.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:url_launcher/url_launcher.dart';

// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// import 'employee_onboarding_models.dart';

// /* Theme colors */
// const Color kPrimaryBackgroundTop = Color(0xFFFFFFFF);
// const Color kPrimaryBackgroundBottom = Color(0xFFD1C4E9);
// const Color kAppBarColor = Color(0xFF8C6EAF);
// const Color kButtonColor = Color(0xFF655193);
// const Color kTextColor = Colors.white;

// /* ===================== Local helper model for deductions ===================== */
// class DeductionItem {
//   final String name;
//   final int amount;

//   DeductionItem({required this.name, required this.amount});
// }

// /* ===================== Form Page ===================== */
// class EmployeeOnboardingFormPage extends StatefulWidget {
//   const EmployeeOnboardingFormPage({
//     super.key,
//     required this.title,
//     this.initialData,
//   });

//   final String title;
//   final EmployeeOnboardFormResult? initialData;

//   @override
//   State<EmployeeOnboardingFormPage> createState() =>
//       _EmployeeOnboardingFormPageState();
// }

// class _EmployeeOnboardingFormPageState extends State<EmployeeOnboardingFormPage> {
//   final _formKey = GlobalKey<FormState>();
//   bool _submitted = false;

//   static const int _pincodeLen = 6;
//   static const int _aadhaarLen = 12;

//   // Section 1
//   final _fullNameCtrl = TextEditingController();
//   final _personalEmailCtrl = TextEditingController();
//   final _addressCtrl = TextEditingController();
//   final _cityCtrl = TextEditingController();
//   final _stateCtrl = TextEditingController();
//   final _pincodeCtrl = TextEditingController();

//   // Date controllers
//   final _dobCtrl = TextEditingController();
//   final _dojCtrl = TextEditingController();

//   // Section 2
//   final _officialEmailCtrl = TextEditingController();
//   final _employeeIdCtrl = TextEditingController();
//   final _experienceYearsOtherCtrl = TextEditingController();

//   // Section 3
//   final _bankNameCtrl = TextEditingController();
//   final _accountHolderCtrl = TextEditingController();
//   final _accountNoCtrl = TextEditingController();
//   final _ifscCtrl = TextEditingController();
//   final _bankBranchCtrl = TextEditingController();
//   final _upiCtrl = TextEditingController();

//   final _panCtrl = TextEditingController();
//   final _aadhaarCtrl = TextEditingController();

//   final _basicPayCtrl = TextEditingController();
//   final _grossSalaryCtrl = TextEditingController();
//   final _netSalaryCtrl = TextEditingController();

//   final _professionalTaxCtrl = TextEditingController();
//   final _pfNumberCtrl = TextEditingController();
//   final _esiNumberCtrl = TextEditingController();

//   // Phone
//   String _mobileCountryCode = "+91";
//   String _mobileNumber = "";
//   String _currentIsoCode = "IN";
//   int _minPhoneLen = 10;
//   int _maxPhoneLen = 10;

//   // Dropdowns
//   final List<String> _genders = ['Male', 'Female', 'Other'];
//   final List<String> _bloodGroups = [
//     'A+',
//     'A-',
//     'B+',
//     'B-',
//     'O+',
//     'O-',
//     'AB+',
//     'AB-'
//   ];
//   final List<String> _maritalStatuses = ['Single', 'Married'];

//   final List<String> _companyList = ['GCARE Pvt Ltd', 'MR TECH Pvt Ltd'];
//   final List<String> _branchList = ['Chennai HQ', 'Tiruvallur', 'Coimbatore'];
//   final List<String> _deptList = ['IT', 'HR', 'Finance', 'Marketing', 'Operations'];
//   final List<String> _designationList = ['Software Engineer', 'Executive', 'HR Associate'];
//   final List<String> _workModeList = ['Office', 'Remote', 'Hybrid'];
//   final List<String> _shiftList = ['9 AM - 6 PM', '10 AM - 7 PM', 'Night Shift'];

//   final List<String> _workDaysAll =
//       const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//   final Set<String> _selectedWorkDays = {'Mon', 'Tue', 'Wed', 'Thu', 'Fri'};

//   // Experience
//   String _experienceType = "Fresher";
//   String? _experienceYears;

//   final List<String> _experienceYearsList = const [
//     "0 - 6 Months",
//     "1 Year",
//     "2 Years",
//     "3 Years",
//     "4 Years",
//     "5 Years",
//     "6 Years",
//     "7 Years",
//     "8 Years",
//     "9 Years",
//     "10 Years",
//     "10+ Years",
//     "Others",
//   ];

//   // Salary options
//   final List<String> _moneyOptions =
//       const ["0", "500", "1000", "2000", "5000", "10000", "Others"];
//   String? _hraStr = "0";
//   String? _bonusStr = "0";

//   final List<AllowanceItem> _allowances = [];
//   final List<DeductionItem> _extraDeductions = [];

//   // Selected values
//   String? _gender;
//   String? _bloodGroup;
//   String? _maritalStatus;
//   DateTime? _dob;

//   String? _companyName;
//   String? _branchLocation;
//   DateTime? _doj;

//   String? _department;
//   String? _designation;
//   String? _workMode;
//   String? _shiftTiming;

//   // Documents
//   late final List<UploadedDoc> _docs;

//   @override
//   void initState() {
//     super.initState();

//     _applyCountryRules(_currentIsoCode);

//     _companyName = _companyList.first;
//     _branchLocation = _branchList.first;
//     _workMode = _workModeList.first;
//     _shiftTiming = _shiftList.first;
//     _department = _deptList.first;
//     _designation = _designationList.first;

//     _employeeIdCtrl.text = _autoEmployeeId();

//     _basicPayCtrl.addListener(_recalcSalary);
//     _professionalTaxCtrl.addListener(_recalcSalary);
//     _recalcSalary();

//     _docs = [
//       UploadedDoc(key: "resume", label: "Resume", requiredDoc: true),
//       UploadedDoc(key: "offer_letter", label: "Offer Letter", requiredDoc: true),
//       UploadedDoc(key: "aadhaar_doc", label: "Aadhaar", requiredDoc: true),
//       UploadedDoc(key: "pan_doc", label: "PAN", requiredDoc: true),
//       UploadedDoc(key: "bank_proof", label: "Bank Proof", requiredDoc: true),
//       UploadedDoc(key: "exp_relieving", label: "Experience / Relieving Letter", requiredDoc: false),
//       UploadedDoc(key: "marks_10", label: "10th Marksheet", requiredDoc: false),
//       UploadedDoc(key: "marks_12", label: "12th Marksheet", requiredDoc: false),
//       UploadedDoc(key: "degree", label: "Degree Certificate", requiredDoc: false),
//     ];

//     // Prefill if initialData exists
//     final d = widget.initialData;
//     if (d != null) {
//       _fullNameCtrl.text = d.fullName;
//       _personalEmailCtrl.text = d.personalEmail;
//       _addressCtrl.text = d.permanentAddress;
//       _cityCtrl.text = d.city;
//       _stateCtrl.text = d.state;
//       _pincodeCtrl.text = d.pincode;

//       _officialEmailCtrl.text = d.officialEmail;
//       _employeeIdCtrl.text = d.employeeId;

//       _bankNameCtrl.text = d.bankName;
//       _accountHolderCtrl.text = d.accountHolderName;
//       _accountNoCtrl.text = d.accountNumber;
//       _ifscCtrl.text = d.ifscCode;
//       _bankBranchCtrl.text = d.bankBranch;
//       _upiCtrl.text = d.upiId;

//       _panCtrl.text = d.panNumber;
//       _aadhaarCtrl.text = d.aadhaarNumber;

//       _basicPayCtrl.text = d.basicPay.toString();
//       _professionalTaxCtrl.text = d.professionalTax.toString();
//       _pfNumberCtrl.text = d.pfNumber;
//       _esiNumberCtrl.text = d.esiNumber;

//       _gender = d.gender.isEmpty ? null : d.gender;
//       _bloodGroup = d.bloodGroup.isEmpty ? null : d.bloodGroup;
//       _maritalStatus = d.maritalStatus.isEmpty ? null : d.maritalStatus;

//       _dob = d.dob;
//       _doj = d.doj;

//       _companyName = d.companyName.isEmpty ? _companyName : d.companyName;
//       _branchLocation = d.branchLocation.isEmpty ? _branchLocation : d.branchLocation;
//       _department = d.department.isEmpty ? _department : d.department;
//       _designation = d.designation.isEmpty ? _designation : d.designation;
//       _workMode = d.workMode.isEmpty ? _workMode : d.workMode;
//       _shiftTiming = d.shiftTiming.isEmpty ? _shiftTiming : d.shiftTiming;

//       _mobileCountryCode = d.mobileCountryCode.isEmpty ? _mobileCountryCode : d.mobileCountryCode;
//       _mobileNumber = d.mobileNumber;

//       _selectedWorkDays
//         ..clear()
//         ..addAll(d.workDays);

//       _hraStr = d.hra.toString();
//       _bonusStr = d.bonus.toString();

//       // Restore docs
//       for (final doc in _docs) {
//         final dynamic saved = d.documents[doc.key];
//         if (saved is Map<String, dynamic>) {
//           doc.fileName = (saved["fileName"] ?? saved["name"])?.toString();
//           doc.ext = (saved["ext"])?.toString();
//           doc.path = (saved["path"])?.toString();

//           final String? b64 = saved["base64"]?.toString();
//           if (b64 != null && b64.trim().isNotEmpty) {
//             try {
//               doc.bytes = base64Decode(b64);
//             } catch (_) {}
//           }
//         }
//       }

//       if (_dob != null) _dobCtrl.text = _fmtDate(_dob!);
//       if (_doj != null) _dojCtrl.text = _fmtDate(_doj!);

//       _recalcSalary();
//     }
//   }

//   @override
//   void dispose() {
//     _fullNameCtrl.dispose();
//     _personalEmailCtrl.dispose();
//     _addressCtrl.dispose();
//     _cityCtrl.dispose();
//     _stateCtrl.dispose();
//     _pincodeCtrl.dispose();

//     _dobCtrl.dispose();
//     _dojCtrl.dispose();

//     _officialEmailCtrl.dispose();
//     _employeeIdCtrl.dispose();
//     _experienceYearsOtherCtrl.dispose();

//     _bankNameCtrl.dispose();
//     _accountHolderCtrl.dispose();
//     _accountNoCtrl.dispose();
//     _ifscCtrl.dispose();
//     _bankBranchCtrl.dispose();
//     _upiCtrl.dispose();

//     _panCtrl.dispose();
//     _aadhaarCtrl.dispose();

//     _basicPayCtrl.dispose();
//     _grossSalaryCtrl.dispose();
//     _netSalaryCtrl.dispose();

//     _professionalTaxCtrl.dispose();
//     _pfNumberCtrl.dispose();
//     _esiNumberCtrl.dispose();

//     super.dispose();
//   }

//   String _autoEmployeeId() {
//     final ms = DateTime.now().millisecondsSinceEpoch.toString();
//     return "GC${ms.substring(ms.length - 4)}";
//   }

//   int _toInt(String? v) {
//     final t = (v ?? "").trim();
//     if (t.isEmpty) return 0;
//     return int.tryParse(t) ?? 0;
//   }

//   int _allowancesSum() {
//     int sum = 0;
//     for (final a in _allowances) {
//       sum += a.amount;
//     }
//     return sum;
//   }

//   int _extraDeductionsSum() {
//     int sum = 0;
//     for (final d in _extraDeductions) {
//       sum += d.amount;
//     }
//     return sum;
//   }

//   void _recalcSalary() {
//     final basic = _toInt(_basicPayCtrl.text);
//     final hra = _toInt(_hraStr);
//     final bonus = _toInt(_bonusStr);
//     final allowances = _allowancesSum();

//     final extraDed = _extraDeductionsSum();
//     final profTax = _toInt(_professionalTaxCtrl.text);

//     final gross = basic + hra + allowances + bonus;
//     final totalDed = extraDed + profTax;
//     final net = gross - totalDed;

//     _grossSalaryCtrl.text = gross.toString();
//     _netSalaryCtrl.text = net.toString();

//     if (mounted) setState(() {});
//   }

//   void _applyCountryRules(String isoCode) {
//     final country = countries.firstWhere(
//       (c) => c.code.toUpperCase() == isoCode.toUpperCase(),
//       orElse: () => countries.firstWhere((c) => c.code == "IN"),
//     );

//     setState(() {
//       _currentIsoCode = country.code;

//       _minPhoneLen = (country.minLength ?? 6).clamp(4, 15);
//       _maxPhoneLen = (country.maxLength ?? 15).clamp(_minPhoneLen, 15);

//       if (_currentIsoCode.toUpperCase() == "IN") {
//         _minPhoneLen = 10;
//         _maxPhoneLen = 10;
//       }

//       _mobileCountryCode = "+${country.dialCode}";

//       if (_mobileNumber.length > _maxPhoneLen) {
//         _mobileNumber = _mobileNumber.substring(0, _maxPhoneLen);
//       }
//     });
//   }

//   // ===================== DATE PICKERS =====================
//   Future<DateTime?> _openDatePicker({
//     required DateTime initialDate,
//     required DateTime firstDate,
//     required DateTime lastDate,
//   }) async {
//     FocusScope.of(context).unfocus();
//     await Future.delayed(const Duration(milliseconds: 80));

//     return showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: firstDate,
//       lastDate: lastDate,
//     );
//   }

//   Future<void> _pickDob() async {
//     final now = DateTime.now();
//     final lastDate = DateTime(now.year - 10, 12, 31);
//     var initial = _dob ?? DateTime(now.year - 22, 1, 1);

//     if (initial.isBefore(DateTime(1950, 1, 1))) {
//       initial = DateTime(1950, 1, 1);
//     } else if (initial.isAfter(lastDate)) {
//       initial = lastDate;
//     }

//     final picked = await _openDatePicker(
//       initialDate: initial,
//       firstDate: DateTime(1950, 1, 1),
//       lastDate: lastDate,
//     );

//     if (picked != null) {
//       setState(() {
//         _dob = picked;
//         _dobCtrl.text = _fmtDate(picked);
//       });
//     }
//   }

//   Future<void> _pickDoj() async {
//     final now = DateTime.now();
//     final initial = _doj ?? now;

//     final picked = await _openDatePicker(
//       initialDate: initial,
//       firstDate: DateTime(now.year - 10, 1, 1),
//       lastDate: DateTime(now.year + 1, 12, 31),
//     );

//     if (picked != null) {
//       setState(() {
//         _doj = picked;
//         _dojCtrl.text = _fmtDate(picked);
//       });
//     }
//   }

//   String _fmtDate(DateTime d) {
//     final dd = d.day.toString().padLeft(2, '0');
//     final mm = d.month.toString().padLeft(2, '0');
//     final yy = d.year.toString();
//     return "$yy-$mm-$dd";
//   }

//   String? _req(String? v, String msg) {
//     if (v == null || v.trim().isEmpty) return msg;
//     return null;
//   }

//   bool _isEmail(String v) {
//     final t = v.trim();
//     return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t);
//   }

//   // ===================== UI DECORATIONS =====================
//   InputDecoration _decReq(String label) {
//     return _baseDec(
//       labelWidget: RichText(
//         text: TextSpan(
//           style: const TextStyle(color: Colors.black87, fontSize: 14),
//           children: [
//             TextSpan(text: label),
//             const TextSpan(text: " "),
//             const TextSpan(
//               text: "*",
//               style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   InputDecoration _decOpt(String label) => _baseDec(labelText: label);

//   InputDecoration _baseDec({String? labelText, Widget? labelWidget}) {
//     return InputDecoration(
//       labelText: labelText,
//       label: labelWidget,
//       floatingLabelBehavior: FloatingLabelBehavior.auto,
//       filled: true,
//       fillColor: Colors.white,
//       isDense: true,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0x22000000)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: kButtonColor.withOpacity(0.7)),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.red),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.red, width: 1.2),
//       ),
//       errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
//     );
//   }

//   Widget _sectionTitle(String text) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.92),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0x22000000)),
//       ),
//       child: Text(text,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
//     );
//   }

//   Widget _card(Widget child) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.92),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0x22000000)),
//       ),
//       child: child,
//     );
//   }

//   // ✅ Web-safe calendar field: ALWAYS clickable
//   Widget _calendarFieldWebSafe({
//     required String label,
//     required TextEditingController controller,
//     required VoidCallback onPick,
//     required String validatorMsg,
//   }) {
//     return Stack(
//       children: [
//         TextFormField(
//           controller: controller,
//           readOnly: true,
//           decoration: _decReq(label).copyWith(
//             suffixIcon: const Icon(Icons.calendar_month),
//           ),
//           validator: (v) => _req(v, validatorMsg),
//           onTap: onPick,
//         ),
//         Positioned.fill(
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: () {
//                 FocusScope.of(context).unfocus();
//                 onPick();
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ===================== SECTION 2 “OTHERS” ADD SUPPORT =====================
//   Future<String?> _showAddOtherDialog(String title) async {
//     final ctrl = TextEditingController();
//     return showDialog<String>(
//       context: context,
//       builder: (ctx) {
//         return AlertDialog(
//           title: Text("Add $title"),
//           content: TextField(
//             controller: ctrl,
//             decoration: const InputDecoration(hintText: "Enter value"),
//             autofocus: true,
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () => Navigator.pop(ctx, null),
//                 child: const Text("Cancel")),
//             ElevatedButton(
//               onPressed: () {
//                 final v = ctrl.text.trim();
//                 if (v.isEmpty) return;
//                 Navigator.pop(ctx, v);
//               },
//               child: const Text("Add"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _dropdownWithOthers({
//     required String label,
//     required String? value,
//     required List<String> sourceList,
//     required void Function(String? v) onChanged,
//     required String validatorMsg,
//   }) {
//     final items = <String>[...sourceList.where((e) => e.trim().isNotEmpty)];
//     if (!items.contains("Others")) items.add("Others");

//     return DropdownButtonFormField<String>(
//       value: value,
//       decoration: _decReq(label),
//       items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//       onChanged: (v) async {
//         if (v == "Others") {
//           final newVal = await _showAddOtherDialog(label);
//           if (newVal == null || newVal.trim().isEmpty) return;
//           setState(() {
//             if (!sourceList.contains(newVal)) sourceList.add(newVal);
//           });
//           onChanged(newVal);
//           return;
//         }
//         onChanged(v);
//       },
//       validator: (v) => _req(v, validatorMsg),
//     );
//   }

//   // ===================== Allowance / Deduction dialogs =====================
//   Future<void> _addAllowanceDialog() async {
//     final nameCtrl = TextEditingController();
//     final amtCtrl = TextEditingController();

//     final ok = await showDialog<bool>(
//       context: context,
//       builder: (ctx) {
//         return AlertDialog(
//           title: const Text("Add Allowance (Optional)"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                   controller: nameCtrl,
//                   decoration: const InputDecoration(hintText: "Allowance name")),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: amtCtrl,
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 decoration: const InputDecoration(hintText: "Amount"),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () => Navigator.pop(ctx, false),
//                 child: const Text("Cancel")),
//             ElevatedButton(
//                 onPressed: () => Navigator.pop(ctx, true),
//                 child: const Text("Add")),
//           ],
//         );
//       },
//     );

//     if (ok != true) return;

//     final name = nameCtrl.text.trim();
//     final amt = _toInt(amtCtrl.text);
//     if (name.isEmpty || amt <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter a valid allowance name and amount.")),
//       );
//       return;
//     }

//     setState(() => _allowances.add(AllowanceItem(name: name, amount: amt)));
//     _recalcSalary();
//   }

//   Future<void> _addDeductionDialog() async {
//     final nameCtrl = TextEditingController();
//     final amtCtrl = TextEditingController();

//     final ok = await showDialog<bool>(
//       context: context,
//       builder: (ctx) {
//         return AlertDialog(
//           title: const Text("Add Deduction (Optional)"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                   controller: nameCtrl,
//                   decoration: const InputDecoration(hintText: "Deduction name")),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: amtCtrl,
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 decoration: const InputDecoration(hintText: "Amount"),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () => Navigator.pop(ctx, false),
//                 child: const Text("Cancel")),
//             ElevatedButton(
//                 onPressed: () => Navigator.pop(ctx, true),
//                 child: const Text("Add")),
//           ],
//         );
//       },
//     );

//     if (ok != true) return;

//     final name = nameCtrl.text.trim();
//     final amt = _toInt(amtCtrl.text);
//     if (name.isEmpty || amt <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter a valid deduction name and amount.")),
//       );
//       return;
//     }

//     setState(() => _extraDeductions.add(DeductionItem(name: name, amount: amt)));
//     _recalcSalary();
//   }

//   Widget _miniLineTile({
//     required String title,
//     required String value,
//     required VoidCallback onRemove,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(top: 8),
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0x22000000)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               "$title: Rs. $value",
//               style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           IconButton(
//             tooltip: "Remove",
//             onPressed: onRemove,
//             icon: const Icon(Icons.delete_outline, size: 20),
//           ),
//         ],
//       ),
//     );
//   }

//   // ===================== DOCUMENTS =====================
//   Future<void> _viewDoc(UploadedDoc doc) async {
//     if (!doc.hasFile) return;

//     if (kIsWeb) {
//       final Uint8List bytes = doc.bytes!;
//       final String ext = (doc.ext ?? "").toLowerCase();

//       String mime = "application/octet-stream";
//       if (ext == "pdf") mime = "application/pdf";
//       if (ext == "png") mime = "image/png";
//       if (ext == "jpg" || ext == "jpeg") mime = "image/jpeg";

//       final String b64 = base64Encode(bytes);
//       final Uri uri = Uri.parse("data:$mime;base64,$b64");
//       await launchUrl(uri, webOnlyWindowName: '_blank');
//       return;
//     }

//     final String? path = doc.path;
//     if (path == null || path.isEmpty) return;
//     await OpenFilex.open(path);
//   }

//   Future<void> _pickDoc(UploadedDoc doc) async {
//     final res = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: const ['pdf', 'png', 'jpg', 'jpeg'],
//       withData: kIsWeb,
//     );

//     if (res == null || res.files.isEmpty) return;
//     final f = res.files.first;

//     setState(() {
//       doc.fileName = f.name;
//       doc.ext = f.extension?.toLowerCase();
//       doc.path = f.path;
//       doc.bytes = f.bytes;
//     });
//   }

//   bool _validateDocuments({bool showSnack = true}) {
//     for (final d in _docs) {
//       if (d.requiredDoc && !d.hasFile) {
//         if (showSnack) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("${d.label} is required")),
//           );
//         }
//         return false;
//       }
//     }
//     return true;
//   }

//   Widget _docTile(UploadedDoc doc) {
//     final title = doc.requiredDoc ? "${doc.label} *" : "${doc.label} (Optional)";
//     final bool showRed = _submitted && doc.requiredDoc && !doc.hasFile;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.92),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: showRed ? Colors.red : const Color(0x22000000),
//           width: showRed ? 1.2 : 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
//           const SizedBox(height: 8),
//           if (doc.fileName != null && doc.fileName!.trim().isNotEmpty) ...[
//             Text(
//               "Selected: ${doc.fileName}",
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(color: Colors.black54, fontSize: 12),
//             ),
//             const SizedBox(height: 10),
//           ],
//           if (showRed) ...[
//             const Text("This document is required.",
//                 style: TextStyle(color: Colors.red, fontSize: 12)),
//             const SizedBox(height: 10),
//           ],
//           Row(
//             children: [
//               Expanded(
//                 child: SizedBox(
//                   height: 40,
//                   child: OutlinedButton.icon(
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: kButtonColor,
//                       side: BorderSide(color: kButtonColor.withOpacity(0.6)),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     onPressed: () => _pickDoc(doc),
//                     icon: const Icon(Icons.file_upload_outlined, size: 18),
//                     label: Text(doc.hasFile ? "Change" : "Upload"),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: SizedBox(
//                   height: 40,
//                   child: ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                           doc.hasFile ? kButtonColor : Colors.grey.shade400,
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     onPressed: doc.hasFile ? () => _viewDoc(doc) : null,
//                     icon: const Icon(Icons.visibility_outlined, size: 18),
//                     label: const Text("View"),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ===================== PAY SLIP PDF =====================
//   pw.Widget _pdfKeyValue(String k, String v) {
//     return pw.Padding(
//       padding: const pw.EdgeInsets.symmetric(vertical: 2),
//       child: pw.Row(
//         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//         children: [
//           pw.Text(k, style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
//           pw.SizedBox(width: 10),
//           pw.Expanded(
//             child: pw.Text(v,
//                 textAlign: pw.TextAlign.right,
//                 style: const pw.TextStyle(fontSize: 9)),
//           ),
//         ],
//       ),
//     );
//   }

//   pw.Widget _pdfMoneyRow(String name, int amt) {
//     return pw.Padding(
//       padding: const pw.EdgeInsets.symmetric(vertical: 3),
//       child: pw.Row(
//         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//         children: [
//           pw.Text(name, style: const pw.TextStyle(fontSize: 9)),
//           pw.Text("Rs. $amt", style: const pw.TextStyle(fontSize: 9)),
//         ],
//       ),
//     );
//   }

//   Future<Uint8List> _buildSalarySlipPdfLikeImage() async {
//     _recalcSalary();

//     final employeeName =
//         _fullNameCtrl.text.trim().isEmpty ? "-" : _fullNameCtrl.text.trim();
//     final empId =
//         _employeeIdCtrl.text.trim().isEmpty ? "-" : _employeeIdCtrl.text.trim();
//     final doj = _doj == null ? "-" : _fmtDate(_doj!);

//     final basic = _toInt(_basicPayCtrl.text);
//     final hra = _toInt(_hraStr);
//     final bonus = _toInt(_bonusStr);
//     final allowances = _allowancesSum();

//     final extraDed = _extraDeductionsSum();
//     final profTax = _toInt(_professionalTaxCtrl.text);

//     final gross = basic + hra + allowances + bonus;
//     final totalDed = extraDed + profTax;
//     final net = gross - totalDed;

//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(22),
//         build: (ctx) {
//           return pw.Container(
//             decoration: pw.BoxDecoration(
//               border: pw.Border.all(color: PdfColors.grey300),
//               borderRadius: pw.BorderRadius.circular(10),
//               color: PdfColors.white,
//             ),
//             padding: const pw.EdgeInsets.all(14),
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.stretch,
//               children: [
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: [
//                     pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Text("MR TECH",
//                             style: pw.TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: pw.FontWeight.bold)),
//                         pw.SizedBox(height: 2),
//                         pw.Text("Myth Reality Technologies Pvt. Ltd",
//                             style: pw.TextStyle(
//                                 fontSize: 9, color: PdfColors.grey700)),
//                       ],
//                     ),
//                     pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.end,
//                       children: [
//                         pw.Text("Payslip For the Month",
//                             style: pw.TextStyle(
//                                 fontSize: 9, color: PdfColors.grey700)),
//                         pw.SizedBox(height: 2),
//                         pw.Text(
//                           DateTime.now().toString().substring(0, 7),
//                           style: pw.TextStyle(
//                               fontSize: 10,
//                               fontWeight: pw.FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Divider(color: PdfColors.grey300),
//                 pw.Row(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Expanded(
//                       flex: 2,
//                       child: pw.Container(
//                         padding: const pw.EdgeInsets.all(10),
//                         decoration: pw.BoxDecoration(
//                           border: pw.Border.all(color: PdfColors.grey300),
//                           borderRadius: pw.BorderRadius.circular(8),
//                         ),
//                         child: pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             pw.Text("EMPLOYEE SUMMARY",
//                                 style: pw.TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: pw.FontWeight.bold)),
//                             pw.SizedBox(height: 6),
//                             _pdfKeyValue("Employee Name", employeeName),
//                             _pdfKeyValue("Designation", _designation ?? "-"),
//                             _pdfKeyValue("Employee ID", empId),
//                             _pdfKeyValue("Date of Joining", doj),
//                           ],
//                         ),
//                       ),
//                     ),
//                     pw.SizedBox(width: 10),
//                     pw.Expanded(
//                       flex: 1,
//                       child: pw.Container(
//                         padding: const pw.EdgeInsets.all(10),
//                         decoration: pw.BoxDecoration(
//                           borderRadius: pw.BorderRadius.circular(8),
//                           border: pw.Border.all(color: PdfColors.grey300),
//                           color: PdfColors.green50,
//                         ),
//                         child: pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             pw.Text("Net Pay",
//                                 style: pw.TextStyle(
//                                     fontSize: 9, color: PdfColors.grey700)),
//                             pw.SizedBox(height: 6),
//                             pw.Text("Rs. $net",
//                                 style: pw.TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: pw.FontWeight.bold)),
//                             pw.SizedBox(height: 8),
//                             pw.Text("Employee Net Pay",
//                                 style: const pw.TextStyle(fontSize: 9)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Container(
//                   padding: const pw.EdgeInsets.all(10),
//                   decoration: pw.BoxDecoration(
//                     border: pw.Border.all(color: PdfColors.grey300),
//                     borderRadius: pw.BorderRadius.circular(8),
//                   ),
//                   child: pw.Column(
//                     children: [
//                       pw.Row(
//                         children: [
//                           pw.Expanded(
//                             child: pw.Text("EARNINGS",
//                                 style: pw.TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: pw.FontWeight.bold)),
//                           ),
//                           pw.Expanded(
//                             child: pw.Text("DEDUCTIONS",
//                                 textAlign: pw.TextAlign.right,
//                                 style: pw.TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: pw.FontWeight.bold)),
//                           ),
//                         ],
//                       ),
//                       pw.SizedBox(height: 8),
//                       pw.Row(
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Expanded(
//                             child: pw.Column(
//                               children: [
//                                 _pdfMoneyRow("Basic", basic),
//                                 _pdfMoneyRow("House Rent Allowance", hra),
//                                 _pdfMoneyRow("Allowances", allowances),
//                                 _pdfMoneyRow("Bonus", bonus),
//                                 pw.Divider(color: PdfColors.grey300),
//                                 _pdfMoneyRow("Gross Earnings", gross),
//                               ],
//                             ),
//                           ),
//                           pw.SizedBox(width: 12),
//                           pw.Expanded(
//                             child: pw.Column(
//                               children: [
//                                 _pdfMoneyRow("Extra Deductions", extraDed),
//                                 _pdfMoneyRow("Professional Tax", profTax),
//                                 pw.Divider(color: PdfColors.grey300),
//                                 _pdfMoneyRow("Total Deductions", totalDed),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 pw.SizedBox(height: 12),
//                 pw.Container(
//                   padding: const pw.EdgeInsets.all(10),
//                   decoration: pw.BoxDecoration(
//                     color: PdfColors.grey200,
//                     borderRadius: pw.BorderRadius.circular(8),
//                     border: pw.Border.all(color: PdfColors.grey300),
//                   ),
//                   child: pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Text("TOTAL NET PAYABLE",
//                           style: pw.TextStyle(
//                               fontSize: 10,
//                               fontWeight: pw.FontWeight.bold)),
//                       pw.Text("Rs. $net",
//                           style: pw.TextStyle(
//                               fontSize: 10,
//                               fontWeight: pw.FontWeight.bold)),
//                     ],
//                   ),
//                 ),
//                 pw.Spacer(),
//                 pw.Center(
//                   child: pw.Text("This is a system generated salary slip.",
//                       style: pw.TextStyle(
//                           fontSize: 8, color: PdfColors.grey700)),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );

//     return pdf.save();
//   }

//   Future<void> _downloadSalarySlipPdf() async {
//     if (!_validateDocuments()) return;

//     final bytes = await _buildSalarySlipPdfLikeImage();
//     final fileName =
//         "salary_slip_${_employeeIdCtrl.text.trim().isEmpty ? "employee" : _employeeIdCtrl.text.trim()}.pdf";

//     if (kIsWeb) {
//       final b64 = base64Encode(bytes);
//       final uri = Uri.parse("data:application/pdf;base64,$b64");
//       await launchUrl(uri, webOnlyWindowName: "_blank");
//       return;
//     }

//     await Printing.layoutPdf(
//       onLayout: (format) async => bytes,
//       name: fileName,
//     );
//   }

//   void _submit() {
//     setState(() => _submitted = true);

//     final ok = _formKey.currentState?.validate() ?? false;
//     final docsOk = _validateDocuments(showSnack: false);

//     if (!ok || !docsOk) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all required fields.")),
//       );
//       return;
//     }

//     if (_dob == null || _doj == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select Date of Birth and Date of Joining.")),
//       );
//       return;
//     }

//     if (_experienceType == "Experienced") {
//       final yrs = (_experienceYears ?? "").trim();
//       final other = _experienceYearsOtherCtrl.text.trim();
//       if (yrs.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Experience years is required.")),
//         );
//         return;
//       }
//       if (yrs == "Others" && other.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please enter experience years (Others).")),
//         );
//         return;
//       }
//     }

//     _recalcSalary();
//     final deductionsTotalToSave = _extraDeductionsSum();

//     final Map<String, dynamic> docsMap = {};
//     for (final doc in _docs) {
//       final json = doc.toJson();
//       if (kIsWeb && doc.bytes != null) {
//         json["base64"] = base64Encode(doc.bytes!);
//       }
//       docsMap[doc.key] = json;
//     }

//     final result = EmployeeOnboardFormResult(
//       fullName: _fullNameCtrl.text.trim(),
//       gender: (_gender ?? "").trim(),
//       dob: _dob!,
//       bloodGroup: (_bloodGroup ?? "").trim(),
//       maritalStatus: (_maritalStatus ?? "").trim(),
//       personalEmail: _personalEmailCtrl.text.trim(),
//       mobileCountryCode: _mobileCountryCode.trim(),
//       mobileNumber: _mobileNumber.trim(),
//       permanentAddress: _addressCtrl.text.trim(),
//       city: _cityCtrl.text.trim(),
//       state: _stateCtrl.text.trim(),
//       pincode: _pincodeCtrl.text.trim(),
//       companyName: (_companyName ?? "").trim(),
//       branchLocation: (_branchLocation ?? "").trim(),
//       employeeId: _employeeIdCtrl.text.trim(),
//       doj: _doj!,
//       department: (_department ?? "").trim(),
//       designation: (_designation ?? "").trim(),
//       workMode: (_workMode ?? "").trim(),
//       shiftTiming: (_shiftTiming ?? "").trim(),
//       workDays: _selectedWorkDays.toList(),
//       officialEmail: _officialEmailCtrl.text.trim(),
//       bankName: _bankNameCtrl.text.trim(),
//       accountHolderName: _accountHolderCtrl.text.trim(),
//       accountNumber: _accountNoCtrl.text.trim(),
//       ifscCode: _ifscCtrl.text.trim(),
//       bankBranch: _bankBranchCtrl.text.trim(),
//       upiId: _upiCtrl.text.trim(),
//       panNumber: _panCtrl.text.trim(),
//       aadhaarNumber: _aadhaarCtrl.text.trim(),
//       basicPay: _toInt(_basicPayCtrl.text),
//       hra: _toInt(_hraStr),
//       bonus: _toInt(_bonusStr),
//       allowancesTotal: _allowancesSum(),
//       deductionsAmount: deductionsTotalToSave,
//       professionalTax: _toInt(_professionalTaxCtrl.text),
//       pfNumber: _pfNumberCtrl.text.trim(),
//       esiNumber: _esiNumberCtrl.text.trim(),
//       grossSalary: _toInt(_grossSalaryCtrl.text),
//       netSalary: _toInt(_netSalaryCtrl.text),
//       documents: docsMap,
//     );

//     Navigator.pop(context, result);
//   }

//   Widget _responsiveBottomBar(double width) {
//     final cancelBtn = SizedBox(
//       height: 48,
//       child: OutlinedButton(
//         style: OutlinedButton.styleFrom(
//           side: BorderSide(color: kButtonColor),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         onPressed: () => Navigator.pop(context),
//         child: const FittedBox(
//           fit: BoxFit.scaleDown,
//           child: Text(
//             "Cancel",
//             style: TextStyle(fontSize: 16, height: 1.0),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ),
//     );

//     final saveBtn = SizedBox(
//       height: 48,
//       child: ElevatedButton(
//         onPressed: _submit,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: kButtonColor,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         child: const FittedBox(
//           fit: BoxFit.scaleDown,
//           child: Text(
//             "Save & Send to Super Admin",
//             style: TextStyle(color: Colors.white, fontSize: 16, height: 1.0),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ),
//     );

//     return SafeArea(
//       top: false,
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.92),
//           border: const Border(top: BorderSide(color: Color(0x22000000))),
//         ),
//         child: Row(
//           children: [
//             Expanded(child: cancelBtn),
//             const SizedBox(width: 12),
//             Expanded(child: saveBtn),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: kAppBarColor,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [kPrimaryBackgroundTop, kPrimaryBackgroundBottom],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: Form(
//             key: _formKey,
//             autovalidateMode:
//                 _submitted ? AutovalidateMode.always : AutovalidateMode.disabled,
//             child: ListView(
//               keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//               padding: const EdgeInsets.fromLTRB(12, 12, 12, 120),
//               children: [
//                 _sectionTitle("SECTION 1 — BASIC INFORMATION"),
//                 const SizedBox(height: 10),
//                 _card(
//                   Column(
//                     children: [
//                       TextFormField(
//                         controller: _fullNameCtrl,
//                         decoration: _decReq("Full Name"),
//                         validator: (v) => _req(v, "Full Name is required"),
//                       ),
//                       const SizedBox(height: 10),
//                       DropdownButtonFormField<String>(
//                         value: _gender,
//                         decoration: _decReq("Gender"),
//                         items: _genders
//                             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                             .toList(),
//                         onChanged: (v) => setState(() => _gender = v),
//                         validator: (v) => _req(v, "Gender is required"),
//                       ),
//                       const SizedBox(height: 10),

//                       _calendarFieldWebSafe(
//                         label: "Date of Birth",
//                         controller: _dobCtrl,
//                         onPick: _pickDob,
//                         validatorMsg: "Date of Birth is required",
//                       ),

//                       const SizedBox(height: 10),
//                       DropdownButtonFormField<String>(
//                         value: _bloodGroup,
//                         decoration: _decReq("Blood Group"),
//                         items: _bloodGroups
//                             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                             .toList(),
//                         onChanged: (v) => setState(() => _bloodGroup = v),
//                         validator: (v) => _req(v, "Blood Group is required"),
//                       ),
//                       const SizedBox(height: 10),
//                       DropdownButtonFormField<String>(
//                         value: _maritalStatus,
//                         decoration: _decReq("Marital Status"),
//                         items: _maritalStatuses
//                             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                             .toList(),
//                         onChanged: (v) => setState(() => _maritalStatus = v),
//                         validator: (v) => _req(v, "Marital Status is required"),
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _personalEmailCtrl,
//                         decoration: _decReq("Personal Email"),
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (v) {
//                           final t = (v ?? "").trim();
//                           if (t.isEmpty) return "Personal Email is required";
//                           if (!_isEmail(t)) return "Enter a valid email";
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       IntlPhoneField(
//                         decoration: _decReq("Mobile Number"),
//                         initialCountryCode: _currentIsoCode,
//                         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                         onCountryChanged: (c) => _applyCountryRules(c.code),
//                         onChanged: (phone) {
//                           setState(() {
//                             _mobileCountryCode = phone.countryCode;
//                             _mobileNumber = phone.number;
//                           });
//                         },
//                         validator: (phone) {
//                           final num = (phone?.number ?? "").trim();
//                           if (num.isEmpty) return "Mobile number is required";
//                           if (num.length < _minPhoneLen || num.length > _maxPhoneLen) {
//                             return "Enter valid number ($_minPhoneLen-$_maxPhoneLen digits)";
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _addressCtrl,
//                         decoration: _decReq("Permanent Address"),
//                         validator: (v) => _req(v, "Address is required"),
//                         maxLines: 2,
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               controller: _cityCtrl,
//                               decoration: _decReq("City"),
//                               validator: (v) => _req(v, "City is required"),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: TextFormField(
//                               controller: _stateCtrl,
//                               decoration: _decReq("State"),
//                               validator: (v) => _req(v, "State is required"),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _pincodeCtrl,
//                         decoration: _decReq("Pincode"),
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                           LengthLimitingTextInputFormatter(_pincodeLen),
//                         ],
//                         validator: (v) {
//                           final t = (v ?? "").trim();
//                           if (t.isEmpty) return "Pincode is required";
//                           if (t.length != _pincodeLen) return "Pincode must be $_pincodeLen digits";
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),

//                 _sectionTitle("SECTION 2 — COMPANY INFORMATION"),
//                 const SizedBox(height: 10),
//                 _card(
//                   Column(
//                     children: [
//                       _dropdownWithOthers(
//                         label: "Company Name",
//                         value: _companyName,
//                         sourceList: _companyList,
//                         onChanged: (v) => setState(() => _companyName = v),
//                         validatorMsg: "Company Name is required",
//                       ),
//                       const SizedBox(height: 10),
//                       _dropdownWithOthers(
//                         label: "Branch Location",
//                         value: _branchLocation,
//                         sourceList: _branchList,
//                         onChanged: (v) => setState(() => _branchLocation = v),
//                         validatorMsg: "Branch Location is required",
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _employeeIdCtrl,
//                         decoration: _decReq("Employee ID"),
//                         validator: (v) => _req(v, "Employee ID is required"),
//                       ),
//                       const SizedBox(height: 10),

//                       _calendarFieldWebSafe(
//                         label: "Date of Joining",
//                         controller: _dojCtrl,
//                         onPick: _pickDoj,
//                         validatorMsg: "Date of Joining is required",
//                       ),

//                       const SizedBox(height: 10),
//                       _dropdownWithOthers(
//                         label: "Department",
//                         value: _department,
//                         sourceList: _deptList,
//                         onChanged: (v) => setState(() => _department = v),
//                         validatorMsg: "Department is required",
//                       ),
//                       const SizedBox(height: 10),
//                       _dropdownWithOthers(
//                         label: "Designation",
//                         value: _designation,
//                         sourceList: _designationList,
//                         onChanged: (v) => setState(() => _designation = v),
//                         validatorMsg: "Designation is required",
//                       ),
//                       const SizedBox(height: 10),

//                       Row(
//                         children: [
//                           Expanded(
//                             child: ChoiceChip(
//                               label: const Text("Fresher"),
//                               selected: _experienceType == "Fresher",
//                               onSelected: (_) => setState(() {
//                                 _experienceType = "Fresher";
//                                 _experienceYears = null;
//                                 _experienceYearsOtherCtrl.clear();
//                               }),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: ChoiceChip(
//                               label: const Text("Experienced"),
//                               selected: _experienceType == "Experienced",
//                               onSelected: (_) =>
//                                   setState(() => _experienceType = "Experienced"),
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 10),
//                       if (_experienceType == "Experienced") ...[
//                         DropdownButtonFormField<String>(
//                           value: _experienceYears,
//                           decoration: _decReq("Experience Years"),
//                           items: _experienceYearsList
//                               .map((e) =>
//                                   DropdownMenuItem(value: e, child: Text(e)))
//                               .toList(),
//                           onChanged: (v) => setState(() => _experienceYears = v),
//                           validator: (v) => _req(v, "Experience Years is required"),
//                         ),
//                         const SizedBox(height: 10),
//                         if (_experienceYears == "Others")
//                           TextFormField(
//                             controller: _experienceYearsOtherCtrl,
//                             decoration: _decReq("Enter Experience (Others)"),
//                             validator: (v) => _req(v, "Enter experience years"),
//                           ),
//                         const SizedBox(height: 10),
//                       ],

//                       _dropdownWithOthers(
//                         label: "Work Mode",
//                         value: _workMode,
//                         sourceList: _workModeList,
//                         onChanged: (v) => setState(() => _workMode = v),
//                         validatorMsg: "Work Mode is required",
//                       ),
//                       const SizedBox(height: 10),
//                       _dropdownWithOthers(
//                         label: "Shift Timing",
//                         value: _shiftTiming,
//                         sourceList: _shiftList,
//                         onChanged: (v) => setState(() => _shiftTiming = v),
//                         validatorMsg: "Shift Timing is required",
//                       ),
//                       const SizedBox(height: 10),

//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Wrap(
//                           spacing: 8,
//                           runSpacing: 6,
//                           children: _workDaysAll.map((d) {
//                             final selected = _selectedWorkDays.contains(d);
//                             return FilterChip(
//                               label: Text(d),
//                               selected: selected,
//                               onSelected: (on) {
//                                 setState(() {
//                                   if (on) {
//                                     _selectedWorkDays.add(d);
//                                   } else {
//                                     _selectedWorkDays.remove(d);
//                                   }
//                                 });
//                               },
//                             );
//                           }).toList(),
//                         ),
//                       ),

//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _officialEmailCtrl,
//                         decoration: _decOpt("Official Email (optional)"),
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (v) {
//                           final t = (v ?? "").trim();
//                           if (t.isEmpty) return null;
//                           if (!_isEmail(t)) return "Enter a valid email";
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),

//                 _sectionTitle("SECTION 3 — BANK / KYC / SALARY"),
//                 const SizedBox(height: 10),
//                 _card(
//                   Column(
//                     children: [
//                       TextFormField(
//                         controller: _bankNameCtrl,
//                         decoration: _decReq("Bank Name"),
//                         validator: (v) => _req(v, "Bank Name is required"),
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _accountHolderCtrl,
//                         decoration: _decReq("Account Holder Name"),
//                         validator: (v) => _req(v, "Account Holder Name is required"),
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _accountNoCtrl,
//                         decoration: _decReq("Account Number"),
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                         validator: (v) => _req(v, "Account Number is required"),
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _ifscCtrl,
//                         decoration: _decReq("IFSC Code"),
//                         textCapitalization: TextCapitalization.characters,
//                         validator: (v) => _req(v, "IFSC Code is required"),
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _bankBranchCtrl,
//                         decoration: _decReq("Bank Branch"),
//                         validator: (v) => _req(v, "Bank Branch is required"),
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _upiCtrl,
//                         decoration: _decOpt("UPI ID (optional)"),
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _panCtrl,
//                         decoration: _decReq("PAN Number"),
//                         textCapitalization: TextCapitalization.characters,
//                         validator: (v) => _req(v, "PAN Number is required"),
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _aadhaarCtrl,
//                         decoration: _decReq("Aadhaar Number"),
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                           LengthLimitingTextInputFormatter(_aadhaarLen),
//                         ],
//                         validator: (v) {
//                           final t = (v ?? "").trim();
//                           if (t.isEmpty) return "Aadhaar Number is required";
//                           if (t.length != _aadhaarLen) return "Aadhaar must be $_aadhaarLen digits";
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 14),
//                       const Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text("Salary (Earnings)",
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                       ),
//                       const SizedBox(height: 8),

//                       TextFormField(
//                         controller: _basicPayCtrl,
//                         decoration: _decReq("Basic Pay"),
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                         validator: (v) => _req(v, "Basic Pay is required"),
//                       ),
//                       const SizedBox(height: 10),
//                       DropdownButtonFormField<String>(
//                         value: _hraStr,
//                         decoration: _decOpt("HRA"),
//                         items: _moneyOptions
//                             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                             .toList(),
//                         onChanged: (v) {
//                           setState(() => _hraStr = v);
//                           _recalcSalary();
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       DropdownButtonFormField<String>(
//                         value: _bonusStr,
//                         decoration: _decOpt("Bonus"),
//                         items: _moneyOptions
//                             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                             .toList(),
//                         onChanged: (v) {
//                           setState(() => _bonusStr = v);
//                           _recalcSalary();
//                         },
//                       ),

//                       const SizedBox(height: 14),
//                       Row(
//                         children: [
//                           const Expanded(
//                               child: Text("Allowances (Optional)",
//                                   style: TextStyle(fontWeight: FontWeight.bold))),
//                           TextButton.icon(
//                             onPressed: _addAllowanceDialog,
//                             icon: const Icon(Icons.add, size: 18),
//                             label: const Text("Add"),
//                           ),
//                         ],
//                       ),
//                       if (_allowances.isNotEmpty)
//                         ..._allowances.asMap().entries.map((e) {
//                           final idx = e.key;
//                           final a = e.value;
//                           return _miniLineTile(
//                             title: a.name,
//                             value: a.amount.toString(),
//                             onRemove: () {
//                               setState(() => _allowances.removeAt(idx));
//                               _recalcSalary();
//                             },
//                           );
//                         }).toList(),

//                       const SizedBox(height: 14),
//                       const Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text("Deductions",
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           const Expanded(
//                               child: Text("Extra Deductions (Optional)",
//                                   style: TextStyle(fontWeight: FontWeight.w600))),
//                           TextButton.icon(
//                             onPressed: _addDeductionDialog,
//                             icon: const Icon(Icons.add, size: 18),
//                             label: const Text("Add"),
//                           ),
//                         ],
//                       ),
//                       if (_extraDeductions.isNotEmpty)
//                         ..._extraDeductions.asMap().entries.map((e) {
//                           final idx = e.key;
//                           final d = e.value;
//                           return _miniLineTile(
//                             title: d.name,
//                             value: d.amount.toString(),
//                             onRemove: () {
//                               setState(() => _extraDeductions.removeAt(idx));
//                               _recalcSalary();
//                             },
//                           );
//                         }).toList(),

//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _professionalTaxCtrl,
//                         decoration: _decOpt("Professional Tax (optional)"),
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                           controller: _pfNumberCtrl,
//                           decoration: _decOpt("PF Number (optional)")),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                           controller: _esiNumberCtrl,
//                           decoration: _decOpt("ESI Number (optional)")),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                           controller: _grossSalaryCtrl,
//                           decoration: _decOpt("Gross Salary"),
//                           readOnly: true),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                           controller: _netSalaryCtrl,
//                           decoration: _decOpt("Net Salary"),
//                           readOnly: true),
//                     ],
//                   ),
//                 ),

//                 _sectionTitle("SECTION 4 — DOCUMENTS UPLOAD"),
//                 const SizedBox(height: 12),
//                 _card(const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Allowed: PDF / JPG / PNG",
//                         style: TextStyle(fontSize: 12, color: Colors.black54)),
//                   ],
//                 )),
//                 const SizedBox(height: 10),
//                 ..._docs.map(_docTile),

//                 const SizedBox(height: 12),
//                 _sectionTitle("PAY SLIP DOWNLOAD (PDF)"),
//                 const SizedBox(height: 10),
//                 _card(
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "After uploading required documents, you can download the pay slip using Section 3 salary details.",
//                         style: TextStyle(fontSize: 12, color: Colors.black54),
//                       ),
//                       const SizedBox(height: 12),
//                       SizedBox(
//                         height: 46,
//                         width: double.infinity,
//                         child: ElevatedButton.icon(
//                           onPressed: _downloadSalarySlipPdf,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: kButtonColor,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                           ),
//                           icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
//                           label: const Text(
//                             "Download Salary Slip (PDF)",
//                             style: TextStyle(color: Colors.white, fontSize: 15),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       const Text(
//                         "Note: Salary slip download is enabled only after required documents are uploaded.",
//                         style: TextStyle(fontSize: 11, color: Colors.black54),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: _responsiveBottomBar(width),
//     );
//   }
// }



import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'employee_onboarding_models.dart';

/* Theme colors */
const Color kPrimaryBackgroundTop = Color(0xFFFFFFFF);
const Color kPrimaryBackgroundBottom = Color(0xFFD1C4E9);
const Color kAppBarColor = Color(0xFF8C6EAF);
const Color kButtonColor = Color(0xFF655193);
const Color kTextColor = Colors.white;

/* ===================== Local helper model for deductions ===================== */
class DeductionItem {
  final String name;
  final int amount;

  DeductionItem({required this.name, required this.amount});
}

/* ===================== Form Page ===================== */
class EmployeeOnboardingFormPage extends StatefulWidget {
  const EmployeeOnboardingFormPage({
    super.key,
    required this.title,
    this.initialData,
  });

  final String title;
  final EmployeeOnboardFormResult? initialData;

  @override
  State<EmployeeOnboardingFormPage> createState() =>
      _EmployeeOnboardingFormPageState();
}

class _EmployeeOnboardingFormPageState extends State<EmployeeOnboardingFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;

  static const int _pincodeLen = 6;
  static const int _aadhaarLen = 12;

  // Section 1
  final _fullNameCtrl = TextEditingController();
  final _personalEmailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();

  // Date controllers
  final _dobCtrl = TextEditingController();
  final _dojCtrl = TextEditingController();

  // Section 2
  final _officialEmailCtrl = TextEditingController();
  final _employeeIdCtrl = TextEditingController();
  final _experienceYearsOtherCtrl = TextEditingController();

  // Section 3
  final _bankNameCtrl = TextEditingController();
  final _accountHolderCtrl = TextEditingController();
  final _accountNoCtrl = TextEditingController();
  final _ifscCtrl = TextEditingController();
  final _bankBranchCtrl = TextEditingController();
  final _upiCtrl = TextEditingController();

  final _panCtrl = TextEditingController();
  final _aadhaarCtrl = TextEditingController();

  final _basicPayCtrl = TextEditingController();
  final _grossSalaryCtrl = TextEditingController();
  final _netSalaryCtrl = TextEditingController();

  final _professionalTaxCtrl = TextEditingController();
  final _pfNumberCtrl = TextEditingController();
  final _esiNumberCtrl = TextEditingController();

  // Phone
  String _mobileCountryCode = "+91";
  String _mobileNumber = "";
  String _currentIsoCode = "IN";
  int _minPhoneLen = 10;
  int _maxPhoneLen = 10;

  // Dropdowns
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];
  final List<String> _maritalStatuses = ['Single', 'Married'];

  final List<String> _companyList = ['GCARE Pvt Ltd', 'MR TECH Pvt Ltd'];
  final List<String> _branchList = ['Chennai HQ', 'Tiruvallur', 'Coimbatore'];
  final List<String> _deptList = ['IT', 'HR', 'Finance', 'Marketing', 'Operations'];
  final List<String> _designationList = ['Software Engineer', 'Executive', 'HR Associate'];
  final List<String> _workModeList = ['Office', 'Remote', 'Hybrid'];
  final List<String> _shiftList = ['9 AM - 6 PM', '10 AM - 7 PM', 'Night Shift'];

  final List<String> _workDaysAll =
      const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final Set<String> _selectedWorkDays = {'Mon', 'Tue', 'Wed', 'Thu', 'Fri'};

  // Experience
  String _experienceType = "Fresher";
  String? _experienceYears;

  final List<String> _experienceYearsList = const [
    "0 - 6 Months",
    "1 Year",
    "2 Years",
    "3 Years",
    "4 Years",
    "5 Years",
    "6 Years",
    "7 Years",
    "8 Years",
    "9 Years",
    "10 Years",
    "10+ Years",
    "Others",
  ];

  // Salary options
  final List<String> _moneyOptions =
      const ["0", "500", "1000", "2000", "5000", "10000", "Others"];
  String? _hraStr = "0";
  String? _bonusStr = "0";

  final List<AllowanceItem> _allowances = [];
  final List<DeductionItem> _extraDeductions = [];

  // Selected values
  String? _gender;
  String? _bloodGroup;
  String? _maritalStatus;
  DateTime? _dob;

  String? _companyName;
  String? _branchLocation;
  DateTime? _doj;

  String? _department;
  String? _designation;
  String? _workMode;
  // String? _shiftTiming;

  // Documents
  late final List<UploadedDoc> _docs;

  @override
  void initState() {
    super.initState();

    _applyCountryRules(_currentIsoCode);

    _companyName = _companyList.first;
    _branchLocation = _branchList.first;
    _workMode = _workModeList.first;
    // _shiftTiming = _shiftList.first;
    _department = _deptList.first;
    _designation = _designationList.first;

    _employeeIdCtrl.text = _autoEmployeeId();

    _basicPayCtrl.addListener(_recalcSalary);
    _professionalTaxCtrl.addListener(_recalcSalary);
    _recalcSalary();

    _docs = [
      UploadedDoc(key: "resume", label: "Resume", requiredDoc: true),
      UploadedDoc(key: "offer_letter", label: "Offer Letter", requiredDoc: true),
      UploadedDoc(key: "aadhaar_doc", label: "Aadhaar", requiredDoc: true),
      UploadedDoc(key: "pan_doc", label: "PAN", requiredDoc: true),
      UploadedDoc(key: "bank_proof", label: "Bank Proof", requiredDoc: true),
      UploadedDoc(key: "exp_relieving", label: "Experience / Relieving Letter", requiredDoc: false),
      UploadedDoc(key: "marks_10", label: "10th Marksheet", requiredDoc: false),
      UploadedDoc(key: "marks_12", label: "12th Marksheet", requiredDoc: false),
      UploadedDoc(key: "degree", label: "Degree Certificate", requiredDoc: false),
    ];

    // Prefill if initialData exists
    final d = widget.initialData;
    if (d != null) {
      _fullNameCtrl.text = d.fullName;
      _personalEmailCtrl.text = d.personalEmail;
      _addressCtrl.text = d.permanentAddress;
      _cityCtrl.text = d.city;
      _stateCtrl.text = d.state;
      _pincodeCtrl.text = d.pincode;

      _officialEmailCtrl.text = d.officialEmail;
      _employeeIdCtrl.text = d.employeeId;

      _bankNameCtrl.text = d.bankName;
      _accountHolderCtrl.text = d.accountHolderName;
      _accountNoCtrl.text = d.accountNumber;
      _ifscCtrl.text = d.ifscCode;
      _bankBranchCtrl.text = d.bankBranch;
      _upiCtrl.text = d.upiId;

      _panCtrl.text = d.panNumber;
      _aadhaarCtrl.text = d.aadhaarNumber;

      _basicPayCtrl.text = d.basicPay.toString();
      _professionalTaxCtrl.text = d.professionalTax.toString();
      _pfNumberCtrl.text = d.pfNumber;
      _esiNumberCtrl.text = d.esiNumber;

      _gender = d.gender.isEmpty ? null : d.gender;
      _bloodGroup = d.bloodGroup.isEmpty ? null : d.bloodGroup;
      _maritalStatus = d.maritalStatus.isEmpty ? null : d.maritalStatus;

      _dob = d.dob;
      _doj = d.doj;

      _companyName = d.companyName.isEmpty ? _companyName : d.companyName;
      _branchLocation = d.branchLocation.isEmpty ? _branchLocation : d.branchLocation;
      _department = d.department.isEmpty ? _department : d.department;
      _designation = d.designation.isEmpty ? _designation : d.designation;
      _workMode = d.workMode.isEmpty ? _workMode : d.workMode;
      // _shiftTiming = d.shiftTiming.isEmpty ? _shiftTiming : d.shiftTiming;

      _mobileCountryCode = d.mobileCountryCode.isEmpty ? _mobileCountryCode : d.mobileCountryCode;
      _mobileNumber = d.mobileNumber;

      _selectedWorkDays
        ..clear()
        ..addAll(d.workDays);

      _hraStr = d.hra.toString();
      _bonusStr = d.bonus.toString();

      // Restore docs
      for (final doc in _docs) {
        final dynamic saved = d.documents[doc.key];
        if (saved is Map<String, dynamic>) {
          doc.fileName = (saved["fileName"] ?? saved["name"])?.toString();
          doc.ext = (saved["ext"])?.toString();
          doc.path = (saved["path"])?.toString();

          final String? b64 = saved["base64"]?.toString();
          if (b64 != null && b64.trim().isNotEmpty) {
            try {
              doc.bytes = base64Decode(b64);
            } catch (_) {}
          }
        }
      }

      if (_dob != null) _dobCtrl.text = _fmtDate(_dob!);
      if (_doj != null) _dojCtrl.text = _fmtDate(_doj!);

      _recalcSalary();
    }
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _personalEmailCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _pincodeCtrl.dispose();

    _dobCtrl.dispose();
    _dojCtrl.dispose();

    _officialEmailCtrl.dispose();
    _employeeIdCtrl.dispose();
    _experienceYearsOtherCtrl.dispose();

    _bankNameCtrl.dispose();
    _accountHolderCtrl.dispose();
    _accountNoCtrl.dispose();
    _ifscCtrl.dispose();
    _bankBranchCtrl.dispose();
    _upiCtrl.dispose();

    _panCtrl.dispose();
    _aadhaarCtrl.dispose();

    _basicPayCtrl.dispose();
    _grossSalaryCtrl.dispose();
    _netSalaryCtrl.dispose();

    _professionalTaxCtrl.dispose();
    _pfNumberCtrl.dispose();
    _esiNumberCtrl.dispose();

    super.dispose();
  }

  String _autoEmployeeId() {
    final ms = DateTime.now().millisecondsSinceEpoch.toString();
    return "GC${ms.substring(ms.length - 4)}";
  }

  int _toInt(String? v) {
    final t = (v ?? "").trim();
    if (t.isEmpty) return 0;
    return int.tryParse(t) ?? 0;
  }

  int _allowancesSum() {
    int sum = 0;
    for (final a in _allowances) {
      sum += a.amount;
    }
    return sum;
  }

  int _extraDeductionsSum() {
    int sum = 0;
    for (final d in _extraDeductions) {
      sum += d.amount;
    }
    return sum;
  }

  void _recalcSalary() {
    final basic = _toInt(_basicPayCtrl.text);
    final hra = _toInt(_hraStr);
    final bonus = _toInt(_bonusStr);
    final allowances = _allowancesSum();

    final extraDed = _extraDeductionsSum();
    final profTax = _toInt(_professionalTaxCtrl.text);

    final gross = basic + hra + allowances + bonus;
    final totalDed = extraDed + profTax;
    final net = gross - totalDed;

    _grossSalaryCtrl.text = gross.toString();
    _netSalaryCtrl.text = net.toString();

    if (mounted) setState(() {});
  }

  void _applyCountryRules(String isoCode) {
    final country = countries.firstWhere(
      (c) => c.code.toUpperCase() == isoCode.toUpperCase(),
      orElse: () => countries.firstWhere((c) => c.code == "IN"),
    );

    setState(() {
      _currentIsoCode = country.code;

      _minPhoneLen = (country.minLength ?? 6).clamp(4, 15);
      _maxPhoneLen = (country.maxLength ?? 15).clamp(_minPhoneLen, 15);

      if (_currentIsoCode.toUpperCase() == "IN") {
        _minPhoneLen = 10;
        _maxPhoneLen = 10;
      }

      _mobileCountryCode = "+${country.dialCode}";

      if (_mobileNumber.length > _maxPhoneLen) {
        _mobileNumber = _mobileNumber.substring(0, _maxPhoneLen);
      }
    });
  }

  // ===================== DATE PICKERS =====================
  Future<DateTime?> _openDatePicker({
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 80));

    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year - 10, 12, 31);
    var initial = _dob ?? DateTime(now.year - 22, 1, 1);

    if (initial.isBefore(DateTime(1950, 1, 1))) {
      initial = DateTime(1950, 1, 1);
    } else if (initial.isAfter(lastDate)) {
      initial = lastDate;
    }

    final picked = await _openDatePicker(
      initialDate: initial,
      firstDate: DateTime(1950, 1, 1),
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        _dob = picked;
        _dobCtrl.text = _fmtDate(picked);
      });
    }
  }

  Future<void> _pickDoj() async {
    final now = DateTime.now();
    final initial = _doj ?? now;

    final picked = await _openDatePicker(
      initialDate: initial,
      firstDate: DateTime(now.year - 10, 1, 1),
      lastDate: DateTime(now.year + 1, 12, 31),
    );

    if (picked != null) {
      setState(() {
        _doj = picked;
        _dojCtrl.text = _fmtDate(picked);
      });
    }
  }

  String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString();
    return "$yy-$mm-$dd";
  }

  String? _req(String? v, String msg) {
    if (v == null || v.trim().isEmpty) return msg;
    return null;
  }

  bool _isEmail(String v) {
    final t = v.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t);
  }

  // ===================== UI DECORATIONS =====================
  InputDecoration _decReq(String label) {
    return _baseDec(
      labelWidget: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(text: label),
            const TextSpan(text: " "),
            const TextSpan(
              text: "*",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _decOpt(String label) => _baseDec(labelText: label);

  InputDecoration _baseDec({String? labelText, Widget? labelWidget}) {
    return InputDecoration(
      labelText: labelText,
      label: labelWidget,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0x22000000)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kButtonColor.withOpacity(0.7)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
      errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
    );
  }

  Widget _sectionTitle(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x22000000)),
      ),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  Widget _card(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x22000000)),
      ),
      child: child,
    );
  }

  // ✅ Web-safe calendar field: ALWAYS clickable
  Widget _calendarFieldWebSafe({
    required String label,
    required TextEditingController controller,
    required VoidCallback onPick,
    required String validatorMsg,
  }) {
    return Stack(
      children: [
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: _decReq(label).copyWith(
            suffixIcon: const Icon(Icons.calendar_month),
          ),
          validator: (v) => _req(v, validatorMsg),
          onTap: onPick,
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                onPick();
              },
            ),
          ),
        ),
      ],
    );
  }

  // ===================== SECTION 2 “OTHERS” ADD SUPPORT =====================
  Future<String?> _showAddOtherDialog(String title) async {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Add $title"),
          content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(hintText: "Enter value"),
            autofocus: true,
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, null),
                child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                final v = ctrl.text.trim();
                if (v.isEmpty) return;
                Navigator.pop(ctx, v);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget _dropdownWithOthers({
    required String label,
    required String? value,
    required List<String> sourceList,
    required void Function(String? v) onChanged,
    required String validatorMsg,
  }) {
    final items = <String>[...sourceList.where((e) => e.trim().isNotEmpty)];
    if (!items.contains("Others")) items.add("Others");

    return DropdownButtonFormField<String>(
      value: value,
      decoration: _decReq(label),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) async {
        if (v == "Others") {
          final newVal = await _showAddOtherDialog(label);
          if (newVal == null || newVal.trim().isEmpty) return;
          setState(() {
            if (!sourceList.contains(newVal)) sourceList.add(newVal);
          });
          onChanged(newVal);
          return;
        }
        onChanged(v);
      },
      validator: (v) => _req(v, validatorMsg),
    );
  }

  // ===================== Allowance / Deduction dialogs =====================
  Future<void> _addAllowanceDialog() async {
    final nameCtrl = TextEditingController();
    final amtCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add Allowance (Optional)"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(hintText: "Allowance name")),
              const SizedBox(height: 10),
              TextField(
                controller: amtCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(hintText: "Amount"),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Cancel")),
            ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text("Add")),
          ],
        );
      },
    );

    if (ok != true) return;

    final name = nameCtrl.text.trim();
    final amt = _toInt(amtCtrl.text);
    if (name.isEmpty || amt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid allowance name and amount.")),
      );
      return;
    }

    setState(() => _allowances.add(AllowanceItem(name: name, amount: amt)));
    _recalcSalary();
  }

  Future<void> _addDeductionDialog() async {
    final nameCtrl = TextEditingController();
    final amtCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add Deduction (Optional)"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(hintText: "Deduction name")),
              const SizedBox(height: 10),
              TextField(
                controller: amtCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(hintText: "Amount"),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Cancel")),
            ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text("Add")),
          ],
        );
      },
    );

    if (ok != true) return;

    final name = nameCtrl.text.trim();
    final amt = _toInt(amtCtrl.text);
    if (name.isEmpty || amt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid deduction name and amount.")),
      );
      return;
    }

    setState(() => _extraDeductions.add(DeductionItem(name: name, amount: amt)));
    _recalcSalary();
  }

  Widget _miniLineTile({
    required String title,
    required String value,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x22000000)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$title: Rs. $value",
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            tooltip: "Remove",
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline, size: 20),
          ),
        ],
      ),
    );
  }

  // ===================== DOCUMENTS =====================
  Future<void> _viewDoc(UploadedDoc doc) async {
    if (!doc.hasFile) return;

    if (kIsWeb) {
      final Uint8List bytes = doc.bytes!;
      final String ext = (doc.ext ?? "").toLowerCase();

      String mime = "application/octet-stream";
      if (ext == "pdf") mime = "application/pdf";
      if (ext == "png") mime = "image/png";
      if (ext == "jpg" || ext == "jpeg") mime = "image/jpeg";

      final String b64 = base64Encode(bytes);
      final Uri uri = Uri.parse("data:$mime;base64,$b64");
      await launchUrl(uri, webOnlyWindowName: '_blank');
      return;
    }

    final String? path = doc.path;
    if (path == null || path.isEmpty) return;
    await OpenFilex.open(path);
  }

  Future<void> _pickDoc(UploadedDoc doc) async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'png', 'jpg', 'jpeg'],
      withData: kIsWeb,
    );

    if (res == null || res.files.isEmpty) return;
    final f = res.files.first;

    setState(() {
      doc.fileName = f.name;
      doc.ext = f.extension?.toLowerCase();
      doc.path = f.path;
      doc.bytes = f.bytes;
    });
  }

  bool _validateDocuments({bool showSnack = true}) {
    for (final d in _docs) {
      if (d.requiredDoc && !d.hasFile) {
        if (showSnack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${d.label} is required")),
          );
        }
        return false;
      }
    }
    return true;
  }

  Widget _docTile(UploadedDoc doc) {
    final title = doc.requiredDoc ? "${doc.label} *" : "${doc.label} (Optional)";
    final bool showRed = _submitted && doc.requiredDoc && !doc.hasFile;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: showRed ? Colors.red : const Color(0x22000000),
          width: showRed ? 1.2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          if (doc.fileName != null && doc.fileName!.trim().isNotEmpty) ...[
            Text(
              "Selected: ${doc.fileName}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 10),
          ],
          if (showRed) ...[
            const Text("This document is required.",
                style: TextStyle(color: Colors.red, fontSize: 12)),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kButtonColor,
                      side: BorderSide(color: kButtonColor.withOpacity(0.6)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _pickDoc(doc),
                    icon: const Icon(Icons.file_upload_outlined, size: 18),
                    label: Text(doc.hasFile ? "Change" : "Upload"),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          doc.hasFile ? kButtonColor : Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: doc.hasFile ? () => _viewDoc(doc) : null,
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: const Text("View"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================== PAY SLIP PDF (kept in code, but UI removed) =====================
  pw.Widget _pdfKeyValue(String k, String v) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(k, style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
          pw.SizedBox(width: 10),
          pw.Expanded(
            child: pw.Text(v,
                textAlign: pw.TextAlign.right,
                style: const pw.TextStyle(fontSize: 9)),
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfMoneyRow(String name, int amt) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(name, style: const pw.TextStyle(fontSize: 9)),
          pw.Text("Rs. $amt", style: const pw.TextStyle(fontSize: 9)),
        ],
      ),
    );
  }

  Future<Uint8List> _buildSalarySlipPdfLikeImage() async {
    _recalcSalary();

    final employeeName =
        _fullNameCtrl.text.trim().isEmpty ? "-" : _fullNameCtrl.text.trim();
    final empId =
        _employeeIdCtrl.text.trim().isEmpty ? "-" : _employeeIdCtrl.text.trim();
    final doj = _doj == null ? "-" : _fmtDate(_doj!);

    final basic = _toInt(_basicPayCtrl.text);
    final hra = _toInt(_hraStr);
    final bonus = _toInt(_bonusStr);
    final allowances = _allowancesSum();

    final extraDed = _extraDeductionsSum();
    final profTax = _toInt(_professionalTaxCtrl.text);

    final gross = basic + hra + allowances + bonus;
    final totalDed = extraDed + profTax;
    final net = gross - totalDed;

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(22),
        build: (ctx) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(10),
              color: PdfColors.white,
            ),
            padding: const pw.EdgeInsets.all(14),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("MR TECH",
                            style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 2),
                        pw.Text("Myth Reality Technologies Pvt. Ltd",
                            style: pw.TextStyle(
                                fontSize: 9, color: PdfColors.grey700)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text("Payslip For the Month",
                            style: pw.TextStyle(
                                fontSize: 9, color: PdfColors.grey700)),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          DateTime.now().toString().substring(0, 7),
                          style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Divider(color: PdfColors.grey300),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.grey300),
                          borderRadius: pw.BorderRadius.circular(8),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("EMPLOYEE SUMMARY",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 6),
                            _pdfKeyValue("Employee Name", employeeName),
                            _pdfKeyValue("Designation", _designation ?? "-"),
                            _pdfKeyValue("Employee ID", empId),
                            _pdfKeyValue("Date of Joining", doj),
                          ],
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          borderRadius: pw.BorderRadius.circular(8),
                          border: pw.Border.all(color: PdfColors.grey300),
                          color: PdfColors.green50,
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Net Pay",
                                style: pw.TextStyle(
                                    fontSize: 9, color: PdfColors.grey700)),
                            pw.SizedBox(height: 6),
                            pw.Text("Rs. $net",
                                style: pw.TextStyle(
                                    fontSize: 16,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 8),
                            pw.Text("Employee Net Pay",
                                style: const pw.TextStyle(fontSize: 9)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Text("EARNINGS",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Expanded(
                            child: pw.Text("DEDUCTIONS",
                                textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: pw.Column(
                              children: [
                                _pdfMoneyRow("Basic", basic),
                                _pdfMoneyRow("House Rent Allowance", hra),
                                _pdfMoneyRow("Allowances", allowances),
                                _pdfMoneyRow("Bonus", bonus),
                                pw.Divider(color: PdfColors.grey300),
                                _pdfMoneyRow("Gross Earnings", gross),
                              ],
                            ),
                          ),
                          pw.SizedBox(width: 12),
                          pw.Expanded(
                            child: pw.Column(
                              children: [
                                _pdfMoneyRow("Extra Deductions", extraDed),
                                _pdfMoneyRow("Professional Tax", profTax),
                                pw.Divider(color: PdfColors.grey300),
                                _pdfMoneyRow("Total Deductions", totalDed),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.circular(8),
                    border: pw.Border.all(color: PdfColors.grey300),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("TOTAL NET PAYABLE",
                          style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold)),
                      pw.Text("Rs. $net",
                          style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ),
                pw.Spacer(),
                pw.Center(
                  child: pw.Text("This is a system generated salary slip.",
                      style: pw.TextStyle(
                          fontSize: 8, color: PdfColors.grey700)),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> _downloadSalarySlipPdf() async {
    if (!_validateDocuments()) return;

    final bytes = await _buildSalarySlipPdfLikeImage();
    final fileName =
        "salary_slip_${_employeeIdCtrl.text.trim().isEmpty ? "employee" : _employeeIdCtrl.text.trim()}.pdf";

    if (kIsWeb) {
      final b64 = base64Encode(bytes);
      final uri = Uri.parse("data:application/pdf;base64,$b64");
      await launchUrl(uri, webOnlyWindowName: "_blank");
      return;
    }

    await Printing.layoutPdf(
      onLayout: (format) async => bytes,
      name: fileName,
    );
  }

  void _submit() {
    setState(() => _submitted = true);

    final ok = _formKey.currentState?.validate() ?? false;
    final docsOk = _validateDocuments(showSnack: false);

    if (!ok || !docsOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields.")),
      );
      return;
    }

    if (_dob == null || _doj == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select Date of Birth and Date of Joining.")),
      );
      return;
    }

    if (_experienceType == "Experienced") {
      final yrs = (_experienceYears ?? "").trim();
      final other = _experienceYearsOtherCtrl.text.trim();
      if (yrs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Experience years is required.")),
        );
        return;
      }
      if (yrs == "Others" && other.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter experience years (Others).")),
        );
        return;
      }
    }

    _recalcSalary();
    final deductionsTotalToSave = _extraDeductionsSum();

    final Map<String, dynamic> docsMap = {};
    for (final doc in _docs) {
      final json = doc.toJson();
      if (kIsWeb && doc.bytes != null) {
        json["base64"] = base64Encode(doc.bytes!);
      }
      docsMap[doc.key] = json;
    }

    final result = EmployeeOnboardFormResult(
      fullName: _fullNameCtrl.text.trim(),
      gender: (_gender ?? "").trim(),
      dob: _dob!,
      bloodGroup: (_bloodGroup ?? "").trim(),
      maritalStatus: (_maritalStatus ?? "").trim(),
      personalEmail: _personalEmailCtrl.text.trim(),
      mobileCountryCode: _mobileCountryCode.trim(),
      mobileNumber: _mobileNumber.trim(),
      permanentAddress: _addressCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      state: _stateCtrl.text.trim(),
      pincode: _pincodeCtrl.text.trim(),
      companyName: (_companyName ?? "").trim(),
      branchLocation: (_branchLocation ?? "").trim(),
      employeeId: _employeeIdCtrl.text.trim(),
      doj: _doj!,
      department: (_department ?? "").trim(),
      designation: (_designation ?? "").trim(),
      workMode: (_workMode ?? "").trim(),
      // shiftTiming: (_shiftTiming ?? "").trim(),
      workDays: _selectedWorkDays.toList(),
      officialEmail: _officialEmailCtrl.text.trim(),
      bankName: _bankNameCtrl.text.trim(),
      accountHolderName: _accountHolderCtrl.text.trim(),
      accountNumber: _accountNoCtrl.text.trim(),
      ifscCode: _ifscCtrl.text.trim(),
      bankBranch: _bankBranchCtrl.text.trim(),
      upiId: _upiCtrl.text.trim(),
      panNumber: _panCtrl.text.trim(),
      aadhaarNumber: _aadhaarCtrl.text.trim(),
      basicPay: _toInt(_basicPayCtrl.text),
      hra: _toInt(_hraStr),
      bonus: _toInt(_bonusStr),
      allowancesTotal: _allowancesSum(),
      deductionsAmount: deductionsTotalToSave,
      professionalTax: _toInt(_professionalTaxCtrl.text),
      pfNumber: _pfNumberCtrl.text.trim(),
      esiNumber: _esiNumberCtrl.text.trim(),
      grossSalary: _toInt(_grossSalaryCtrl.text),
      netSalary: _toInt(_netSalaryCtrl.text),
      documents: docsMap, shiftTiming: '',
    );

    Navigator.pop(context, result);
  }

  Widget _responsiveBottomBar(double width) {
    final cancelBtn = SizedBox(
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: kButtonColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => Navigator.pop(context),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: 16, height: 1.0),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );

    final saveBtn = SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: kButtonColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Save & Send to Super Admin",
            style: TextStyle(color: Colors.white, fontSize: 16, height: 1.0),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          border: const Border(top: BorderSide(color: Color(0x22000000))),
        ),
        child: Row(
          children: [
            Expanded(child: cancelBtn),
            const SizedBox(width: 12),
            Expanded(child: saveBtn),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: kAppBarColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kPrimaryBackgroundTop, kPrimaryBackgroundBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode:
                _submitted ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 120),
              children: [
                _sectionTitle("SECTION 1 — BASIC INFORMATION"),
                const SizedBox(height: 10),
                _card(
                  Column(
                    children: [
                      TextFormField(
                        controller: _fullNameCtrl,
                        decoration: _decReq("Full Name"),
                        validator: (v) => _req(v, "Full Name is required"),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _gender,
                        decoration: _decReq("Gender"),
                        items: _genders
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _gender = v),
                        validator: (v) => _req(v, "Gender is required"),
                      ),
                      const SizedBox(height: 10),
                      _calendarFieldWebSafe(
                        label: "Date of Birth",
                        controller: _dobCtrl,
                        onPick: _pickDob,
                        validatorMsg: "Date of Birth is required",
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _bloodGroup,
                        decoration: _decReq("Blood Group"),
                        items: _bloodGroups
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _bloodGroup = v),
                        validator: (v) => _req(v, "Blood Group is required"),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _maritalStatus,
                        decoration: _decReq("Marital Status"),
                        items: _maritalStatuses
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _maritalStatus = v),
                        validator: (v) => _req(v, "Marital Status is required"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _personalEmailCtrl,
                        decoration: _decReq("Personal Email"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          final t = (v ?? "").trim();
                          if (t.isEmpty) return "Personal Email is required";
                          if (!_isEmail(t)) return "Enter a valid email";
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      IntlPhoneField(
                        decoration: _decReq("Mobile Number"),
                        initialCountryCode: _currentIsoCode,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onCountryChanged: (c) => _applyCountryRules(c.code),
                        onChanged: (phone) {
                          setState(() {
                            _mobileCountryCode = phone.countryCode;
                            _mobileNumber = phone.number;
                          });
                        },
                        validator: (phone) {
                          final num = (phone?.number ?? "").trim();
                          if (num.isEmpty) return "Mobile number is required";
                          if (num.length < _minPhoneLen || num.length > _maxPhoneLen) {
                            return "Enter valid number ($_minPhoneLen-$_maxPhoneLen digits)";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _addressCtrl,
                        decoration: _decReq("Permanent Address"),
                        validator: (v) => _req(v, "Address is required"),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cityCtrl,
                              decoration: _decReq("City"),
                              validator: (v) => _req(v, "City is required"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _stateCtrl,
                              decoration: _decReq("State"),
                              validator: (v) => _req(v, "State is required"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _pincodeCtrl,
                        decoration: _decReq("Pincode"),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(_pincodeLen),
                        ],
                        validator: (v) {
                          final t = (v ?? "").trim();
                          if (t.isEmpty) return "Pincode is required";
                          if (t.length != _pincodeLen) return "Pincode must be $_pincodeLen digits";
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                _sectionTitle("SECTION 2 — COMPANY INFORMATION"),
                const SizedBox(height: 10),
                _card(
                  Column(
                    children: [
                      _dropdownWithOthers(
                        label: "Company Name",
                        value: _companyName,
                        sourceList: _companyList,
                        onChanged: (v) => setState(() => _companyName = v),
                        validatorMsg: "Company Name is required",
                      ),
                      const SizedBox(height: 10),
                      _dropdownWithOthers(
                        label: "Branch Location",
                        value: _branchLocation,
                        sourceList: _branchList,
                        onChanged: (v) => setState(() => _branchLocation = v),
                        validatorMsg: "Branch Location is required",
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _employeeIdCtrl,
                        decoration: _decReq("Employee ID"),
                        validator: (v) => _req(v, "Employee ID is required"),
                      ),
                      const SizedBox(height: 10),
                      _calendarFieldWebSafe(
                        label: "Date of Joining",
                        controller: _dojCtrl,
                        onPick: _pickDoj,
                        validatorMsg: "Date of Joining is required",
                      ),
                      const SizedBox(height: 10),
                      _dropdownWithOthers(
                        label: "Department",
                        value: _department,
                        sourceList: _deptList,
                        onChanged: (v) => setState(() => _department = v),
                        validatorMsg: "Department is required",
                      ),
                      const SizedBox(height: 10),
                      _dropdownWithOthers(
                        label: "Designation",
                        value: _designation,
                        sourceList: _designationList,
                        onChanged: (v) => setState(() => _designation = v),
                        validatorMsg: "Designation is required",
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Text("Fresher"),
                              selected: _experienceType == "Fresher",
                              onSelected: (_) => setState(() {
                                _experienceType = "Fresher";
                                _experienceYears = null;
                                _experienceYearsOtherCtrl.clear();
                              }),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ChoiceChip(
                              label: const Text("Experienced"),
                              selected: _experienceType == "Experienced",
                              onSelected: (_) =>
                                  setState(() => _experienceType = "Experienced"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_experienceType == "Experienced") ...[
                        DropdownButtonFormField<String>(
                          value: _experienceYears,
                          decoration: _decReq("Experience Years"),
                          items: _experienceYearsList
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) => setState(() => _experienceYears = v),
                          validator: (v) => _req(v, "Experience Years is required"),
                        ),
                        const SizedBox(height: 10),
                        if (_experienceYears == "Others")
                          TextFormField(
                            controller: _experienceYearsOtherCtrl,
                            decoration: _decReq("Enter Experience (Others)"),
                            validator: (v) => _req(v, "Enter experience years"),
                          ),
                        const SizedBox(height: 10),
                      ],
                      _dropdownWithOthers(
                        label: "Work Mode",
                        value: _workMode,
                        sourceList: _workModeList,
                        onChanged: (v) => setState(() => _workMode = v),
                        validatorMsg: "Work Mode is required",
                      ),
                      const SizedBox(height: 10),
                      // _dropdownWithOthers(
                      //   label: "Shift Timing",
                      //   value: _shiftTiming,
                      //   sourceList: _shiftList,
                      //   onChanged: (v) => setState(() => _shiftTiming = v),
                      //   validatorMsg: "Shift Timing is required",
                      // ),
                      // const SizedBox(height: 10),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Wrap(
                      //     spacing: 8,
                      //     runSpacing: 6,
                      //     children: _workDaysAll.map((d) {
                      //       final selected = _selectedWorkDays.contains(d);
                      //       return FilterChip(
                      //         label: Text(d),
                      //         selected: selected,
                      //         onSelected: (on) {
                      //           setState(() {
                      //             if (on) {
                      //               _selectedWorkDays.add(d);
                      //             } else {
                      //               _selectedWorkDays.remove(d);
                      //             }
                      //           });
                      //         },
                      //       );
                      //     }).toList(),
                      //   ),
                      // ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _officialEmailCtrl,
                        decoration: _decOpt("Official Email (optional)"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          final t = (v ?? "").trim();
                          if (t.isEmpty) return null;
                          if (!_isEmail(t)) return "Enter a valid email";
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                _sectionTitle("SECTION 3 — BANK / KYC / SALARY"),
                const SizedBox(height: 10),
                _card(
                  Column(
                    children: [
                      TextFormField(
                        controller: _bankNameCtrl,
                        decoration: _decReq("Bank Name"),
                        validator: (v) => _req(v, "Bank Name is required"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _accountHolderCtrl,
                        decoration: _decReq("Account Holder Name"),
                        validator: (v) => _req(v, "Account Holder Name is required"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _accountNoCtrl,
                        decoration: _decReq("Account Number"),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (v) => _req(v, "Account Number is required"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _ifscCtrl,
                        decoration: _decReq("IFSC Code"),
                        textCapitalization: TextCapitalization.characters,
                        validator: (v) => _req(v, "IFSC Code is required"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _bankBranchCtrl,
                        decoration: _decReq("Bank Branch"),
                        validator: (v) => _req(v, "Bank Branch is required"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _upiCtrl,
                        decoration: _decOpt("UPI ID (optional)"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _panCtrl,
                        decoration: _decReq("PAN Number"),
                        textCapitalization: TextCapitalization.characters,
                        validator: (v) => _req(v, "PAN Number is required"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _aadhaarCtrl,
                        decoration: _decReq("Aadhaar Number"),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(_aadhaarLen),
                        ],
                        validator: (v) {
                          final t = (v ?? "").trim();
                          if (t.isEmpty) return "Aadhaar Number is required";
                          if (t.length != _aadhaarLen) return "Aadhaar must be $_aadhaarLen digits";
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Salary (Earnings)",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _basicPayCtrl,
                        decoration: _decReq("Basic Pay"),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (v) => _req(v, "Basic Pay is required"),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _hraStr,
                        decoration: _decOpt("HRA"),
                        items: _moneyOptions
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) {
                          setState(() => _hraStr = v);
                          _recalcSalary();
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _bonusStr,
                        decoration: _decOpt("Bonus"),
                        items: _moneyOptions
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) {
                          setState(() => _bonusStr = v);
                          _recalcSalary();
                        },
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Expanded(
                              child: Text("Allowances (Optional)",
                                  style: TextStyle(fontWeight: FontWeight.bold))),
                          TextButton.icon(
                            onPressed: _addAllowanceDialog,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text("Add"),
                          ),
                        ],
                      ),
                      if (_allowances.isNotEmpty)
                        ..._allowances.asMap().entries.map((e) {
                          final idx = e.key;
                          final a = e.value;
                          return _miniLineTile(
                            title: a.name,
                            value: a.amount.toString(),
                            onRemove: () {
                              setState(() => _allowances.removeAt(idx));
                              _recalcSalary();
                            },
                          );
                        }).toList(),
                      const SizedBox(height: 14),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Deductions",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Expanded(
                              child: Text("Extra Deductions (Optional)",
                                  style: TextStyle(fontWeight: FontWeight.w600))),
                          TextButton.icon(
                            onPressed: _addDeductionDialog,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text("Add"),
                          ),
                        ],
                      ),
                      if (_extraDeductions.isNotEmpty)
                        ..._extraDeductions.asMap().entries.map((e) {
                          final idx = e.key;
                          final d = e.value;
                          return _miniLineTile(
                            title: d.name,
                            value: d.amount.toString(),
                            onRemove: () {
                              setState(() => _extraDeductions.removeAt(idx));
                              _recalcSalary();
                            },
                          );
                        }).toList(),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _professionalTaxCtrl,
                        decoration: _decOpt("Professional Tax (optional)"),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                          controller: _pfNumberCtrl,
                          decoration: _decOpt("PF Number (optional)")),
                      const SizedBox(height: 10),
                      TextFormField(
                          controller: _esiNumberCtrl,
                          decoration: _decOpt("ESI Number (optional)")),
                      const SizedBox(height: 10),
                      TextFormField(
                          controller: _grossSalaryCtrl,
                          decoration: _decOpt("Gross Salary"),
                          readOnly: true),
                      const SizedBox(height: 10),
                      TextFormField(
                          controller: _netSalaryCtrl,
                          decoration: _decOpt("Net Salary"),
                          readOnly: true),
                    ],
                  ),
                ),

                _sectionTitle("SECTION 4 — DOCUMENTS UPLOAD"),
                const SizedBox(height: 12),
                _card(const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Allowed: PDF / JPG / PNG",
                        style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                )),
                const SizedBox(height: 10),
                ..._docs.map(_docTile),

                // ✅ REMOVED: PAY SLIP DOWNLOAD (PDF) UI section as requested
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _responsiveBottomBar(width),
    );
  }
}