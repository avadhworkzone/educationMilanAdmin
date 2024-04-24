class StudentModel {
  String? userId;
  String? studentFullName;
  String? statusBy;
  String? villageName;
  String? standard;
  num? percentage;
  String? result;
  String? studentId;
  String? fcmToken;
  String? createdDate;
  String? checkUncheck;
  String? mobileNumber;
  bool? isApproved;

  StudentModel(
      {this.userId,
      this.studentFullName,
      this.statusBy,
      this.villageName,
      this.standard,
      this.result,
      this.percentage,
      this.studentId,
      this.fcmToken,
      this.createdDate,
      this.checkUncheck,
      this.mobileNumber,
      this.isApproved});

  StudentModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    studentFullName = json['studentFullName'];
    statusBy = json['statusBy'];
    villageName = json['villageName'];
    standard = json['standard'];
    result = json['result'];
    percentage = json['percentage'];
    studentId = json['studentId'];
    fcmToken = json['fcmToken'];
    createdDate = json['createdDate'];
    checkUncheck = json['checkUncheck'];
    isApproved = json['isApproved'];
    mobileNumber = json['mobileNumber'] ?? "";
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "studentFullName": studentFullName,
        "statusBy": statusBy,
        "villageName": villageName,
        "standard": standard,
        "result": result,
        "percentage": percentage,
        "studentId": studentId,
        "fcmToken": fcmToken,
        "createdDate": createdDate,
        "checkUncheck": checkUncheck,
        "isApproved": isApproved,
        "mobileNumber": mobileNumber,
      };

  Map<String, dynamic> updateToJson() => {"studentFullName": studentFullName};
}
