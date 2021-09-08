import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/pickers/user_imagePicker_auth.dart';

class AuthForm extends StatefulWidget {
  // AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  String? _email = "";
  String? _password = "";
  String? _userName = "";
  bool? _logState = true;
  bool? _loadingState = false;
  File? _userImageFile;

  void _imagePick(File pickedImage) {
    setState(() {
      _userImageFile = pickedImage;
    });
  }

  _sumbitData({
    String? email,
    String? password,
    String? userName,
    File? image,
    bool? logState,
    BuildContext? ctx,
  }) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    UserCredential userCredential;
    try {
      setState(() {
        _loadingState = true;
      });
      if (logState == true) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );

        final Reference refStorage = FirebaseStorage.instance.ref().child('userImage').child(userCredential.user!.uid + ".jpg");
        await refStorage.putFile(image!);

        final urlImage = await refStorage.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          "username": userName,
          "password": password,
          "userImage": urlImage,
        }) as CollectionReference?;
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "";

      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = "There is an error";
      }
      setState(() {
        _loadingState = false;
      });
      ScaffoldMessenger.of(ctx!).showSnackBar(SnackBar(
        content: Text(
          errorMessage,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
      ));
    } catch (e) {
      print(e);
      setState(() {
        _loadingState = false;
      });
    }
  }

  _submit() {
    if (_logState == false) {
      if (_userImageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Please enter an image",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white,
        ));
        return;
      }
    }
    try {
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus(); // to close keyboard

      if (isValid == true) {
        _formKey.currentState!.save();
        _sumbitData(
          email: _email!.trim(),
          password: _password!.trim(),
          userName: _userName!.trim(),
          logState: _logState!,
          image: _userImageFile,
          ctx: context,
        );
      }
    } catch (error) {
      print("Error : $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                if (!_logState!) UserImagePicker(_imagePick),
                if (!_logState!)
                  TextFormField(
                    key: ValueKey("userName"),
                    decoration: InputDecoration(
                      labelText: "Create User Name",
                    ),
                    onSaved: (value) {
                      _userName = value;
                    },
                    validator: (value) {
                      if (value!.length < 4) {
                        return "Invalid UserName";
                      }
                      return null;
                    },
                  ),
                SizedBox(height: 10),
                TextFormField(
                  key: ValueKey("email"),
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    labelText: "Enter Your e-mail",
                  ),
                  onSaved: (value) {
                    _email = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty || !value.contains("@")) {
                      return "Invalid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  key: ValueKey("password"),
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    labelText: "Enter Your password",
                  ),
                  obscureText: true,
                  onSaved: (value) {
                    _password = value;
                  },
                  validator: (value) {
                    if (value!.length < 6) {
                      return "Password is too short";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                if (_loadingState == true)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    child: Text(_logState! ? "Log In" : "Sign Up"),
                    onPressed: _submit,
                  ),
                if (_loadingState == false)
                  TextButton(
                    child: Text(
                      _logState! ? "Create a new account" : "I already have an account",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      setState(() {
                        _logState = !_logState!;
                      });
                    },
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
