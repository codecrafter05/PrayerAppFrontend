# اختبار API يدوياً

## 1. اختبار من Terminal

```bash
# اختبار أوقات الصلاة
curl http://127.0.0.1:8000/api/prayer-times/today/

# اختبار حديث عشوائي
curl http://127.0.0.1:8000/api/hadith/random/

# اختبار مناسبات اليوم
curl http://127.0.0.1:8000/api/occasions/today/

# اختبار صورة عشوائية
curl http://127.0.0.1:8000/api/occasion-images/random/
```

## 2. اختبار من المتصفح

افتح هذه الروابط في المتصفح:
- http://127.0.0.1:8000/api/prayer-times/today/
- http://127.0.0.1:8000/api/hadith/random/
- http://127.0.0.1:8000/api/occasions/today/
- http://127.0.0.1:8000/api/occasion-images/random/

## 3. فحص Console Logs في Flutter

عند تشغيل التطبيق، ابحث عن هذه الرسائل في الـ console:

```
🔵 Fetching prayer times from: http://127.0.0.1:8000/api/prayer-times/today/
🔵 Response status: 200
✅ Parsed JSON successfully
✅ Prayer time created successfully: 2026-01-06
```

إذا رأيت:
- `❌ Timeout` = مشكلة في الاتصال
- `❌ HTTP Error` = مشكلة في الـ API
- `❌ JSON parsing error` = مشكلة في البيانات

## 4. المشاكل الشائعة

### المشكلة: Timeout
**الحل:** تأكد من أن Django server يعمل:
```bash
cd backend
source venv/bin/activate
python manage.py runserver 0.0.0.0:8000
```

### المشكلة: Connection refused
**الحل:** إذا كان التطبيق على جهاز مختلف، غيّر `baseUrl` في `api_service.dart`

### المشكلة: CORS error (في Web)
**الحل:** أضف CORS headers في Django (راجع TROUBLESHOOTING.md)

