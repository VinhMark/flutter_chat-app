import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});

  final Function(File image) onPickImage;

  @override
  State<UserImagePicker> createState() {
    return _UserImagePicker();
  }
}

class _UserImagePicker extends State<UserImagePicker> {
  File? _pickedImageFile;
  void _pickedImage() async {
    final pickedImg = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImg == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImg.path);
    });
    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
          backgroundColor: Colors.grey,
        ),
        TextButton.icon(
          onPressed: _pickedImage,
          icon: const Icon((Icons.image)),
          label: Text(
            'Add Image',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        )
      ],
    );
  }
}
