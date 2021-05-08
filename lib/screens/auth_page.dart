import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../helpers/snackbar_helper.dart';
import '../providers/users_data.dart';
import '../widgets/delayed_animation.dart';
import 'home_page.dart';

class AuthPage extends StatefulWidget {
  static const routeName = 'auth-page';

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  final int delayedAmount = 400;
  final _emailRegex =
      RegExp(r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)');
  final _passRegex = RegExp(
      r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&-+=()])(?=\S+$).{8,20}$');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AnimationController _controller;
  String _email = '', _pass = '';
  bool ot = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    if (_pass == 'Admin@123') {
      Provider.of<UsersData>(context, listen: false).currentUser = _email;
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    } else {
      SnackBarHelper.showSnackBar(context, 'Wrong password!!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.asset(
                "images/unlock.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Card(
            elevation: 0.0,
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            color: theme.canvasColor.withOpacity(0.5),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    AvatarGlow(
                      endRadius: 90,
                      duration: const Duration(seconds: 2),
                      glowColor: theme.accentColor,
                      repeat: true,
                      repeatPauseDuration: const Duration(seconds: 1),
                      startDelay: const Duration(milliseconds: 500),
                      child: Container(
                        height: 105,
                        width: 105,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              blurRadius: 40.0,
                              color: theme.accentColor,
                            ),
                          ],
                        ),
                        child: Card(
                          shape: CircleBorder(),
                          margin: EdgeInsets.zero,
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlutterLogo(),
                          ),
                        ),
                        // Image.asset(
                        //   "images/logo.png",
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                    DelayedAnimation(
                      delay: delayedAmount + 500,
                      child: Text(
                        "Welcome",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.laila(
                          fontWeight: FontWeight.bold,
                          fontSize: 35.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    DelayedAnimation(
                      delay: delayedAmount + 1000,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          hintText: 'Email Id',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 10.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Email id must not be empty';
                          else if (!_emailRegex.hasMatch(value))
                            return 'Enter valid email id';
                          return null;
                        },
                        onSaved: (value) {
                          _email = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    DelayedAnimation(
                      delay: delayedAmount + 1500,
                      child: TextFormField(
                        obscureText: ot,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          hintText: 'Password (Abc@1234 [8 - 20])',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 10.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => ot = !ot),
                            tooltip: ot ? 'show password' : 'hide password',
                            icon: Icon(
                              ot
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Password must not be empty';
                          else if (value == 'Abc@1234')
                            return 'Demo password can\'t be used';
                          else if (!_passRegex.hasMatch(value))
                            return 'Enter a strong password';
                          return null;
                        },
                        onSaved: (value) {
                          _pass = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    DelayedAnimation(
                      delay: delayedAmount + 2000,
                      child: MaterialButton(
                        onPressed: _submit,
                        elevation: 5.0,
                        padding: const EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        textColor: theme.canvasColor,
                        color: theme.accentColor,
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
