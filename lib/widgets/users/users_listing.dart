import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/users_data.dart';
import 'user_item.dart';

/// Displays page with glimpse of all the users available.
class UsersListing extends StatelessWidget {
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Consumer<UsersData>(
      builder: (context, usersData, child) {
        final users = usersData.users;
        return usersData.users.isEmpty
            ? child
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 65.0),
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: users.length,
                itemBuilder: (context, index) => UserItem(
                  user: users[index],
                ),
              );
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const LinearProgressIndicator(),
              Expanded(
                child: isPortrait
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: buildChildren,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: buildChildren,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> get buildChildren {
    return [
      AspectRatio(
        aspectRatio: 4 / 3,
        child: Image.asset(
          'images/explore_users.png',
        ),
      ),
      const Text(
        'You can explore users\nonce they are available.',
        textAlign: TextAlign.center,
        softWrap: true,
      ),
    ];
  }
}
