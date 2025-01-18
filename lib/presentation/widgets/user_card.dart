import 'package:demo/presentation/screens/details.dart';
import 'package:flutter/material.dart';
import 'package:user_profile_management/data/model/user.dart';
import 'package:user_profile_management/data/users.dart';
import 'package:user_profile_management/presentation/widgets/snack_bar.dart';
import 'package:user_profile_management/presentation/widgets/user_bottom_sheet.dart';

class UserCard extends StatelessWidget {
  final User user;
  final UsersController controller;
  const UserCard({super.key, required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(user.id ?? UniqueKey().toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final confirm = await _confirmDelete(context);
        return confirm;
      },
      background: _buildDeleteBackground(),
      onDismissed: (direction) => _deleteUser(context),
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailsScreen(user: user),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: AssetImage("assets/user.png"),
          ),
          title: Text(
            user.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            user.email,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => UserBottomSheet(
                user: user,
                controller: controller,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete User'),
            content: Text('Are you sure you want to delete ${user.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _deleteUser(BuildContext context) async {
    try {
      final result = await controller.removeUser(user);
      if (result == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBar(
            label: "${user.name} has been deleted",
            action: SnackBarAction(
              label: "Undo",
              onPressed: () {
                controller.addUser(user);
              },
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        buildSnackBar(label: "Failed to delete user: ${e.toString()}"),
      );
    }
  }
}
