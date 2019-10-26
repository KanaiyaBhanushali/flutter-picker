import 'dart:io';

//import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_media_picker/fullter_media_picker.dart';
import 'package:flutter_media_picker/data/MediaFile.dart';

import 'PickerWidget.dart';

void main() => runApp(MaterialApp(
      title: "App",
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String selectText = "";

  @override
  void initState() {
    super.initState();
  }

  /*Future<bool> _checkPermission() async {
    final permissionStorageGroup =
        Platform.isIOS ? PermissionGroup.photos : PermissionGroup.storage;
    Map<PermissionGroup, PermissionStatus> res =
        await PermissionHandler().requestPermissions([
      permissionStorageGroup,
    ]);
    return res[permissionStorageGroup] == PermissionStatus.granted;
  }*/

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getMedia() async {
    try {
      List<MediaFile> imageMediaFileList = await FlutterMediaPicker.getImage();

      List<MediaFile> videoMediaFileList = await FlutterMediaPicker.getVideo();

      if (imageMediaFileList.length > 0) {
        MediaFile imageMedia = await FlutterMediaPicker.getMediaFile(
            fileId: imageMediaFileList[0].id, type: MediaType.IMAGE);
      }

      if (videoMediaFileList.length > 0) {
        MediaFile videoMedia = await FlutterMediaPicker.getMediaFile(
            fileId: videoMediaFileList[0].id, type: MediaType.VIDEO);
      }

      if (imageMediaFileList.length > 0) {
        String imageMedia = await FlutterMediaPicker.getThumbnail(
            fileId: imageMediaFileList[0].id, type: MediaType.IMAGE);
      }

      if (videoMediaFileList.length > 0) {
        String videoMedia = await FlutterMediaPicker.getThumbnail(
            fileId: videoMediaFileList[0].id, type: MediaType.VIDEO);
      }
    } on Exception {
      print("Exception");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
                child: const Text("Show All Media"),
                onPressed: () {
                  FlutterMediaPicker.getAll().then((mediaFiles) {
                    //print(mediaFiles);
                    _awaitReturnValueFromSecondScreen(context, mediaFiles);
                  });
                }),
            RaisedButton(
                child: const Text("Show Image Media"),
                onPressed: () {
                  FlutterMediaPicker.getImage().then((mediaFiles) {
                    //print(mediaFiles);
                    _awaitReturnValueFromSecondScreen(context, mediaFiles);
                  });
                }),
            RaisedButton(
                child: const Text("Show Video Media"),
                onPressed: () {
                  FlutterMediaPicker.getVideo().then((mediaFiles) {
                    //print(mediaFiles);
                    _awaitReturnValueFromSecondScreen(context, mediaFiles);
                  });
                }),
            Text("$selectText")
          ],
        ),
      ),
    );
  }

  void _awaitReturnValueFromSecondScreen(
      BuildContext context, List<MediaFile> mediaFiles) async {
    // start the SecondScreen and wait for it to finish with a result
    Set<MediaFile> result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PickerWidget(mediaFiles),
        ));

    // after the SecondScreen result comes back update the Text widget with it

    if (result == null) {
      return;
    }

    setState(() {
      int size = result.length;
      selectText = "Selected Media Size $size";
    });
  }
}
