import 'package:connectivity_plus/connectivity_plus.dart';

/// خدمة التحقق من وجود اتصال بالإنترنت
/// نستخدمها لمعرفة هل نجلب البيانات من السيرفر أم نعتمد على الكاش المحلي
class ConnectivityService {
  /// التحقق من وجود إنترنت (ويفي أو بيانات جوال)
  /// ملاحظة: connectivity_plus يتحقق من وجود شبكة فقط،
  /// لكن في أغلب الحالات إذا في شبكة بيكون في إنترنت
  static Future<bool> get hasInternet async {
    try {
      final result = await Connectivity().checkConnectivity();
      // عند عدم وجود اتصال يرجع [none] أو قائمة فارغة
      final hasConnection = result.isNotEmpty &&
          result.any((r) => r != ConnectivityResult.none);
      return hasConnection;
    } catch (e) {
      return false;
    }
  }
}
