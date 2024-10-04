import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class MemeDetailScreen extends StatefulWidget {
  final String name;
  final String imageUrl;

  MemeDetailScreen({required this.name, required this.imageUrl});

  @override
  _MemeDetailScreenState createState() => _MemeDetailScreenState();
}

class _MemeDetailScreenState extends State<MemeDetailScreen> {
  File? _editedImage;
  Future<void> _showPermissionDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Storage Permission"),
          content: Text("This app needs access to your storage to save edited images. Please allow access."),
          actions: [
            TextButton(
              child: Text("Decline"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Accept"),
              onPressed: () async {
                Navigator.of(context).pop();
                await _requestPermissions();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestPermissions() async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {

    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Storage permission is required to save images.'),
      ));
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _cropImage() async {
    await _showPermissionDialog();

    if (await Permission.storage.isGranted) {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: widget.imageUrl,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Edit Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Edit Image',
            minimumAspectRatio: 1.0,
          ),
        ],
      );

      if (croppedImage != null) {
        setState(() {
          _editedImage = File(croppedImage.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Image cropping was canceled.'),
        ));
      }
    }
  }

  Future<void> _saveImage() async {
    await _showPermissionDialog();

    if (_editedImage != null && await Permission.storage.isGranted) {
      await GallerySaver.saveImage(_editedImage!.path).then((bool? success) {
        if (success != null && success) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Image saved to gallery.'),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to save image.'),
          ));
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No image to save or permission denied.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          if (_editedImage == null)
            Image.network(widget.imageUrl)
          else
            Image.file(_editedImage!),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _cropImage,
                child: Text('Edit Image'),
              ),
              ElevatedButton(
                onPressed: _saveImage,
                child: Text('Save Image'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
