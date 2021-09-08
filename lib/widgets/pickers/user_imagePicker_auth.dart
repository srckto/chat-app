import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) imagePick;

  UserImagePicker(this.imagePick);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _imageFile;

  Future _pickedImage(ImageSource source) async {
    final _getImage = await ImagePicker().pickImage(source: source, imageQuality: 40 , maxHeight: 150,maxWidth: 150);

    if (_getImage != null) {
      setState(() {
        _imageFile = File(_getImage.path);
      });
      widget.imagePick(_imageFile!);
      
    } else {
      print("Not Image Selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey,
            backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
          ),
          SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () => _pickedImage(ImageSource.gallery),
                icon: Icon(Icons.image),
                label: Text("Select image\nfrom gellary"),
              ),
            ),
            Expanded(
              child: TextButton.icon(
                onPressed: () => _pickedImage(ImageSource.camera),
                icon: Icon(Icons.camera_alt),
                label: Text(
                  "Select image\nfrom camera",
                  softWrap: true,
                ),
              ),
            ),
          ])
        ],
      ),
    );
  }
}
