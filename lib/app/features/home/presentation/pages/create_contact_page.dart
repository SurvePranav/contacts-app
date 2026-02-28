import 'package:contacts_app/app/core/enums/status.dart';
import 'package:contacts_app/app/core/theme/app_palette.dart';
import 'package:contacts_app/app/features/home/domain/entities/contact_entity.dart';
import 'package:contacts_app/app/features/home/presentation/bloc/home_bloc.dart';
import 'package:contacts_app/app/features/home/presentation/pages/contact_details_page.dart';
import 'package:contacts_app/app/features/home/presentation/widgets/common_text_field.dart';
import 'package:flutter/material.dart';

import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

class CreateContactPage extends StatefulWidget {
  final bool isUpdating;
  final Contact? contact;

  static MaterialPageRoute<dynamic> route({
    bool isUpdating = false,
    Contact? contact,
  }) => MaterialPageRoute(
    builder: (context) =>
        CreateContactPage(isUpdating: isUpdating, contact: contact),
  );

  const CreateContactPage({super.key, this.isUpdating = false, this.contact});

  @override
  State<CreateContactPage> createState() => _CreateContactPageState();
}

class _CreateContactPageState extends State<CreateContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool isFavourite = false;
  late Color selectedColor;

  late Contact contact;

  @override
  void initState() {
    super.initState();

    if (widget.isUpdating && widget.contact != null) {
      _nameController.text = widget.contact!.name;
      _emailController.text = widget.contact!.emailId;
      _phoneController.text = widget.contact!.phone;
      selectedColor = widget.contact!.color;
      isFavourite = widget.contact!.isFavourite;
      contact = widget.contact!;
    } else {
      selectedColor = _generateRandomBrightColor();
      contact = Contact(
        id: "",
        name: "",
        emailId: "",
        phone: "",
        color: selectedColor,
        isFavourite: isFavourite,
        initials: '',
      );
    }
  }

  Color _generateRandomBrightColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      150 + random.nextInt(106),
      150 + random.nextInt(106),
      150 + random.nextInt(106),
    );
  }

  String _extractInitials(String name) {
    final parts = name.trim().split(" ");
    if (parts.isEmpty) return "";

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  void _onSave() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    final initials = _extractInitials(name);

    contact = Contact(
      name: name,
      phone: phone,
      initials: initials,
      color: selectedColor,
      id: widget.isUpdating
          ? contact.id
          : "${DateTime.now().millisecondsSinceEpoch}",
      isFavourite: isFavourite,
      emailId: email,
    );

    if (widget.isUpdating) {
      context.read<HomeBloc>().add(UpdateContactEvent(contact: contact));
    } else {
      context.read<HomeBloc>().add(CreateContactEvent(contact: contact));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          previous.createUpdateContactStatus !=
          current.createUpdateContactStatus,
      listener: (context, state) {
        if (state.createUpdateContactStatus == BlocStatus.success) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.of(context).push(ContactDetailsPage.route(contact));
        } else if (state.createUpdateContactStatus == BlocStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? "Error Saving Contact"),
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.isUpdating ? "Update Contact" : "Create Contact"),
          actions: [
            IconButton(
              icon: Icon(
                isFavourite ? Icons.star : Icons.star_border,
                color: isFavourite ? Colors.amber : null,
              ),
              onPressed: () {
                setState(() {
                  isFavourite = !isFavourite;
                });
              },
            ),
            SizedBox(width: 8),
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CommonTextField(
                    controller: _nameController,
                    hintText: "Name",
                    icon: Icons.person,
                  ),

                  const SizedBox(height: 16),
                  CommonTextField(
                    controller: _phoneController,
                    hintText: "Phone",
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  CommonTextField(
                    controller: _emailController,
                    hintText: "Email",
                    icon: Icons.email,
                  ),
                ],
              ),
            ),

            /// Bottom Buttons
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: bottomInset,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color: AppPallete.borderColor,
                    child: SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppPallete.borderColor,
                                elevation: 0,
                              ),
                              onPressed:
                                  state.createUpdateContactStatus ==
                                      BlocStatus.loading
                                  ? null
                                  : () {
                                      Navigator.of(context).pop();
                                    },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppPallete.borderColor,
                                elevation: 0,
                              ),
                              onPressed:
                                  state.createUpdateContactStatus ==
                                      BlocStatus.loading
                                  ? null
                                  : _onSave,
                              child:
                                  state.createUpdateContactStatus ==
                                      BlocStatus.loading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      widget.isUpdating ? "Update" : "Save",
                                      style: TextStyle(fontSize: 18),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
