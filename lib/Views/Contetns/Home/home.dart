import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smarthealthcare/Models/Strings/app.dart';
import 'package:smarthealthcare/Models/Utils/Colors.dart';
import 'package:smarthealthcare/Models/Utils/Common.dart';
import 'package:smarthealthcare/Models/Utils/FirebaseStructure.dart';
import 'package:smarthealthcare/Models/Utils/Images.dart';
import 'package:smarthealthcare/Models/Utils/Utils.dart';
import 'package:smarthealthcare/Views/Contetns/Home/drawer.dart';
import 'package:smarthealthcare/Views/Widgets/custom_button.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:uuid/uuid.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  FilePickerResult? _filePicker;
  File? selectedFile;
  String? extension;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      initNotifications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: color7,
        drawer: HomeDrawer(),
        body: SafeArea(
          child: SizedBox(
              width: displaySize.width,
              height: displaySize.height,
              child: Column(
                children: [
                  Expanded(
                      flex: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 18.0, bottom: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => (_scaffoldKey
                                        .currentState!.isDrawerOpen)
                                    ? _scaffoldKey.currentState!.openEndDrawer()
                                    : _scaffoldKey.currentState!.openDrawer(),
                                child: Icon(
                                  Icons.menu_rounded,
                                  color: colorWhite,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: colorWhite,
                                    borderRadius: BorderRadius.circular(20.0)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 15.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: displaySize.width * 0.08,
                                      child: Image.asset(logo),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        "$app_name $app_quote",
                                        style: TextStyle(
                                            fontSize: 16.0, color: colorBlack),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  clearData();
                                },
                                child: Icon(
                                  Icons.refresh,
                                  color: colorWhite,
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        uploadImg,
                        width: displaySize.width * 0.8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 45.0, vertical: 5.0),
                        child: CustomButton(
                          buttonText: selectedFile != null
                              ? "Upload"
                              : "Choose Audio File",
                          textColor: color6,
                          backgroundColor: colorPrimary,
                          isBorder: false,
                          borderColor: color6,
                          onclickFunction: () {
                            if (selectedFile != null) {
                              upload();
                            } else {
                              showChooserType();
                            }
                          },
                        ),
                      )
                    ],
                  ))
                ],
              )),
        ));
  }

  void initNotifications() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        _databaseReference
            .child(FirebaseStructure.NOTIFY)
            .onValue
            .listen((DatabaseEvent data) async {
          dynamic noti = data.snapshot.value;
          if (noti['istrue'] == true) {
            AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: -1,
                    channelKey: 'emergency_smarthealthcare',
                    title: 'Notification',
                    body: noti['message'].toString()));

            await _databaseReference
                .child(FirebaseStructure.NOTIFY)
                .child('istrue')
                .set(false);
          }
        });
      }
    });
  }

  upload() async {
    CustomUtils.showLoader(context);
    final firebaseStorage = FirebaseStorage.instance;
    await Permission.audio.request();
    var snapshot = await firebaseStorage
        .ref()
        .child("${const Uuid().v1()}.$extension")
        .putFile(selectedFile!);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    await _databaseReference.child(FirebaseStructure.LIVEDATA).set({
      'istrue': true,
      'voice': downloadUrl,
    });
    CustomUtils.hideLoader(context);
    CustomUtils.showToast('Upload successfully.');
    setState(() {
      selectedFile = null;
    });
  }

  Future<void> showChooserType() async {
    _filePicker = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'ogg', 'flac']);
    setState(() {
      if (_filePicker != null) {
        extension = _filePicker!.files.single.extension;
        selectedFile = File(_filePicker!.files.single.path!);
      } else {
        selectedFile = null;
      }
    });
  }

  void clearData() {
    setState(() {
      selectedFile = null;
    });
  }
}
