import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/menu_item.dart';
import '../../providers/users_data.dart';
import '../../screens/auth_page.dart';
import 'menu_tile.dart';

/// Displays the hidden menu containing user profile and application navigation options.
class Menu extends StatelessWidget {
  final Function manageDrawer;
  Menu({
    Key key,
    @required Animation<Offset> slideAnimation,
    @required Animation<double> menuScaleAnimation,
    this.manageDrawer,
  })  : _slideAnimation = slideAnimation,
        _menuScaleAnimation = menuScaleAnimation,
        super(key: key);

  final Animation<Offset> _slideAnimation;
  final Animation<double> _menuScaleAnimation;

  final List<MenuItem> _menuItems = [
    MenuItem(
      iconData: Icons.home_rounded,
      name: 'Home',
      action: (context) {},
    ),
    MenuItem(
      iconData: Icons.logout,
      name: 'Logout',
      action: (context) =>
          Navigator.pushReplacementNamed(context, AuthPage.routeName),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final name = Provider.of<UsersData>(context).currentUser;
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),
              accountName: Text(
                'Hello, ${name.substring(0, name.indexOf('@'))}',
                style: GoogleFonts.poppins(
                  color: Colors.blueAccent,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              accountEmail: Text(
                name,
                style: GoogleFonts.poppins(color: Colors.blueAccent),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 0.6 * MediaQuery.of(context).size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: _menuItems.length,
                  itemBuilder: (context, index) {
                    final menuitem = _menuItems[index];
                    return MenuTile(
                      icon: menuitem.iconData,
                      title: menuitem.name,
                      isSelected: index == 0 ? true : false,
                      onTap: () {
                        manageDrawer();
                        menuitem.action(context);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
