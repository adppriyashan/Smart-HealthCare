import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:smarthealthcare/Models/Utils/Colors.dart';
import 'package:smarthealthcare/Models/Utils/Common.dart';
import 'package:smarthealthcare/Models/Utils/FirebaseStructure.dart';
import 'package:smarthealthcare/Models/Utils/Images.dart';
import 'package:smarthealthcare/Models/Utils/Routes.dart';
import 'package:intl/intl.dart';
import 'package:smarthealthcare/Views/Widgets/custom_button.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../Widgets/custom_text_datetime_chooser.dart';

class DropMode extends StatefulWidget {
  const DropMode({Key? key}) : super(key: key);

  @override
  State<DropMode> createState() => _DropModeState();
}

class _DropModeState extends State<DropMode> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: color7,
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
                                onTap: () {
                                  Routes(context: context).back();
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: colorWhite,
                                ),
                              ),
                              Text(
                                "Drop Mode",
                                style: TextStyle(fontSize: 16.0, color: color7),
                              ),
                              GestureDetector(
                                onTap: () async {},
                                child: Icon(
                                  Icons.refresh,
                                  color: colorWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GifView.asset(
                            droneDropImg,
                            height: displaySize.width * 0.8,
                            width: displaySize.width * 0.8,
                            frameRate: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 45.0, vertical: 20.0),
                            child: CustomButton(
                              buttonText: "Take Down Drone",
                              textColor: color6,
                              backgroundColor: colorPrimary,
                              isBorder: false,
                              borderColor: color6,
                              onclickFunction: () {},
                            ),
                          )
                        ],
                      ))
                ],
              )),
        ));
  }
}
