class Theme {
  final int id;
  final String name;
  final String primaryBackgroundColor; // اللون الرئيسي (الخلفية الرئيسية)
  final String secondaryBackgroundColor; // اللون الثانوي (للـ cards)
  final bool isDefault;
  final bool isActive;
  final String updatedAt;

  Theme({
    required this.id,
    required this.name,
    required this.primaryBackgroundColor,
    required this.secondaryBackgroundColor,
    required this.isDefault,
    required this.isActive,
    required this.updatedAt,
  });

  // الألوان الافتراضية (الأخضر الإسلامي)
  static const String defaultPrimaryColor = '#1a472a'; // الأخضر الفاتح
  static const String defaultSecondaryColor = '#0d2818'; // الأخضر الغامق

  factory Theme.fromJson(Map<String, dynamic> json) {
    return Theme(
      id: json['id'] as int,
      name: json['name'] as String,
      primaryBackgroundColor: json['primary_background_color'] as String,
      secondaryBackgroundColor: json['secondary_background_color'] as String,
      isDefault: json['is_default'] as bool,
      isActive: json['is_active'] as bool,
      updatedAt: json['updated_at'] as String,
    );
  }

  // تحويل Hex color string إلى Color object
  static int hexToInt(String hexString) {
    final hexCode = hexString.replaceAll('#', '');
    return int.parse('FF$hexCode', radix: 16); // FF للألفا (opacity)
  }

  // الحصول على اللون الرئيسي كـ int
  int get primaryColorInt {
    return hexToInt(primaryBackgroundColor);
  }

  // الحصول على اللون الثانوي كـ int
  int get secondaryColorInt {
    return hexToInt(secondaryBackgroundColor);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'primary_background_color': primaryBackgroundColor,
      'secondary_background_color': secondaryBackgroundColor,
      'is_default': isDefault,
      'is_active': isActive,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() {
    return 'Theme(id: $id, name: $name, primary: $primaryBackgroundColor, secondary: $secondaryBackgroundColor, isDefault: $isDefault)';
  }
}
