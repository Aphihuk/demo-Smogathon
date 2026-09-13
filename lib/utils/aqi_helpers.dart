import 'package:flutter/material.dart';

Color getAqiColor(int aqi) {
  if (aqi <= 50) return Colors.green;
  if (aqi <= 100) return Colors.yellow.shade700;
  if (aqi <= 150) return Colors.orange;
  if (aqi <= 200) return Colors.red;
  if (aqi <= 300) return Colors.purple;
  return const Color(0xFF800000); // Maroon
}

Color getAqiBackgroundColor(int aqi) {
  if (aqi <= 50) return Colors.green.shade100;
  if (aqi <= 100) return Colors.yellow.shade100;
  if (aqi <= 150) return Colors.orange.shade100;
  if (aqi <= 200) return Colors.red.shade100;
  if (aqi <= 300) return Colors.purple.shade100;
  return const Color(0xFFF5E6E6); // Light Maroon
}

List<Color> getAqiGradient(int aqi) {
  if (aqi <= 50) {
    return [const Color(0xFF4A90E2), const Color(0xFF003D73)]; // Good: Sky Blue to Dark Blue
  }
  if (aqi <= 100) {
    return [const Color(0xFFD4AC0D), const Color(0xFF7D6608)]; // Moderate: Dark Yellow
  }
  if (aqi <= 150) {
    return [const Color(0xFFE67E22), const Color(0xFF935116)]; // Sensitive: Orange
  }
  if (aqi <= 200) {
    return [const Color(0xFFE74C3C), const Color(0xFF78281F)]; // Unhealthy: Red
  }
  if (aqi <= 300) {
    return [const Color(0xFF8E44AD), const Color(0xFF4A235A)]; // Very Unhealthy: Purple
  }
  return [const Color(0xFF641E16), const Color(0xFF1B0000)]; // Hazardous: Maroon
}

String getEmoji(String category) {
  final lower = category.toLowerCase();
  if (lower.contains('good')) return '😊';
  if (lower.contains('moderate')) return '😐';
  if (lower.contains('unhealthy for sensitive')) return '😷';
  if (lower.contains('unhealthy') && !lower.contains('very')) return '🤢';
  if (lower.contains('very unhealthy')) return '🤮';
  if (lower.contains('hazardous')) return '☠️';
  return '☁️';
}

String getHealthAdvice(String category) {
  final lower = category.toLowerCase();
  if (lower.contains('good')) {
    return 'อากาศดีมาก เหมาะสำหรับการทำกิจกรรมกลางแจ้ง';
  }
  if (lower.contains('moderate')) {
    return 'คุณภาพอากาศปานกลาง สามารถทำกิจกรรมกลางแจ้งได้';
  }
  if (lower.contains('unhealthy for sensitive')) {
    return 'กลุ่มเสี่ยงควรลดการทำกิจกรรมกลางแจ้งที่ใช้แรงมาก';
  }
  if (lower.contains('unhealthy') && !lower.contains('very')) {
    return 'ควรหลีกเลี่ยงกิจกรรมกลางแจ้ง สวมหน้ากากอนามัย';
  }
  if (lower.contains('very unhealthy')) {
    return 'หลีกเลี่ยงกิจกรรมกลางแจ้งทุกชนิด สวมหน้ากาก N95';
  }
  if (lower.contains('hazardous')) {
    return 'อันตราย! งดออกนอกอาคาร และใช้เครื่องฟอกอากาศ';
  }
  return 'ไม่มีข้อมูลคำแนะนำสุขภาพ';
}
