import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;

class FirebaseImageUploadScreen extends StatefulWidget {
  const FirebaseImageUploadScreen({Key? key}) : super(key: key);

  @override
  State<FirebaseImageUploadScreen> createState() =>
      _FirebaseImageUploadScreenState();
}

class _FirebaseImageUploadScreenState extends State<FirebaseImageUploadScreen> {
  File? _file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: Row(
        children: [
          ElevatedButton(onPressed: selectFile, child: Text('Get Image')),
          ElevatedButton(onPressed: uploadFile, child: Text('Upload File'))
        ],
      ),
    );
  }

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => _file = File(path));
  }

  void uploadFile() {
    if (_file == null) return;
    final fileName = Path.basename(_file!.path);
    final destination = 'files/$fileName';

    FirebaseApi.uploadFile(destination, _file!);
  }
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
