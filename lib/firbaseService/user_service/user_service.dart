import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/model/user_model.dart';
import 'package:responsivedashboard/utils/collection_utils.dart';

class UserService {
  ///=======================get data===================///
  static Stream<List<UserResModel>> getUserData() {
    return CollectionUtils.userDetails.snapshots().map((event) =>
        event.docs.map((e) => UserResModel.fromJson(e.data())).toList());
  }

  ///=======================delete data===================///
  static Future<bool> deleteUser(String userId) async {
    try {
      await CollectionUtils.userDetails.doc(userId).delete();
      return true;
    } catch (e) {
      print('DELETE ERROR :=> $e');
      return false;
    }
  }

  ///=======================update data===================///
  static Future<bool> userDetailsEdit(
      String userId, UserResModel userResModel) async {
    return CollectionUtils.userDetails
        .doc(userId)
        .update(userResModel.toJson())
        .then((value) => true)
        .catchError((e) {
      print('APPOINTMENT UPDATE ERROR :=>$e');
      return false;
    });
  }
}
