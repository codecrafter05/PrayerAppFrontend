# إصلاح مشكلة الاتصال

## المشكلة: `Operation not permitted`

هذه المشكلة تحدث عندما لا يستطيع التطبيق الاتصال بالـ API.

## الحلول المطبقة:

### 1. ✅ إضافة Internet Permission للـ Android
تم إضافة `<uses-permission android:name="android.permission.INTERNET" />` في `AndroidManifest.xml`

### 2. ✅ إصلاح Platform Helper
- **Android Emulator**: يستخدم `10.0.2.2:8000` (IP خاص للـ emulator)
- **iOS Simulator**: يستخدم `localhost:8000`
- **Web**: يستخدم `localhost:8000`
- **Desktop**: يستخدم `localhost:8000`

### 3. ✅ تأكد من أن Django Server يعمل
```bash
cd backend
./start_server.sh
# أو
python manage.py runserver 0.0.0.0:8000
```

## الخطوات التالية:

1. **أعد بناء التطبيق** (بعد إضافة permissions):
   ```bash
   cd app
   flutter clean
   flutter pub get
   flutter run
   ```

2. **إذا كان Android Emulator**:
   - تأكد من أن `baseUrl` هو `http://10.0.2.2:8000`
   - هذا IP خاص بالـ Android Emulator

3. **إذا كان iOS Simulator**:
   - `localhost` يجب أن يعمل مباشرة
   - إذا لم يعمل، جرب `127.0.0.1`

4. **إذا كان Android Device/TV**:
   - استخدم IP الكمبيوتر (مثل: `192.168.100.106:8000`)
   - غيّر في `platform_helper.dart` السطر 12

## اختبار:

بعد إعادة البناء، يجب أن ترى في الـ logs:
```
✅ [API] Prayer time created successfully!
✅ [Provider] Data loaded: PrayerTime: 2026-01-06
```

