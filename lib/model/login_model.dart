class AdminModel {
  String? email;
  String? userPin;

  AdminModel({
    this.email,
    this.userPin,
  });

  AdminModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    userPin = json['userPin'];
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "userPin": userPin,
      };

  Map<String, dynamic> updateToJson() => {
        "email": email,
      };
}
