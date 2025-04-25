import 'package:get_storage/get_storage.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/model/user_model.dart';

class PreferenceManagerUtils {
  static final getStorage = GetStorage();

  static String isLogin = "isLogin";
  static String isSetValue = "isSetValue";
  static String isSetData = "isSetData";
  static String loginAdmin = "loginAdmin";
  static String familyCode = 'familyCode';

  ///IsLogin
  static Future setIsLogin(bool value) async {
    await getStorage.write(isLogin, value);
  }

  static bool getIsLogin() {
    return getStorage.read(isLogin) ?? false;
  }

  /// setIndex
  static Future setIndex(int index) async {
    await getStorage.write(isSetValue, index);
  }

  static int getIndex() {
    return getStorage.read(isSetValue) ?? 0;
  }

  /// setData
  static Future setData(List data) async {
    await getStorage.write(isSetData, data);
  }

  static List<StudentModel> getData() {
    return getStorage.read(isSetData) ?? [];
  }

  /// set login admin email
  static Future setLoginAdmin(String data) async {
    await getStorage.write(loginAdmin, data);
  }

  static String getLoginAdmin() {
    return getStorage.read(loginAdmin) ?? '';
  }


  static Future setFamilyCode(String value) async {
    await getStorage.write(familyCode, value);
  }
  static String getFamilyCode() {
    return getStorage.read(familyCode) ?? "";
  }
  /// clear prefrences
  static Future<void> clearPreference() async {
    await getStorage.erase();
  }
}
