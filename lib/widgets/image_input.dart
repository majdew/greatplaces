import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    final imagePicked = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 600,
    );

    File imageFile = File(imagePicked.path);

    setState(() => _storedImage = imageFile);

    // get application directory to save application data
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    // get image name including the extension generated by the system
    String fileName = path.basename(imageFile.path);

    // strore image in the application directory
    final savedImage = await imageFile.copy("${appDir.path}/$fileName");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  "No Image Taken",
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            onPressed: _takePicture,
            label: Text(
              "Take Picture",
              textAlign: TextAlign.center,
            ),
            textColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.camera),
          ),
        ),
      ],
    );
  }
}
