import 'package:responsivedashboard/utils/collection_utils.dart';

class AuthService {
  // static Future<LoginStatus> signUp(
  //     Map<String, dynamic> user, String phoneNo) async {
  //   try {
  //     await CollectionUtils.adminCollection.doc(phoneNo).set(user);
  //     return LoginStatus.Success;
  //   } catch (e) {
  //     print('SIGN UP ERROR :=>$e');
  //     return LoginStatus.OtherError;
  //   }
  // }

  static Future<bool> signIn(
      {required String docId, required String pin}) async {
    try {
      var value = await CollectionUtils.adminCollection.doc(docId).get();
      if (value.data()?['Password'].toString() == pin.toString()) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('CHECK USER EXIST ERROR:=>$e');
      return false;
    }
  }
}

enum LoginStatus {
  Success,
  InvalidCredentials,
  OtherError,
}
