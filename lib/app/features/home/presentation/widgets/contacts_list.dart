import 'package:contacts_app/app/core/enums/status.dart';
import 'package:contacts_app/app/features/home/presentation/bloc/home_bloc.dart';
import 'package:contacts_app/app/features/home/presentation/widgets/contacts_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({super.key});

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
            return const Center(
              child: Text("No contacts found.\n\nPlease Add some!"),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.only(top: 8, bottom: 90),
            itemCount: contacts.length,
            separatorBuilder: (context, index) =>
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
