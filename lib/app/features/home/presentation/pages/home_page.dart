import 'package:contacts_app/app/core/theme/app_palette.dart';
import 'package:contacts_app/app/features/home/presentation/bloc/home_bloc.dart';
import 'package:contacts_app/app/features/home/presentation/widgets/contacts_list.dart';
import 'package:contacts_app/app/features/home/presentation/widgets/favourites_list.dart';
import 'package:contacts_app/app/features/home/presentation/pages/create_contact_page.dart';
import 'package:contacts_app/app/features/home/presentation/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static MaterialPageRoute<dynamic> route() =>
      MaterialPageRoute(builder: (context) => HomePage());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  final List<Widget> _pages = const [ContactsList(), FavouritesList()];

  @override
  void initState() {
    super.initState();

    context.read<HomeBloc>().add(const GetAllContactsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _selectedIndex,
      builder: (context, index, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppPallete.borderColor,
            title: Text(index == 0 ? "Contacts" : "Favourites"),
            actions: index == 0 ? [LogoutButton()] : null,
          ),
          body: SafeArea(child: _pages[index]),

          floatingActionButton: index == 0
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(CreateContactPage.route());
                  },
                  elevation: 0,
                  child: const Icon(Icons.person_add_alt_1),
                )
              : null,

          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppPallete.borderColor,
              boxShadow: [
                BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ).copyWith(bottom: 0),
                child: ValueListenableBuilder<int>(
                  valueListenable: _selectedIndex,
                  builder: (context, index, _) {
                    return GNav(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      selectedIndex: index,
                      onTabChange: (newIndex) {
                        _selectedIndex.value = newIndex;
                      },
                      gap: 8,
                      padding: const EdgeInsets.all(16),

                      tabs: const [
                        GButton(
                          icon: Icons.contacts,
                          text: 'Contacts',
                          backgroundColor: AppPallete.backgroundColor,
                        ),
                        GButton(
                          icon: Icons.favorite,
                          text: 'Favourites',
                          backgroundColor: AppPallete.backgroundColor,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
