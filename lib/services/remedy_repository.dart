import '../models/remedy.dart';
import 'remedy_loader.dart';

class RemedyRepository {
  List<RemedyItem>? _cache;

  Future<List<RemedyItem>> _ensureLoaded() async {
    _cache ??= await RemedyLoader.loadDefault();
    return _cache!;
  }

  Future<List<RemedyItem>> search(String query) async {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return [];
    final all = await _ensureLoaded();
    return all.where((r) {
      final title = r.title.toLowerCase();
      final rem = r.remedies.toLowerCase();
      final details = (r.details ?? '').toLowerCase();
      // Very simple transliteration: also check Hindi strings present in the JSON via naive mapping if query contains Devanagari.
      final containsDevanagari = _hasDevanagari(query);
      if (containsDevanagari) {
        // If user typed Hindi, do not lowercase-only compare; just direct contains on original fields as well.
        final fieldsHi = [r.titleHi, r.remediesHi, r.detailsHi];
        if (fieldsHi.any((f) => (f ?? '').contains(query))) return true;
        // Also scan parsed dictionary-derived details if present
        return r.title.contains(query) || (r.details?.contains(query) ?? false);
      }
      return title.contains(q) || rem.contains(q) || details.contains(q);
    }).toList();
  }

  bool _hasDevanagari(String s) {
    for (final rune in s.runes) {
      if (rune >= 0x0900 && rune <= 0x097F) return true;
    }
    return false;
  }
}


