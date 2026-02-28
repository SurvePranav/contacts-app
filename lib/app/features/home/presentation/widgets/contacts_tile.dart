import 'package:contacts_app/app/features/home/domain/entities/contact_entity.dart';
import 'package:contacts_app/app/features/home/presentation/pages/contact_details_page.dart';
import 'package:flutter/material.dart';

class ContactTile extends StatelessWidget {
  final Contact contact;
  const ContactTile({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      // leading: CircleAvatar(
      //   backgroundColor: contact.color.withOpacity(0.15),
      //   radius: 24,
      //   child: Text(
      //     contact.initials,
      //     style: TextStyle(
      //       color: contact.color,
      //       fontWeight: FontWeight.w600,
      //       fontSize: 15,
      //     ),
      //   ),
      // ),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: contact.color.withOpacity(0.15),
            child: Text(
              contact.initials,
              style: TextStyle(
                color: contact.color,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          if (contact.isFavourite)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Color(0xFFFBBC04),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star, size: 12, color: Colors.white),
              ),
            ),
        ],
      ),

      title: Text(
        contact.name,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
      ),
      subtitle: Text(contact.phone, style: const TextStyle(fontSize: 13)),
      trailing: IconButton(
        icon: const Icon(
          Icons.call_outlined,
          // color: Color(0xFF5F6368),
          size: 22,
        ),
        onPressed: () {},
      ),
      onTap: () {
        Navigator.of(context).push(ContactDetailsPage.route(contact));
      },
    );
  }
}
