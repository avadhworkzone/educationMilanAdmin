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

  static Future<bool> signIn({
    required String docId, // this is familyCode
    required String pin,   // this is password
  }) async {
    try {
      final doc = await CollectionUtils.families.doc(docId).get();

      if (doc.exists) {
        final data = doc.data();
        final storedPassword = data?['password'];

        // ✅ Check if password matches
        if (storedPassword == pin) {
          return true;
        }
      }

      return false;
    } catch (e) {
      print('SIGN IN ERROR => $e');
      return false;
    }
  }
}

enum LoginStatus {
  Success,
  InvalidCredentials,
  OtherError,
}
