import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:finstagram/services/firebase_service.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

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
  FirebaseService? _firebaseService;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth! * 0.05,
          ),
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
      ),
    );
  }

  Widget _titleText() {
    return const Text(
      "Finstagram",
      style: TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _registrationButton() {
    return MaterialButton(
      minWidth: _deviceWidth! * 0.5,
      height: _deviceHeight! * 0.05,
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

  void _registerUser() async {
    if (_globalKey.currentState!.validate() && _image != null) {
      _globalKey.currentState!.save();
      bool result = await _firebaseService!.registerUser(
        name: _name!,
        email: _email!,
        password: _password!,
        image: _image!,
      );
      print("Registration Status: $result");
      if (result) Navigator.pop(context);
    }
  }

  Widget _registrationForm() {
    return SizedBox(
      width: _deviceWidth! * 0.8,
      height: _deviceHeight! * 0.3,
      child: Form(
        key: _globalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          print('Name values is set to be $_name');
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
          print('Email values is set to be $_email');
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
          print('Password values is set to be $_password');
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
