import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
Future<Map<String, dynamic>> fetchPrayerTimes() async {
  final String apiUrl = 'https://api.aladhan.com/v1/timingsByCity?city=Cairo&country=Egypt&method=2';

  final res = await http.get(Uri.parse(apiUrl));

  if (res.statusCode != 200) {
    throw Exception("HTTP ${res.statusCode}: ${res.reasonPhrase}");
  }


  dynamic raw;
  try {
    raw = jsonDecode(res.body);
  } on FormatException catch (e) {
    throw Exception("JSON parse error: ${e.message}\nBody was: ${res.body}");
  }


  if (raw == null) {
    throw Exception("Decoded JSON was null! Body: ${res.body}");
  }


  if (raw is! Map<String, dynamic>) {
    throw Exception(
        "Expected JSON object, but got ${raw.runtimeType}:\n$raw"
    );
  }

  final jsonResponse = jsonDecode(res.body) as Map<String, dynamic>;
  final data = jsonResponse['data'] as Map<String, dynamic>;
  return data;
}
String formatTime(String time) {
  final parts = time.split(':');
  if(parts.length!=2){
    throw FormatException("Invalid time format: $time");
  }
  var hour = int.parse(parts[0]);
  final minute = parts[1].padLeft(2,'0');
  final period = hour >= 12 ? 'PM' : 'AM';
  hour = hour % 12;
  if(hour==0) {
    hour = 12;
  }
  return '$hour:$minute $period';
}
/// Returns the prayer name (“Fajr”, “Dhuhr”, etc.) whose time window contains `now`.
String getCurrentPrayer(Map<String, String> timings) {
  final now = DateTime.now();

  // The canonical prayer order:
  final names = ['Fajr','Dhuhr','Asr','Maghrib','Isha'];

  // Build today’s DateTimes:
  final entries = names.map((name) {
    final hhmm = timings[name]!;
    final parts = hhmm.split(':');
    final hour = int.parse(parts[0]), min = int.parse(parts[1]);
    return MapEntry(name, DateTime(now.year, now.month, now.day, hour, min));
  }).toList();

  // Sort ascending:
  entries.sort((a, b) => a.value.compareTo(b.value));

  // Find which interval [start…next) contains now:
  for (var i = 0; i < entries.length; i++) {
    final start = entries[i].value;
    var next  = entries[(i+1)%entries.length].value;
    if (!next.isAfter(start)) next = next.add(const Duration(days: 1));
    if ((now.isAtSameMomentAs(start) || now.isAfter(start))
        && now.isBefore(next)) {
      return entries[i].key;
    }
  }

  // Fallback
  return entries.last.key;
}
IconData iconForPrayer(String prayer) {
  switch (prayer.toLowerCase()) {
    case 'fajr':
      return Icons.brightness_3;        // a crescent‐moon icon
    case 'dhuhr':
      return Icons.wb_sunny;            // full sun for midday
    case 'asr':
      return Icons.wb_sunny_outlined;   // sun outline for late afternoon
    case 'maghrib':
      return Icons.nights_stay;         // a night‐sky icon for sunset
    case 'isha':
      return Icons.nightlight_outlined;         // same or pick another night icon
    default:
      return Icons.wb_sunny;
  }
}


