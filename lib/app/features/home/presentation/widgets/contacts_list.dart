import 'package:contacts_app/app/core/enums/status.dart';
// import 'package:contacts_app/app/features/home/domain/entities/contact_entity.dart';
import 'package:contacts_app/app/features/home/presentation/bloc/home_bloc.dart';
import 'package:contacts_app/app/features/home/presentation/widgets/contacts_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({super.key});

  // static const List<Contact> _contacts = [
  //   Contact(
  //     name: 'Alice Johnson',
  //     phone: '+1 202-555-0171',
  //     initials: 'AJ',
  //     color: Color(0xFF4285F4),
  //     id: '1',
  //   ),
  //   Contact(
  //     name: 'Bob Martinez',
  //     phone: '+1 202-555-0132',
  //     initials: 'BM',
  //     color: Color(0xFF34A853),
  //     id: '2',
  //   ),
  //   Contact(
  //     name: 'Carol White',
  //     phone: '+1 202-555-0198',
  //     initials: 'CW',
  //     color: Color(0xFFEA4335),
  //     id: '3',
  //   ),
  //   Contact(
  //     name: 'David Lee',
  //     phone: '+1 202-555-0145',
  //     initials: 'DL',
  //     color: Color(0xFFFBBC04),
  //     id: '4',
  //   ),
  //   Contact(
  //     name: 'Eva Chen',
  //     phone: '+1 202-555-0167',
  //     initials: 'EC',
  //     color: Color(0xFF9C27B0),
  //     id: '5',
  //   ),
  //   Contact(
  //     name: 'Frank Brown',
  //     phone: '+1 202-555-0112',
  //     initials: 'FB',
  //     color: Color(0xFF00BCD4),
  //     id: '6',
  //   ),
  //   Contact(
  //     name: 'Grace Kim',
  //     phone: '+1 202-555-0189',
  //     initials: 'GK',
  //     color: Color(0xFFFF5722),
  //     id: '7',
  //   ),
  //   Contact(
  //     id: '8',
  //     name: 'Henry Davis',
  //     phone: '+1 202-555-0156',
  //     initials: 'HD',
  //     color: Color(0xFF607D8B),
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.allContactsStatus != current.allContactsStatus,
      builder: (context, state) {
        if (state.allContactsStatus == BlocStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.allContactsStatus == BlocStatus.failure) {
          return const Center(child: Text("Failed to load contacts"));
        } else if (state.allContactsStatus == BlocStatus.success) {
          final contacts = state.contacts;
          if (contacts.isEmpty) {
            return const Center(child: Text("No contacts found"));
          }
          return ListView.separated(
            padding: const EdgeInsets.only(top: 8, bottom: 90),
            itemCount: contacts.length,
            separatorBuilder: (_, __) =>
                const Divider(indent: 72, height: 0, thickness: 0.5),
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ContactTile(contact: contact);
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
