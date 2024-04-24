class UserResModel {
  var phoneNo;
  var pin;

  UserResModel({this.phoneNo, this.pin});

  UserResModel.fromJson(Map<String, dynamic> json) {
    phoneNo = json['PhoneNo'];
    pin = json['Pin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PhoneNo'] = phoneNo;
    data['Pin'] = pin;
    return data;
  }
}
