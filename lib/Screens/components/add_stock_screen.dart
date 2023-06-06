import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakyab/constants/colors.dart';
import 'package:shakyab/constants/networkIcon.dart';
import 'package:shakyab/constants/url.dart';
import 'package:shakyab/services/itemsHelper.dart';

class AddStockScreen extends StatefulWidget {
  const AddStockScreen({Key? key}) : super(key: key);

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  File? _selectedImage;
  Uint8List? _uInt8Image;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? barcode;
  String? name;
  double _wholesaleSliderValue = 15.0;
  double _retailSliderValue = 15.0;
  double _quantitySliderValue = 50.0;
  bool _isLoading = false;
  bool _hasImageFile = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        color: colorSeven,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              color: colorSeven,
              width: size.width < 426.0
                  ? double.infinity
                  : size.width < 769.0
                      ? size.width * 0.5
                      : size.width * 0.3,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const Text(
                            "Add Items",
                            style: TextStyle(
                                fontFamily: 'Dosis',
                                fontSize: 20.0,
                                color: colorOne,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),

                          // Barcode Number
                          Card(
                              child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      filled: true,
                                      focusColor: colorThree,
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorThree)),
                                      prefixIcon: Icon(
                                        Icons.numbers,
                                        size: 20.0,
                                        color: Colors.black54,
                                      ),
                                      prefixIconColor: Colors.black54,
                                      border: UnderlineInputBorder(),
                                      labelText: 'Barcode Number'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter valid barcode";
                                    } else if (!RegExp(r'^[0-9]{4,6}$')
                                            .hasMatch(value) ||
                                        value.length < 3) {
                                      return "Barcode should have 4 - 6 number";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) => {barcode = value},
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.abc,
                                        size: 20.0,
                                        color: Colors.black54,
                                      ),
                                      border: UnderlineInputBorder(),
                                      filled: true,
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                      labelText: 'Name'),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !RegExp(r'^[a-z A-Z]+$')
                                            .hasMatch(value) ||
                                        value.length < 3) {
                                      return "Enter valid item name";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) => {name = value},
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: size.width * 0.8,
                                child: DottedBorder(
                                    color: Colors.black,
                                    strokeWidth: 1,
                                    child: Center(
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                            backgroundColor: Colors.white),
                                        child: _hasImageFile
                                            ? AspectRatio(
                                                aspectRatio: 1 / 1,
                                                child: _imageContainer(),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 25),
                                                child: Column(
                                                  children: const [
                                                    Icon(
                                                      Icons.image,
                                                      size: 75,
                                                      color: colorThree,
                                                    ),
                                                    Text(
                                                      'Select an image',
                                                      style: TextStyle(
                                                          color: colorThree),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        onPressed: () async {
                                          await _onSelectImagePressed();
                                        },
                                      ),
                                    )),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0, top: 20.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Wholesale Price:',
                                        ),
                                        Text(
                                          ' £ ${_wholesaleSliderValue.round()}',
                                          style: const TextStyle(
                                            color: colorThree,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Slider(
                                      value: _wholesaleSliderValue,
                                      activeColor: colorThree,
                                      inactiveColor: Colors.grey,
                                      max: 30.0,
                                      min: 1.0,
                                      divisions: 29,
                                      label:
                                          "£ ${_wholesaleSliderValue.round().toString()}",
                                      onChanged: (double value) {
                                        setState(() {
                                          _wholesaleSliderValue = value;
                                        });
                                      })
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0, top: 20.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Retail Price:',
                                        ),
                                        Text(
                                          ' £ ${_retailSliderValue.round()}',
                                          style: const TextStyle(
                                            color: colorThree,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Slider(
                                      value: _retailSliderValue,
                                      activeColor: colorThree,
                                      inactiveColor: Colors.grey,
                                      max: 30.0,
                                      min: 1.0,
                                      divisions: 29,
                                      label:
                                          "£ ${_retailSliderValue.round().toString()}",
                                      onChanged: (double value) {
                                        setState(() {
                                          _retailSliderValue = value;
                                        });
                                      })
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0, top: 20.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Quantity:',
                                        ),
                                        Text(
                                          ' ${_quantitySliderValue.round()}',
                                          style: const TextStyle(
                                            color: colorThree,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Slider(
                                      value: _quantitySliderValue,
                                      activeColor: colorThree,
                                      inactiveColor: Colors.grey,
                                      max: 100.0,
                                      min: 1.0,
                                      divisions: 99,
                                      label:
                                          " ${_quantitySliderValue.round().toString()}",
                                      onChanged: (double value) {
                                        setState(() {
                                          _quantitySliderValue = value;
                                        });
                                      })
                                ],
                              ),
                            ],
                          )),

                          const SizedBox(
                            height: 10.0,
                          ),

                          // Add Item button
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shadowColor: colorOne,
                                      primary: colorThree,
                                      padding: const EdgeInsets.all(20.0)),
                                  onPressed: () => addItems(),
                                  child: _isLoading
                                      ? const SpinKitCircle(
                                          color: Colors.white,
                                          size: 20.0,
                                        )
                                      : const Text(
                                          'Add Item',
                                          style: TextStyle(color: Colors.white),
                                        ))),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageContainer() {
    // try {
    //   if (Platform.isAndroid) {
    //     return Image.file(File(_selectedImage!.path));
    //   } else if (Platform.isWindows) {
    //     return Text(_selectedImage!.path);
    //   } else {
    //     return Text(_selectedImage!.path);
    //   }
    // } catch (e) {
    //   return Image.memory(_uInt8Image!);
    // }

    return Image.memory(_uInt8Image!);
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'COMPLETE ACTION USING',
        style: TextStyle(fontSize: 15.0),
      ),
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 75.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: colorSeven),
              onPressed: () {
                _openImageProvider(context, 'camera');
              },
              child: Container(
                height: 75.0,
                width: 50.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    alignment: FractionalOffset.center,
                    image: NetworkImage(cameraIcon),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: colorSeven),
              onPressed: () {
                _openImageProvider(context, 'gallery');
              },
              child: Container(
                height: 75.0,
                width: 50.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    alignment: FractionalOffset.center,
                    image: NetworkImage(galleryIcon),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Close',
            style: TextStyle(color: colorThree),
          ),
        ),
      ],
    );
  }

  void _openImageProvider(BuildContext context, String platform) async {
    final XFile? selectedImage;
    if (platform == 'camera') {
      selectedImage = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxHeight: 400,
          maxWidth: 400,
          imageQuality: 40);
    } else {
      selectedImage = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxHeight: 400,
          maxWidth: 400,
          imageQuality: 40);
    }

    String? _path = selectedImage?.path;
    File file = File(_path!);
    // var _url = _uploadImage(file);
    Uint8List bytes = file.readAsBytesSync();

    setState(() {
      _selectedImage = file;
      _uInt8Image = bytes;
      _hasImageFile = true;
    });
    Navigator.pop(context);
  }

  // void _openGallery(BuildContext context) async {
  //   final selectedFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //   );
  //   String? _path = selectedFile?.path;
  //   File file = File(_path!);

  //   Uint8List bytes = file.readAsBytesSync();
  //   setState(() {
  //     _selectedImage = file;
  //     _uInt8Image = bytes;
  //   });

  //   Navigator.pop(context);
  // }

  // Future _uploadImage(File imageToUpload) async {
  //   // if (_selectedImage == null) return ;
  //   const _imgName = 'hello';
  //   const _imgLocation = 'uploads/$_imgName';

  //   // var _imageUpload = () async {
  //   //   try {
  //   //     final firebaseReference =
  //   //         await FirebaseStorage.instance.ref(_imgLocation);
  //   //     return firebaseReference.putFile(_selectedImage!);
  //   //   } on FirebaseException catch (e) {
  //   //     print(e);
  //   //     return e;
  //   //   }
  //   // };

  //   // if (_imageUpload == null) {
  //   //   return;
  //   // }
  //   final snapshot = await _uploadTask?.whenComplete(() => null);
  //   final _imageURL = await snapshot?.ref.getDownloadURL();
  //   print(_imageURL);
  //   return _imageURL;
  // }

  _onSelectImagePressed() async {
    try {
      if (Platform.isAndroid) {
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context));
      } else {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          File file = File(result.files.single.path ?? '');
          Uint8List? webFile = result.files.single.bytes;
          setState(() {
            _selectedImage = file;
            _uInt8Image = webFile;
          });
        }
      }
    } catch (e) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        Uint8List? webFile = result.files.single.bytes;

        File file = File.fromRawPath(webFile!);
        setState(() {
          _uInt8Image = webFile;
          _selectedImage = file;
        });
      }
    }
  }

  void _resetData() {
    setState(() {
      name = null;
      barcode = null;
      _isLoading = false;
      _hasImageFile = false;
      _wholesaleSliderValue = 15.0;
      _retailSliderValue = 15.0;
      _quantitySliderValue = 50.0;
    });
  }

  addItems() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      ItemsHelper itemsHelper = ItemsHelper('$baseURL/items/add');

      var itemsData = await itemsHelper.addItems(
          int.parse(barcode!),
          name!,
          _wholesaleSliderValue,
          _retailSliderValue,
          _quantitySliderValue.round(),
          _selectedImage!);

      if (itemsData == 200) {
        _formKey.currentState!.reset();
        _resetData();
      }
    }
  }
}
