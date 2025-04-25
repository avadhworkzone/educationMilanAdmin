class StudentModel {
  String? userId;
  String? studentFullName;
  String? villageName;
  String? standard;
  num? percentage;
  String? result;
  String? studentId;
  String? fcmToken;
  String? createdDate;
  String? mobileNumber;
  bool? isApproved;
  String? imageId;
  String? reason;
  String? status;

  // ✅ New fields based on your Firestore data
  String? familyCode;

  StudentModel({
    this.userId,
    this.studentFullName,
    this.villageName,
    this.standard,
    this.result,
    this.percentage,
    this.studentId,
    this.fcmToken,
    this.createdDate,
    this.mobileNumber,
    this.isApproved,
    this.imageId,
    this.reason,
    this.status,
    this.familyCode,
  });

  StudentModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    studentFullName = json['studentFullName'];
    villageName = json['villageName'];
    standard = json['standard'];
    result = json['result'];
    percentage = json['percentage'];
    studentId = json['studentId'];
    fcmToken = json['fcmToken'];
    createdDate = json['createdDate'];
    isApproved = json['isApproved'];
    mobileNumber = json['mobileNumber'] ?? "";
    imageId = json['imageId'];
    reason = json['reason'];
    status = json['status'];
    familyCode = json['familyCode'];
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "studentFullName": studentFullName,
    "villageName": villageName,
    "standard": standard,
    "result": result,
    "percentage": percentage,
    "studentId": studentId,
    "fcmToken": fcmToken,
    "createdDate": createdDate,
    "isApproved": isApproved,
    "mobileNumber": mobileNumber,
    "imageId": imageId,
    "reason": reason,
    "status": status,
    "familyCode": familyCode,
  };

  Map<String, dynamic> updateToJson() => {"studentFullName": studentFullName};
}
