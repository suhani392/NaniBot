class RemedyItem {
  final String title;
  final String remedies;
  final String? details;
  final String? date;
  final String? titleHi;
  final String? remediesHi;
  final String? detailsHi;

  RemedyItem({
    required this.title,
    required this.remedies,
    this.details,
    this.date,
    this.titleHi,
    this.remediesHi,
    this.detailsHi,
  });

  factory RemedyItem.fromJson(Map<String, dynamic> json) {
    String? title = (json['title'] ?? json['name'] ?? json['illness'] ?? '').toString();
    String? remedies = (json['remedies'] ?? json['treatment'] ?? json['cure'] ?? '').toString();
    String? details = (json['details'] ?? json['description'] ?? json['info'])?.toString();
    String? date = json['date']?.toString();

    if (title.isEmpty && remedies.isEmpty) {
      throw FormatException('Missing required keys (title/remedies) in remedy item');
    }

    return RemedyItem(
      title: title.isEmpty ? 'Unknown' : title,
      remedies: remedies.isEmpty ? 'Not specified' : remedies,
      details: details,
      date: date,
      titleHi: json['title_hi']?.toString(),
      remediesHi: json['remedies_hi']?.toString(),
      detailsHi: json['details_hi']?.toString(),
    );
  }
}


