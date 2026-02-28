import 'package:contacts_app/app/core/enums/status.dart';
import 'package:contacts_app/app/features/home/presentation/bloc/home_bloc.dart';
import 'package:contacts_app/app/features/home/presentation/widgets/contacts_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritesList extends StatelessWidget {
  const FavouritesList({super.key});

  // static const List<Contact> _favourites = [
  //   Contact(
  //     name: 'Alice Johnson',
  //     phone: '+1 202-555-0171',
  //     initials: 'AJ',
  //     color: Color(0xFF4285F4),
  //     isFavourite: true,
  //     id: '1',
  //   ),
  //   Contact(
  //     name: 'Eva Chen',
  //     phone: '+1 202-555-0167',
  //     initials: 'EC',
  //     color: Color(0xFF9C27B0),
  //     isFavourite: true,
  //     id: '5',
  //   ),
  //   Contact(
  //     name: 'Grace Kim',
  //     phone: '+1 202-555-0189',
  //     initials: 'GK',
  //     color: Color(0xFFFF5722),
  //     isFavourite: true,
  //     id: '7',
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.favouriteContactsStatus != current.favouriteContactsStatus,
      builder: (context, state) {
        if (state.favouriteContactsStatus == BlocStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.favouriteContactsStatus == BlocStatus.failure) {
          return const Center(child: Text("Failed to load contacts"));
        } else if (state.favouriteContactsStatus == BlocStatus.success) {
          final favourites = state.favouriteContacts;
          if (favourites.isEmpty) {
            return _EmptyFavourites();
          }
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 90, top: 8),
            itemCount: favourites.length,
            separatorBuilder: (_, __) =>
                const Divider(indent: 72, height: 0, thickness: 0.5),
            itemBuilder: (context, index) =>
                ContactTile(contact: favourites[index]),
          );
        }
        return const SizedBox();
      },
    );
  }
}

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
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.star_rounded,
              size: 40,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No favourites yet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            'Star contacts to see them here',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
