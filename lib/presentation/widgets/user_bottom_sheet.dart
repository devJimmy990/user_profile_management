import 'package:user_profile_management/model/address.dart';
import 'package:user_profile_management/model/user.dart';
import 'package:user_profile_management/data/users.dart';
import 'package:user_profile_management/presentation/widgets/input.dart';
import 'package:user_profile_management/presentation/widgets/snack_bar.dart';
import 'package:flutter/material.dart';

class UserBottomSheet extends StatefulWidget {
  final User? user;
  final UsersController controller;
  const UserBottomSheet({super.key, this.user, required this.controller});

  @override
  State<UserBottomSheet> createState() => _UserBottomSheetState();
}

class _UserBottomSheetState extends State<UserBottomSheet> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController streetController;
  late TextEditingController cityController;
  late TextEditingController suiteController;
  late TextEditingController zipController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user?.name ?? "");
    emailController = TextEditingController(text: widget.user?.email ?? "");
    phoneController = TextEditingController(text: widget.user?.phone ?? "");
    streetController =
        TextEditingController(text: widget.user?.address.street ?? "");
    cityController =
        TextEditingController(text: widget.user?.address.city ?? "");
    suiteController =
        TextEditingController(text: widget.user?.address.suite ?? "");
    zipController = TextEditingController(text: widget.user?.address.zip ?? "");
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    streetController.dispose();
    cityController.dispose();
    suiteController.dispose();
    zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * .7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputField(
                  icon: Icons.person,
                  label: "full name",
                  controller: nameController,
                ),
                InputField(
                  icon: Icons.email,
                  label: "email address",
                  controller: emailController,
                ),
                InputField(
                  icon: Icons.phone_android,
                  label: "phone",
                  controller: phoneController,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        icon: Icons.streetview,
                        label: "street",
                        controller: streetController,
                      ),
                    ),
                    SizedBox(width: 18),
                    Expanded(
                      child: InputField(
                        icon: Icons.location_city,
                        label: "city",
                        controller: cityController,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        icon: Icons.map,
                        label: "suite",
                        controller: suiteController,
                      ),
                    ),
                    SizedBox(width: 18),
                    Expanded(
                      child: InputField(
                        icon: Icons.location_city,
                        label: "zipcode",
                        controller: zipController,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    phoneController.text.isEmpty ||
                    streetController.text.isEmpty ||
                    cityController.text.isEmpty ||
                    suiteController.text.isEmpty ||
                    zipController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildSnackBar(label: "Please fill all fields"),
                  );
                  return;
                }

                final newUser = User(
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  address: Address(
                    street: streetController.text,
                    city: cityController.text,
                    suite: suiteController.text,
                    zip: zipController.text,
                  ),
                );

                if (widget.user != null) {
                  await widget.controller.updateUser(widget.user!, newUser);
                } else {
                  await widget.controller.addUser(newUser);
                }
                Navigator.of(context).pop();
              },
              child: Text(
                  widget.user != null ? "Update User" : "Create New User",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
