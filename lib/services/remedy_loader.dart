import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/remedy.dart';

class RemedyLoader {
  static Future<List<RemedyItem>> loadFromAssets(String path) async {
    final String jsonStr = await rootBundle.loadString(path);
    final dynamic parsed = json.decode(jsonStr);
    if (parsed is List) {
      return parsed.map((e) => RemedyItem.fromJson(e as Map<String, dynamic>)).toList();
    } else if (parsed is Map && parsed['items'] is List) {
      final List items = parsed['items'] as List;
      return items.map((e) => RemedyItem.fromJson(e as Map<String, dynamic>)).toList();
    } else if (parsed is Map<String, dynamic>) {
      // Support dictionary format: { "headache": { displayName:{en:..}, remedies:[{herb:{en:..}, description:{en:..}}] }, ... }
      final List<RemedyItem> result = [];
      for (final entry in parsed.entries) {
        final Map<String, dynamic>? value = entry.value is Map<String, dynamic> ? entry.value as Map<String, dynamic> : null;
        if (value == null) continue;
        String title = '';
        String? titleHi;
        if (value['displayName'] is Map && (value['displayName'] as Map)['en'] != null) {
          title = (value['displayName'] as Map)['en'].toString();
          titleHi = (value['displayName'] as Map)['hi']?.toString();
        } else if (value['displayName'] is String) {
          title = value['displayName'] as String;
        } else {
          title = entry.key.toString();
        }

        final List remediesList = (value['remedies'] is List) ? value['remedies'] as List : const [];
        final List<String> herbNames = [];
        final List<String> herbNamesHi = [];
        final List<String> descriptions = [];
        final List<String> descriptionsHi = [];
        for (final r in remediesList) {
          if (r is Map<String, dynamic>) {
            final herb = r['herb'];
            if (herb is Map && herb['en'] != null) herbNames.add(herb['en'].toString());
            if (herb is Map && herb['hi'] != null) herbNamesHi.add(herb['hi'].toString());
            if (herb is String) herbNames.add(herb);
            final desc = r['description'];
            if (desc is Map && desc['en'] != null) descriptions.add(desc['en'].toString());
            if (desc is Map && desc['hi'] != null) descriptionsHi.add(desc['hi'].toString());
            if (desc is String) descriptions.add(desc);
          }
        }

        final remedyText = herbNames.isEmpty ? 'Not specified' : herbNames.join(', ');
        final remedyTextHi = herbNamesHi.isEmpty ? null : herbNamesHi.join(', ');
        final detailsText = descriptions.isEmpty ? null : descriptions.join('\n');
        final detailsTextHi = descriptionsHi.isEmpty ? null : descriptionsHi.join('\n');
        result.add(RemedyItem(
          title: title,
          remedies: remedyText,
          details: detailsText,
          titleHi: titleHi,
          remediesHi: remedyTextHi,
          detailsHi: detailsTextHi,
        ));
      }
      return result;
    } else {
      throw const FormatException('Unsupported JSON shape');
    }
  }

  static Future<List<RemedyItem>> loadDefault() async {
    // Try preferred location first
    const primary = 'assets/data/remedies.json';
    // Fallbacks (alternate spellings/locations)
    const fallback = 'assets/data/remidies.json';
    const fallback2 = 'assets/images/data/remedies.json';
    try {
      return await loadFromAssets(primary);
    } catch (_) {
      try {
        return await loadFromAssets(fallback);
      } catch (_) {
        return await loadFromAssets(fallback2);
      }
    }
  }
}


