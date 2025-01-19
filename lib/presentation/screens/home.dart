import 'dart:convert';

import 'package:user_profile_management/data/users.dart';
import 'package:flutter/material.dart';
import 'package:user_profile_management/model/user.dart';
import 'package:user_profile_management/core/shared_preferences.dart';
import 'package:user_profile_management/model/dio_response.dart';
import 'package:user_profile_management/presentation/widgets/user_card.dart';
import 'package:user_profile_management/presentation/widgets/user_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UsersController controller = UsersController();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => UserBottomSheet(
            controller: controller,
          ),
        ),
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: controller.users.isNotEmpty
            ? ListView.builder(
                itemCount: controller.users.length,
                itemBuilder: (context, index) => UserCard(
                    user: controller.users[index], controller: controller),
              )
            : FutureBuilder<DioResponse>(
                future: controller.fetchUsers(),
                builder: (context, apiSnapshot) {
                  if (apiSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (apiSnapshot.hasError) {
                    return Center(child: Text('Error: ${apiSnapshot.error}'));
                  } else if (!apiSnapshot.hasData ||
                      apiSnapshot.data!.status == 0) {
                    return Center(
                        child: Text('Error: ${apiSnapshot.data!.error}'));
                  } else {
                    final List<User> users = (apiSnapshot.data!.data!)
                        .map((e) => User.fromJson(e))
                        .toList();
                    SharedPreference.setString(
                        key: "users", value: jsonEncode(users));
                    return ListView.builder(
                      itemCount: controller.users.length,
                      itemBuilder: (context, index) => UserCard(
                          user: controller.users[index],
                          controller: controller),
                    );
                  }
                },
              ),
      ),
    );
  }
}
