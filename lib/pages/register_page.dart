import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  double? _deviceHeight, _deviceWidth;
  String? _email, _name, _password;
  File? _image;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _titleText(),
              _profileImageWidget(),
              _registrationForm(),
              _registrationButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleText() {
    return const Text(
      "Finstagram",
      style: TextStyle(
          color: Colors.black, fontSize: 25, fontWeight: FontWeight.w600),
    );
  }

  Widget _registrationButton() {
    return MaterialButton(
      minWidth: _deviceWidth! * 0.7,
      height: _deviceHeight! * 0.06,
      color: Colors.grey,
      onPressed: _registerUser,
      child: const Text(
        "Register",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  void _registerUser() {
    if (_globalKey.currentState!.validate() && _email != null) {
      _globalKey.currentState!.save();
    }
  }

  Widget _registrationForm() {
    return SizedBox(
      width: _deviceWidth! * 0.8,
      child: Form(
        key: _globalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _nameInput(),
            _emailInput(),
            _passwordInput(),
          ],
        ),
      ),
    );
  }

  Widget _nameInput() {
    return TextFormField(
      validator: (value) => value!.isNotEmpty ? null : "Please enter your name",
      onSaved: (newValue) {
        setState(() {
          _name = newValue;
        });
      },
      decoration: const InputDecoration(hintText: "Name..."),
    );
  }

  Widget _emailInput() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: "Email...",
      ),
      onSaved: (newValue) {
        setState(() {
          _email = newValue;
        });
      },
      validator: (newValue) {
        bool result = newValue!.contains(
          RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
        );
        return result ? null : "Please enter a valid email";
      },
    );
  }

  Widget _passwordInput() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(hintText: "Password..."),
      onSaved: (newValue) {
        setState(() {
          _password = newValue;
        });
      },
      validator: (newValue) => newValue!.length > 6
          ? null
          : "Please enter a password greater than 6 characters.",
    );
  }

  Widget _profileImageWidget() {
    var imageProvider = _image != null
        ? FileImage(_image!)
        : const NetworkImage("https://i.pravatar.cc/300");
    return GestureDetector(
      onTap: () {
        FilePicker.platform.pickFiles(type: FileType.image).then((value) {
          setState(() {
            _image = File(value!.files.first.path!);
          });
        });
      },
      child: Container(
        height: _deviceHeight! * 0.15,
        width: _deviceHeight! * 0.15,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imageProvider as ImageProvider,
          ),
        ),
      ),
    );
  }
}
