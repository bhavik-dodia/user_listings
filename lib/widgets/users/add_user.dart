import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../helpers/snackbar_helper.dart';
import '../../models/user.dart';
import '../../providers/users_data.dart';

/// Displays form for entering user data.
class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _avatarFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _avatarController = TextEditingController();
  final regex = RegExp(r"^((https?\:\/\/)|(\/{1,2})).*?(.(jpe?g|png|gif))$");
  final _emailRegex =
      RegExp(r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)');
  String avatarImageUrl = '', firstName = '', lastName = '', email = '';
  int id;
  bool isLoading = false;
  bool isSuccess = true;

  @override
  void initState() {
    super.initState();
    _avatarFocusNode.addListener(_updateAvatarImageUrl);
  }

  /// Updates avatar url to display the preview.
  void _updateAvatarImageUrl() {
    if (!_avatarFocusNode.hasFocus) {
      if (!regex.hasMatch(_avatarController.text)) return;
      setState(() => avatarImageUrl = _avatarController.text.trim());
    }
  }

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _avatarController.dispose();
    _avatarFocusNode.removeListener(_updateAvatarImageUrl);
    _avatarFocusNode.dispose();
    super.dispose();
  }

  /// Gets the data and adds a new user.
  void _saveForm() {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      Provider.of<UsersData>(context, listen: false)
          .addUser(
        User(
          id: Provider.of<UsersData>(context, listen: false).usersCount + 1,
          firstName: firstName,
          email: email,
          avatar: avatarImageUrl,
          lastName: lastName,
        ),
      )
          .catchError(
        (error) {
          isSuccess = false;
          setState(() => isLoading = false);
          return SnackBarHelper.showSnackBar(
              context, 'Something went wrong, try again after some time.');
        },
      ).whenComplete(() {
        setState(() => isLoading = false);
        if (isSuccess) {
          SnackBarHelper.showSnackBar(
              context, 'User "$firstName" is added successfully');
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 15.0,
        right: 15.0,
      ),
      children: [
        const Icon(
          Icons.horizontal_rule_rounded,
          size: 40.0,
          color: Colors.grey,
        ),
        Text(
          'New User',
          textAlign: TextAlign.center,
          style: GoogleFonts.laila(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: theme.accentColor,
          ),
        ),
        isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _avatarController,
                            decoration: InputDecoration(
                              labelText: 'Avatar Image URL',
                              hintText: 'http://image.png',
                              prefixIcon: const Icon(Icons.insert_link_rounded),
                              border: buildBorder(),
                            ),
                            maxLines: 3,
                            minLines: 1,
                            focusNode: _avatarFocusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.url,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value.trim().isEmpty)
                                return 'Avatar image URL must not be empty';
                              if (!regex.hasMatch(value.trim()))
                                return 'Enter valid avatar image url';
                              return null;
                            },
                            onSaved: (value) =>
                                setState(() => avatarImageUrl = value.trim()),
                            onFieldSubmitted: (_) => FocusScope.of(context)
                                .requestFocus(_firstNameFocusNode),
                          ),
                        ),
                        Visibility(
                          visible: avatarImageUrl != '',
                          child: Container(
                            height: 65.0,
                            width: 65.0,
                            margin: const EdgeInsets.only(
                              left: 8.0,
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[600]),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14.0),
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                avatarImageUrl,
                                fit: BoxFit.cover,
                                frameBuilder: (context, child, frame,
                                        wasSynchronouslyLoaded) =>
                                    wasSynchronouslyLoaded
                                        ? child
                                        : AnimatedOpacity(
                                            child: child,
                                            opacity: frame == null ? 0 : 1,
                                            duration:
                                                const Duration(seconds: 1),
                                            curve: Curves.easeOut,
                                          ),
                                loadingBuilder: (context, child,
                                        loadingProgress) =>
                                    loadingProgress == null
                                        ? child
                                        : Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes
                                                  : null,
                                            ),
                                          ),
                                errorBuilder:
                                    (context, exception, stackTrace) =>
                                        Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '😥',
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      color: Colors.redAccent,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        hintText: 'Enter first name of the user',
                        prefixIcon: const Icon(Icons.title_rounded),
                        border: buildBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value.trim().isEmpty
                          ? 'First name must not be empty'
                          : null,
                      focusNode: _firstNameFocusNode,
                      onSaved: (value) => firstName = value.trim(),
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_lastNameFocusNode),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Last name',
                        hintText: 'Enter last name of the user',
                        prefixIcon: const Icon(Icons.title_rounded),
                        border: buildBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      focusNode: _lastNameFocusNode,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value.trim().isEmpty
                          ? 'Last name must not be empty'
                          : null,
                      onSaved: (value) => lastName = value.trim(),
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_emailFocusNode),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter email of the user',
                        prefixIcon: const Icon(Icons.email_rounded),
                        border: buildBorder(),
                      ),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Email id must not be empty';
                        else if (!_emailRegex.hasMatch(value))
                          return 'Enter valid email id';
                        return null;
                      },
                      focusNode: _emailFocusNode,
                      onSaved: (value) => email = value.trim(),
                      onFieldSubmitted: (_) => _saveForm(),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.25,
                      ),
                      child: MaterialButton(
                        onPressed: _saveForm,
                        color: Theme.of(context).accentColor,
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          'Add User',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
    );
  }
}
