class Listing {
  final int? id;
  final String username;
  final String title;
  final String description;
  final DateTime? creationDate;
  final DateTime? approvalDate;
  final bool? approved;
  final List<String> types;

  Listing({
    this.id,
    required this.username,
    required this.title,
    required this.description,
    this.creationDate,
    this.approvalDate,
    this.approved,
    required this.types,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'],
      username: json['username'],
      title: json['title'],
      description: json['description'],
      creationDate: DateTime.parse(json['creationDate']),
      approvalDate: json['approvalDate'] != null
          ? DateTime.parse(json['approvalDate'])
          : null,
      approved: json['approved'],
      types: List<String>.from(json['types']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'types': types,
    };
  }
}
