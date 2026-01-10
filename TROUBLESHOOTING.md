# حل المشاكل - Troubleshooting

## المشكلة: "لا توجد بيانات أوقات الصلاة"

### الحل 1: تحديث عنوان الـ API

إذا كان التطبيق يعمل على جهاز مختلف عن الكمبيوتر (مثل Android TV)، يجب تحديث عنوان الـ API:

1. افتح `lib/services/api_service.dart`
2. غيّر `baseUrl` من `http://127.0.0.1:8000` إلى IP address الفعلي:

```dart
// مثال: إذا كان IP الكمبيوتر هو 192.168.1.100
static const String baseUrl = 'http://192.168.1.100:8000';
```

**كيفية معرفة IP address:**
- على Mac/Linux: `ifconfig | grep "inet "`
- على Windows: `ipconfig`

### الحل 2: التأكد من أن Django Server يعمل

```bash
cd backend
source venv/bin/activate
python manage.py runserver 0.0.0.0:8000
```

**ملاحظة:** استخدم `0.0.0.0` بدلاً من `127.0.0.1` للسماح بالاتصال من أجهزة أخرى.

### الحل 3: التأكد من وجود بيانات اليوم

تأكد من وجود أوقات صلاة للتاريخ اليوم في قاعدة البيانات:

```bash
# في Django admin
http://127.0.0.1:8000/admin/core/prayertime/
```

أو استخدم API مباشرة:
```bash
curl http://127.0.0.1:8000/api/prayer-times/today/
```

### الحل 4: فحص Logs

عند تشغيل التطبيق، افحص الـ console logs لرؤية:
- عنوان URL الذي يحاول التطبيق الاتصال به
- حالة الـ response
- أي أخطاء في الاتصال

### الحل 5: CORS (إذا كان التطبيق يعمل على Web)

إذا كان التطبيق يعمل على Web، قد تحتاج إلى إضافة CORS headers في Django:

1. تثبيت `django-cors-headers`:
```bash
pip install django-cors-headers
```

2. إضافة إلى `settings.py`:
```python
INSTALLED_APPS = [
    ...
    'corsheaders',
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    ...
]

CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
]
```

## اختبار الاتصال

1. **اختبار من المتصفح:**
   افتح `http://YOUR_IP:8000/api/prayer-times/today/` في المتصفح

2. **اختبار من Terminal:**
   ```bash
   curl http://YOUR_IP:8000/api/prayer-times/today/
   ```

3. **اختبار من التطبيق:**
   - شغّل التطبيق
   - افحص الـ console logs
   - يجب أن ترى رسائل مثل:
     ```
     Fetching prayer times from: http://...
     Response status: 200
     Response body: {...}
     ```

## نصائح إضافية

- تأكد من أن الكمبيوتر والجهاز (Android TV) على نفس الشبكة WiFi
- تأكد من أن Firewall لا يمنع الاتصال على port 8000
- جرب إعادة تشغيل Django server بعد تغيير الإعدادات

