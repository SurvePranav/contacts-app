import 'package:contacts_app/app/core/common/methods/common_methods.dart';
import 'package:contacts_app/app/core/enums/status.dart';
import 'package:contacts_app/app/core/extensions/string_extension.dart';
import 'package:contacts_app/app/core/theme/app_palette.dart';
import 'package:contacts_app/app/features/home/domain/entities/contact_entity.dart';
import 'package:contacts_app/app/features/home/presentation/bloc/home_bloc.dart';
import 'package:contacts_app/app/features/home/presentation/pages/create_contact_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactDetailsPage extends StatefulWidget {
  final Contact contact;

  static MaterialPageRoute<dynamic> route(Contact contact) => MaterialPageRoute(
    builder: (context) => ContactDetailsPage(contact: contact),
  );

  const ContactDetailsPage({super.key, required this.contact});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    isFavourite = widget.contact.isFavourite;
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Contact"),
        content: const Text("Are you sure you want to delete this contact?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<HomeBloc>().add(
                DeleteContactEvent(contactId: widget.contact.id),
              );
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contact = widget.contact;

    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Column(
        children: [
          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// Top Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppPallete.borderColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    contact.name.capitalizeEachWord(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Mobile ${contact.phone}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  if (contact.emailId != "") ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      contact.emailId,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: contact.color,
                              child: Text(
                                contact.initials,
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// Call Button Only
                        ElevatedButton(
                          onPressed: () {
                            CommonMethods.makeDirectCall(contact.phone);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.call),
                              SizedBox(width: 12),
                              Text("Call", style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          /// Bottom Options
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(color: AppPallete.borderColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Favourite
                GestureDetector(
                  onTap: () {
                    isFavourite = !isFavourite;

                    context.read<HomeBloc>().add(
                      AddRemoveFavouriteEvent(
                        contactId: contact.id,
                        isFavourite: isFavourite,
                      ),
                    );
                    setState(() {});
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isFavourite ? Icons.star : Icons.star_border,
                        color: isFavourite ? Colors.orange : null,
                      ),
                      const SizedBox(height: 6),
                      const Text("Favourite", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),

                /// Edit
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreateContactPage(
                          isUpdating: true,
                          contact: contact,
                        ),
                      ),
                    );
                  },
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_outlined),
                      SizedBox(height: 6),
                      Text("Edit", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),

                /// Delete
                BlocConsumer<HomeBloc, HomeState>(
                  listenWhen: (previous, current) =>
                      previous.deleteContactStatus !=
                      current.deleteContactStatus,
                  listener: (context, state) {
                    if (state.deleteContactStatus == BlocStatus.success) {
                      // show snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Contact deleted successfully"),
                        ),
                      );
                      Navigator.popUntil(context, (route) => route.isFirst);
                    } else if (state.deleteContactStatus ==
                        BlocStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.errorMessage ?? "Failed to delete contact",
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading =
                        state.deleteContactStatus == BlocStatus.loading;
                    return GestureDetector(
                      onTap: isLoading ? null : _showDeleteDialog,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: isLoading ? Colors.grey : null,
                          ),
                          SizedBox(height: 6),
                          Text(
                            isLoading ? "Deleting..." : "Delete",
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
