import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:photo_view/photo_view.dart';
import 'package:rapidoc_utils/alerts/alert_vertical_widget.dart';
import 'package:rapidoc_utils/lang/lang.dart';
import 'package:shared_preferences/shared_preferences.dart';

const LOC_STORAGE_KEY = 'image';

class ImageFilePreviewRoute extends StatefulWidget {
  final String? path;
  ImageFilePreviewRoute({
    Key? key,
    this.path,
  }) : super(key: key);

  @override
  _ImageFilePreviewRouteState createState() => _ImageFilePreviewRouteState();
}

class _ImageFilePreviewRouteState extends State<ImageFilePreviewRoute> {
  String? imagePath;

  Uint8List? _uint8list;
  @override
  void initState() {
    imagePath = widget.path;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lang = appLocalizationsWrapper.lang;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (!kIsWeb)
            TextButton(
              onPressed: () => crop(context),
              child: Row(
                children: [Icon(Icons.crop), SizedBox(width: 10), Text(lang.edit)],
              ),
            ),
          TextButton(
            onPressed: () => pop(context),
            child: Row(
              children: [Icon(Icons.done), SizedBox(width: 10), Text(lang.ok)],
            ),
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder<dynamic>(
            future: readImageData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var data = snapshot.data;
                if (data == null) {
                  return Center(
                    child: AlertVerticalWidget.createDanger(lang.readErrorMessage),
                  );
                }
                if (data is String) {
                  return PhotoView(imageProvider: FileImage(File(data)));
                } else {
                  return PhotoView(imageProvider: MemoryImage(data));
                }
              } else {
                return SizedBox.shrink();
              }
            }),
      ),
    );
  }

  Future<dynamic> readImageData() async {
    if (imagePath != null) {
      return imagePath;
    } else {
      _uint8list = await getImageFromLocalStorage();
      return _uint8list;
    }
  }

  void pop(context) {
    if (imagePath != null) {
      Navigator.of(context).pop(imagePath);
    } else {
      Navigator.of(context).pop(LOC_STORAGE_KEY);
    }
  }

  void crop(context) async {
    if (kIsWeb) {
      /**
       * Unsupported operation!
       */
    } else {
      File? croppedFile = await ImageCropper.cropImage(
        sourcePath: widget.path!,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Theme.of(context).textTheme.bodyText1!.color,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );
      if (croppedFile != null) {
        imagePath = croppedFile.path;
        setState(() {});
      }
    }
  }

  Future<Uint8List?> getImageFromLocalStorage() async {
    var prefs = await SharedPreferences.getInstance();
    String? base = prefs.getString(LOC_STORAGE_KEY);
    if (base != null) {
      return base64.decode(base.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), ''));
    }
    return null;
  }
}
