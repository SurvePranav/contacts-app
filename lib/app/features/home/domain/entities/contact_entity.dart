import 'dart:ui';

class Contact {
  final String name;
  final String phone;
  final String initials;
  final Color color;
  final String emailId;
  final bool isFavourite;
  final String id;
  const Contact({
    required this.name,
    required this.phone,
    required this.initials,
    required this.color,
    required this.id,
    this.emailId = '',
    this.isFavourite = false,
  });
}
