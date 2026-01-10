# مسجد الديه - تطبيق شاشة التلفاز

تطبيق Flutter لعرض معلومات إسلامية على شاشات التلفاز في المساجد.

## الميزات

- ✅ عرض اليوم + التاريخ الميلادي + التاريخ الهجري + اسم المسجد
- ✅ عرض صورة المناسبة (إذا كانت هناك مناسبة اليوم)
- ✅ عرض أوقات الصلاة (الفجر، الشروق، الظهر، المغرب)
- ✅ عداد تنازلي للصلاة التالية
- ✅ شريط أخباري متحرك يعرض الأحاديث والآيات
- ✅ تحديث تلقائي للبيانات كل 5 دقائق
- ✅ تصميم مناسب لشاشات التلفاز (بدون scroll)

## المتطلبات

- Flutter SDK 3.6.1 أو أحدث
- Backend Django يعمل على `http://127.0.0.1:8000`

## التثبيت

1. تأكد من تثبيت Flutter:
```bash
flutter --version
```

2. تثبيت الحزم:
```bash
cd app
flutter pub get
```

3. تحديث عنوان الـ API (إذا لزم الأمر):
افتح `lib/services/api_service.dart` وعدّل `baseUrl`:
```dart
static const String baseUrl = 'http://YOUR_BACKEND_URL:8000';
```

## التشغيل

```bash
flutter run
```

للأجهزة التلفاز (Android TV):
```bash
flutter run -d <device_id>
```

## هيكل المشروع

```
lib/
├── main.dart                 # نقطة الدخول
├── models/                   # نماذج البيانات
│   ├── prayer_time.dart
│   ├── hadith.dart
│   ├── occasion.dart
│   └── occasion_image.dart
├── services/                 # خدمات API
│   └── api_service.dart
├── providers/               # إدارة الحالة
│   └── app_provider.dart
├── screens/                  # الشاشات
│   └── home_screen.dart
├── widgets/                  # المكونات
│   ├── header_widget.dart
│   ├── occasion_image_widget.dart
│   ├── prayer_times_widget.dart
│   └── news_ticker_widget.dart
└── utils/                    # أدوات مساعدة
    └── prayer_utils.dart
```

## API Endpoints المستخدمة

- `GET /api/prayer-times/today/` - أوقات الصلاة اليوم
- `GET /api/hadith/random/` - حديث/آية عشوائية
- `GET /api/occasions/today/` - مناسبات اليوم
- `GET /api/occasion-images/random/` - صورة مناسبة عشوائية

## ملاحظات

- التطبيق مصمم ليعمل في وضع ملء الشاشة (Fullscreen)
- البيانات تتحدث تلقائياً كل 5 دقائق
- الشريط الأخباري يتحدث كل دقيقتين
- العداد التنازلي يتحدث كل ثانية

## الألوان المستخدمة

- الأخضر الإسلامي: `#1a472a`
- الأخضر الداكن: `#0d2818`
- الذهبي: `#d4af37`
- الأبيض: `#ffffff`

## التطوير

لإضافة ميزات جديدة أو تعديل التصميم:

1. **تعديل التصميم**: عدّل الملفات في `lib/widgets/`
2. **إضافة API جديد**: أضف الدالة في `lib/services/api_service.dart`
3. **تعديل البيانات**: عدّل الـ Models في `lib/models/`

## الدعم

للمساعدة أو الإبلاغ عن مشاكل، يرجى التواصل مع فريق التطوير.
