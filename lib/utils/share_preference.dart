import 'package:get_storage/get_storage.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/model/user_model.dart';

class PreferenceManagerUtils {
  static final getStorage = GetStorage();

  static String isLogin = "isLogin";
  static String isSetValue = "isSetValue";
  static String isSetData = "isSetData";

  ///IsLogin
  static Future setIsLogin(bool value) async {
    await getStorage.write(isLogin, value);
  }

  static Future setIndex(int index) async {
    await getStorage.write(isSetValue, index);
  }

  static Future setData(List data) async {
     await getStorage.write(isSetData,data);
  }
  static bool getIsLogin() {
    return getStorage.read(isLogin) ?? false;
  }
  static int getIndex(){
    return getStorage.read(isSetValue) ?? 0;
  }
  static List<StudentModel> getData(){
    return getStorage.read(isSetData) ?? [];
  }
  static Future<void> clearPreference() async {
    await getStorage.erase();
  }
}
