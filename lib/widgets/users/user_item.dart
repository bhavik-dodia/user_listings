import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_listings/helpers/snackbar_helper.dart';

import '../../helpers/dialog_helper.dart';
import '../../models/user.dart';
import '../../providers/users_data.dart';

/// Displays a card with user details.
class UserItem extends StatelessWidget {
  final User user;

  const UserItem({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(user.id),
      background: buildBackground(Alignment.centerRight),
      // secondaryBackground: buildBackground(Alignment.centerRight),
      dismissThresholds: {
        // DismissDirection.startToEnd: 0.2,
        DismissDirection.endToStart: 0.2,
      },
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => DialogHelper.showAlertDialog(
        context,
        'Are you sure?',
        'User "${user.firstName}" will be removed.',
      ),
      onDismissed: (direction) {
        try {
          Provider.of<UsersData>(context, listen: false).deleteUser(user);
        } catch (e) {
          SnackBarHelper.showSnackBar(context, e.message);
        }
      },
      child: Card(
        elevation: 8.0,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.avatar),
          ),
          title: Text(
            '${user.firstName} ${user.lastName}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          subtitle: Text(
            '${user.email}',
            style: const TextStyle(fontSize: 12.0),
          ),
        ),
      ),
    );
  }

  /// Draws a background behind the user item card.
  Container buildBackground(Alignment alignment) {
    return Container(
      color: Colors.redAccent,
      alignment: alignment,
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: const Icon(Icons.delete_forever_rounded, size: 30.0),
    );
  }
}
