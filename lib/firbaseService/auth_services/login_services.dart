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

  static Future<String> signIn({
    required String docId, // familyCode
    required String pin,   // password
  }) async {
    try {
      final doc = await CollectionUtils.families.doc(docId).get();

      if (doc.exists) {
        final data = doc.data();
        final storedPassword = data?['password'];
        final isActive = data?['isActive'] ?? true; // if missing, assume active

        if (isActive == false) {
          return 'expired';
        }

        if (storedPassword == pin) {
          return 'success';
        } else {
          return 'invalid';
        }
      }

      return 'invalid';
    } catch (e) {
      print('SIGN IN ERROR => $e');
      return 'error';
    }
  }

}

enum LoginStatus {
  Success,
  InvalidCredentials,
  OtherError,
}
