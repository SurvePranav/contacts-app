import 'package:contacts_app/app/features/home/domain/entities/contact_entity.dart';
import 'package:contacts_app/app/features/home/presentation/widgets/contacts_tile.dart';
import 'package:flutter/material.dart';

class FavouritesList extends StatelessWidget {
  const FavouritesList({super.key});

  static const List<Contact> _favourites = [
    Contact(
      name: 'Alice Johnson',
      phone: '+1 202-555-0171',
      initials: 'AJ',
      color: Color(0xFF4285F4),
      isFavourite: true,
      id: '1',
    ),
    Contact(
      name: 'Eva Chen',
      phone: '+1 202-555-0167',
      initials: 'EC',
      color: Color(0xFF9C27B0),
      isFavourite: true,
      id: '5',
    ),
    Contact(
      name: 'Grace Kim',
      phone: '+1 202-555-0189',
      initials: 'GK',
      color: Color(0xFFFF5722),
      isFavourite: true,
      id: '7',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _favourites.isEmpty
        ? _EmptyFavourites()
        : ListView.separated(
            padding: const EdgeInsets.only(bottom: 90, top: 8),
            itemCount: _favourites.length,
            separatorBuilder: (_, __) =>
                const Divider(indent: 72, height: 0, thickness: 0.5),
            itemBuilder: (context, index) =>
                ContactTile(contact: _favourites[index]),
          );
  }
}

// class _FavouriteCard extends StatelessWidget {
//   final Contact contact;
//   const _FavouriteCard({required this.contact});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 80,
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               CircleAvatar(
//                 radius: 32,
//                 backgroundColor: contact.color.withOpacity(0.15),
//                 child: Text(
//                   contact.initials,
//                   style: TextStyle(
//                     color: contact.color,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 right: 0,
//                 child: Container(
//                   width: 20,
//                   height: 20,
//                   decoration: const BoxDecoration(
//                     color: Color(0xFFFBBC04),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.star, size: 12, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 6),
//           Text(
//             contact.name.split(' ').first,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Color(0xFF202124),
//               fontWeight: FontWeight.w400,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }

class _EmptyFavourites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.star_outline_rounded,
              size: 40,
              color: Color(0xFF9AA0A6),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No favourites yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF202124),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Star contacts to see them here',
            style: TextStyle(fontSize: 14, color: Color(0xFF5F6368)),
          ),
        ],
      ),
    );
  }
}
