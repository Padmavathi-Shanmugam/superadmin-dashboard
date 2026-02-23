// import 'dart:typed_data';

// import 'package:flutter/foundation.dart' show kIsWeb;



// class AllowanceItem {

//   final String name;

//   final int amount;

//   AllowanceItem({required this.name, required this.amount});

// }



// class UploadedDoc {

//   final String key;a

//   final String label;

//   final bool requiredDoc;



//   String? fileName;

//   String? path;

//   Uint8List? bytes;

//   String? ext;



//   UploadedDoc({

//     required this.key,

//     required this.label,

//     required this.requiredDoc,

//     this.fileName,

//     this.path,

//     this.bytes,

//     this.ext,

//   });



//   bool get hasFile {

//     if (kIsWeb) return bytes != null && bytes!.isNotEmpty;

//     return path != null && path!.isNotEmpty;

//   }

// }



// class EmployeeOnboardFormResult {

//   final String fullName;

//   final String gender;

//   final DateTime dob;

//   final String bloodGroup;

//   final String maritalStatus;

//   final String personalEmail;



//   final String mobileCountryCode;

//   final String mobileNumber;



//   final String permanentAddress;

//   final String city;

//   final String state;

//   final String pincode;



//   final String companyName;

//   final String branchLocation;

//   final String employeeId;

//   final DateTime dateOfJoining;



//   final String department;

//   final String designation;



//   final String experienceType;

//   final String? experienceYears;



//   final String workMode;

//   final String shiftTiming;

//   final List<String> workDays;



//   final String officialEmail;



//   final String bankName;

//   final String accountHolderName;

//   final String accountNumber;

//   final String ifscCode;

//   final String bankBranch;

//   final String? upiId;



//   final String panNumber;

//   final String aadhaarNumber;



//   final int basicPay;

//   final int hra;

//   final List<AllowanceItem> allowances;

//   final int bonus;

//   final int deductions;



//   final int professionalTax;



//   final String? pfNumber;

//   final String? esiNumber;



//   final int grossSalary;

//   final int netSalary;



//   final Map<String, UploadedDoc> documents;



//   EmployeeOnboardFormResult({

//     required this.fullName,

//     required this.gender,

//     required this.dob,

//     required this.bloodGroup,

//     required this.maritalStatus,

//     required this.personalEmail,

//     required this.mobileCountryCode,

//     required this.mobileNumber,

//     required this.permanentAddress,

//     required this.city,

//     required this.state,

//     required this.pincode,

//     required this.companyName,

//     required this.branchLocation,

//     required this.employeeId,

//     required this.dateOfJoining,

//     required this.department,

//     required this.designation,

//     required this.experienceType,

//     required this.experienceYears,

//     required this.workMode,

//     required this.shiftTiming,

//     required this.workDays,

//     required this.officialEmail,

//     required this.bankName,

//     required this.accountHolderName,

//     required this.accountNumber,

//     required this.ifscCode,

//     required this.bankBranch,

//     required this.upiId,

//     required this.panNumber,

//     required this.aadhaarNumber,

//     required this.basicPay,

//     required this.hra,

//     required this.allowances,

//     required this.bonus,

//     required this.deductions,

//     required this.professionalTax,

//     required this.pfNumber,

//     required this.esiNumber,

//     required this.grossSalary,

//     required this.netSalary,

//     required this.documents,

//   });

// }



import 'dart:typed_data';



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

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "gender": gender,
        "dob": dob.toIso8601String(),
        "bloodGroup": bloodGroup,
        "maritalStatus": maritalStatus,
        "personalEmail": personalEmail,
        "mobileCountryCode": mobileCountryCode,
        "mobileNumber": mobileNumber,
        "permanentAddress": permanentAddress,
        "city": city,
        "state": state,
        "pincode": pincode,
        "companyName": companyName,
        "branchLocation": branchLocation,
        "employeeId": employeeId,
        "doj": doj.toIso8601String(),
        "department": department,
        "designation": designation,
        "workMode": workMode,
        "shiftTiming": shiftTiming,
        "workDays": workDays,
        "officialEmail": officialEmail,
        "bankName": bankName,
        "accountHolderName": accountHolderName,
        "accountNumber": accountNumber,
        "ifscCode": ifscCode,
        "bankBranch": bankBranch,
        "upiId": upiId,
        "panNumber": panNumber,
        "aadhaarNumber": aadhaarNumber,
        "basicPay": basicPay,
        "hra": hra,
        "bonus": bonus,
        "allowancesTotal": allowancesTotal,
        "deductionsAmount": deductionsAmount,
        "professionalTax": professionalTax,
        "pfNumber": pfNumber,
        "esiNumber": esiNumber,
        "grossSalary": grossSalary,
        "netSalary": netSalary,
        "documents": documents,
      };

}

