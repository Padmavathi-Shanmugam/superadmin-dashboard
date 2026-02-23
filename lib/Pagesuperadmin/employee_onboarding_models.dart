import 'dart:typed_data';


/// Normalizes document keys to canonical format
Map<String, dynamic> normalizeDocuments(Map<String, dynamic> rawDocs) {
  final normalized = <String, dynamic>{};
  
  for (final entry in rawDocs.entries) {
    final key = _normalizeDocumentKey(entry.key);
    normalized[key] = entry.value;
  }
  
  return normalized;
}

/// Normalizes a single document key to canonical format
String _normalizeDocumentKey(String key) {
  final normalized = key.toLowerCase().trim();
  
  // Handle variations
  switch (normalized) {
    // 10th marksheet variations
    case '10thmarksheet':
    case 'tenthmarksheet':
      return 'tenthMarksheet';
    
    // 12th marksheet variations  
    case '12thmarksheet':
    case 'twelfthmarksheet':
      return 'twelfthMarksheet';
    
    // Degree certificate variations
    case 'degreecertificate':
      return 'provisionalCertificate';
    
    // Bank proof variations
    case 'bankproof':
      return 'bankBook';
    
    // Experience letter variations
    case 'experienceletter':
      return 'experienceCertificate';
    
    default:
      return key; // Keep original if no mapping found
  }
}



class AllowanceItem {

  final String name;

  final int amount;



  AllowanceItem({required this.name, required this.amount});



  Map<String, dynamic> toJson() => {

        "name": name,

        "amount": amount,

      };



  factory AllowanceItem.fromJson(Map<String, dynamic> json) => AllowanceItem(

        name: (json["name"] ?? "").toString(),

        amount: (json["amount"] is int)

            ? json["amount"]

            : int.tryParse((json["amount"] ?? "0").toString()) ?? 0,

      );

}



class UploadedDoc {

  final String key;

  final String label;

  final bool requiredDoc;



  String? fileName;

  String? ext;

  String? path;

  Uint8List? bytes;



  UploadedDoc({

    required this.key,

    required this.label,

    required this.requiredDoc,

    this.fileName,

    this.ext,

    this.path,

    this.bytes,

  });



  bool get hasFile {

    if (bytes != null && bytes!.isNotEmpty) return true;

    if (path != null && path!.trim().isNotEmpty) return true;

    return false;

  }



  Map<String, dynamic> toJson() => {

        "fileName": fileName,

        "ext": ext,

        "path": path,

      };



  factory UploadedDoc.fromJson({

    required String key,

    required String label,

    required bool requiredDoc,

    required Map<String, dynamic> json,

  }) {

    return UploadedDoc(

      key: key,

      label: label,

      requiredDoc: requiredDoc,

      fileName: (json["fileName"] ?? json["name"])?.toString(),

      ext: (json["ext"])?.toString(),

      path: (json["path"])?.toString(),

    );

  }

}



class EmployeeOnboardFormResult {

  final String fullName;

  final String gender;

  final DateTime dob;

  final String bloodGroup;

  final String maritalStatus;

  final String personalEmail;

  final String mobileCountryCode;

  final String mobileNumber;

  final String permanentAddress;

  final String city;

  final String state;

  final String pincode;



  final String companyName;

  final String branchLocation;

  final String employeeId;

  final DateTime doj;

  final String department;

  final String designation;

  final String workMode;

  final String shiftTiming;

  final List<String> workDays;

  final String officialEmail;



  final String bankName;

  final String accountHolderName;

  final String accountNumber;

  final String ifscCode;

  final String bankBranch;

  final String upiId;



  final String panNumber;

  final String aadhaarNumber;



  final int basicPay;

  final int hra;

  final int bonus;

  final int allowancesTotal;



  final int deductionsAmount;

  final int professionalTax;

  final String pfNumber;

  final String esiNumber;



  final int grossSalary;

  final int netSalary;



  final Map<String, dynamic> documents;



  EmployeeOnboardFormResult({

    required this.fullName,

    required this.gender,

    required this.dob,

    required this.bloodGroup,

    required this.maritalStatus,

    required this.personalEmail,

    required this.mobileCountryCode,

    required this.mobileNumber,

    required this.permanentAddress,

    required this.city,

    required this.state,

    required this.pincode,

    required this.companyName,

    required this.branchLocation,

    required this.employeeId,

    required this.doj,

    required this.department,

    required this.designation,

    required this.workMode,

    required this.shiftTiming,

    required this.workDays,

    required this.officialEmail,

    required this.bankName,

    required this.accountHolderName,

    required this.accountNumber,

    required this.ifscCode,

    required this.bankBranch,

    required this.upiId,

    required this.panNumber,

    required this.aadhaarNumber,

    required this.basicPay,

    required this.hra,

    required this.bonus,

    required this.allowancesTotal,

    required this.deductionsAmount,

    required this.professionalTax,

    required this.pfNumber,

    required this.esiNumber,

    required this.grossSalary,

    required this.netSalary,

    required this.documents,

  });

