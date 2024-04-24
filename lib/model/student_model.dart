class StudentModel {
  String? userId;
  String? studentFullName;
  String? villageName;
  String? standard;
  num? percentage;
  String? result;
  String? studentId;
  String? createdDate;
  String? checkUncheck;
  String? mobileNumber;
  bool? isApproved;

  StudentModel(
      {this.userId,
      this.studentFullName,
      this.villageName,
      this.standard,
      this.result,
      this.percentage,
      this.studentId,
      this.createdDate,
      this.checkUncheck,
      this.mobileNumber,
      this.isApproved});

  StudentModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    studentFullName = json['studentFullName'];
    villageName = json['villageName'];
    standard = json['standard'];
    result = json['result'];
    percentage = json['percentage'];
    studentId = json['studentId'];
    createdDate = json['createdDate'];
    checkUncheck = json['checkUncheck'];
    isApproved = json['isApproved'];
    mobileNumber = json['mobileNumber'] ?? "";
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "studentFullName": studentFullName,
        "villageName": villageName,
        "standard": standard,
        "result": result,
        "percentage": percentage,
        "studentId": studentId,
        "createdDate": createdDate,
        "checkUncheck": checkUncheck,
        "isApproved": isApproved,
        "mobileNumber": mobileNumber,
      };

  Map<String, dynamic> updateToJson() => {"studentFullName": studentFullName};
}
