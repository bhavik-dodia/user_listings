import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/snackbar_helper.dart';
import '../../providers/users_data.dart';
import '../../widgets/users/add_user.dart';
import '../users/users_listing.dart';

/// Displays a page to show on top of hidden menu.
class Home extends StatefulWidget {
  final Function manageDrawer;
  final Animation<double> controller;

  const Home({
    Key key,
    this.manageDrawer,
    this.controller,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final duration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    try {
      Provider.of<UsersData>(context, listen: false).fetchUsers();
    } catch (e) {
      SnackBarHelper.showSnackBar(
          context, 'Something went wrong. Check your network and try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        leading: InkWell(
          onTap: widget.manageDrawer,
          child: Center(
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_arrow,
              progress:
                  Tween<double>(begin: 0, end: 1).animate(widget.controller),
              color: theme.accentColor,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: Provider.of<UsersData>(context, listen: false).fetchUsers,
        child: UsersListing(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add User'),
        icon: const Icon(Icons.add_rounded),
        backgroundColor: theme.accentColor,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            clipBehavior: Clip.antiAlias,
            builder: (context) => AddUser(),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