  /// Creates EmployeeOnboardFormResult from JSON with document normalization
  factory EmployeeOnboardFormResult.fromJson(Map<String, dynamic> json) {
    // Parse and normalize documents
    final rawDocuments = json['documents'] as Map<String, dynamic>? ?? {};
    final normalizedDocuments = normalizeDocuments(rawDocuments);
    
    return EmployeeOnboardFormResult(
      fullName: json['fullName']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      dob: json['dob'] != null ? DateTime.parse(json['dob'].toString()) : DateTime.now(),
      bloodGroup: json['bloodGroup']?.toString() ?? '',
      maritalStatus: json['maritalStatus']?.toString() ?? '',
      personalEmail: json['personalEmail']?.toString() ?? '',
      mobileCountryCode: json['mobileCountryCode']?.toString() ?? '',
      mobileNumber: json['mobileNumber']?.toString() ?? '',
      permanentAddress: json['permanentAddress']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      companyName: json['companyName']?.toString() ?? '',
      branchLocation: json['branchLocation']?.toString() ?? '',
      employeeId: json['employeeId']?.toString() ?? '',
      doj: json['doj'] != null ? DateTime.parse(json['doj'].toString()) : DateTime.now(),
      department: json['department']?.toString() ?? '',
      designation: json['designation']?.toString() ?? '',
      workMode: json['workMode']?.toString() ?? '',
      shiftTiming: json['shiftTiming']?.toString() ?? '',
      workDays: (json['workDays'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      officialEmail: json['officialEmail']?.toString() ?? '',
      bankName: json['bankName']?.toString() ?? '',
      accountHolderName: json['accountHolderName']?.toString() ?? '',
      accountNumber: json['accountNumber']?.toString() ?? '',
      ifscCode: json['ifscCode']?.toString() ?? '',
      bankBranch: json['bankBranch']?.toString() ?? '',
      upiId: json['upiId']?.toString() ?? '',
      panNumber: json['panNumber']?.toString() ?? '',
      aadhaarNumber: json['aadhaarNumber']?.toString() ?? '',
      basicPay: (json['basicPay'] is int) ? json['basicPay'] : int.tryParse(json['basicPay']?.toString() ?? '0') ?? 0,
      hra: (json['hra'] is int) ? json['hra'] : int.tryParse(json['hra']?.toString() ?? '0') ?? 0,
      bonus: (json['bonus'] is int) ? json['bonus'] : int.tryParse(json['bonus']?.toString() ?? '0') ?? 0,
      allowancesTotal: (json['allowancesTotal'] is int) ? json['allowancesTotal'] : int.tryParse(json['allowancesTotal']?.toString() ?? '0') ?? 0,
      deductionsAmount: (json['deductionsAmount'] is int) ? json['deductionsAmount'] : int.tryParse(json['deductionsAmount']?.toString() ?? '0') ?? 0,
      professionalTax: (json['professionalTax'] is int) ? json['professionalTax'] : int.tryParse(json['professionalTax']?.toString() ?? '0') ?? 0,
      pfNumber: json['pfNumber']?.toString() ?? '',
      esiNumber: json['esiNumber']?.toString() ?? '',
      grossSalary: (json['grossSalary'] is int) ? json['grossSalary'] : int.tryParse(json['grossSalary']?.toString() ?? '0') ?? 0,
      netSalary: (json['netSalary'] is int) ? json['netSalary'] : int.tryParse(json['netSalary']?.toString() ?? '0') ?? 0,
      documents: normalizedDocuments,
    );
  }

  /// Converts EmployeeOnboardFormResult to JSON
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'gender': gender,
      'dob': dob.toIso8601String(),
      'bloodGroup': bloodGroup,
      'maritalStatus': maritalStatus,
      'personalEmail': personalEmail,
      'mobileCountryCode': mobileCountryCode,
      'mobileNumber': mobileNumber,
      'permanentAddress': permanentAddress,
      'city': city,
      'state': state,
      'pincode': pincode,
      'companyName': companyName,
      'branchLocation': branchLocation,
      'employeeId': employeeId,
      'doj': doj.toIso8601String(),
      'department': department,
      'designation': designation,
      'workMode': workMode,
      'shiftTiming': shiftTiming,
      'workDays': workDays,
      'officialEmail': officialEmail,
      'bankName': bankName,
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'bankBranch': bankBranch,
      'upiId': upiId,
      'panNumber': panNumber,
      'aadhaarNumber': aadhaarNumber,
      'basicPay': basicPay,
      'hra': hra,
      'bonus': bonus,
      'allowancesTotal': allowancesTotal,
      'deductionsAmount': deductionsAmount,
      'professionalTax': professionalTax,
      'pfNumber': pfNumber,
      'esiNumber': esiNumber,
      'grossSalary': grossSalary,
      'netSalary': netSalary,
      'documents': documents,
    };
  }

}

