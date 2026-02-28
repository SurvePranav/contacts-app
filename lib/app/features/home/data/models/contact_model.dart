// ignore_for_file: public_member_api_docs, sort_constructors_first
class ContactModel {
  final String id;
  final String name;
  final String phone;
  final String initials;
  final String color;
  final String emailId;
  final bool isFavourite;

  const ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.initials,
    required this.color,
    required this.emailId,
    required this.isFavourite,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      initials: json['initials'] ?? '',
      color: json['color'] ?? '',
      emailId: json['emailId'] ?? '',
      isFavourite: json['isFavourite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'initials': initials,
      'color': color,
      'emailId': emailId,
      'isFavourite': isFavourite,
    };
  }

  ContactModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? initials,
    String? color,
    String? emailId,
    bool? isFavourite,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      initials: initials ?? this.initials,
      color: color ?? this.color,
      emailId: emailId ?? this.emailId,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
