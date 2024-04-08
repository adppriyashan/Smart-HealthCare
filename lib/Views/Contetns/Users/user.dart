import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smarthealthcare/Models/Utils/Colors.dart';
import 'package:smarthealthcare/Models/Utils/Common.dart';
import 'package:smarthealthcare/Models/Utils/FirebaseStructure.dart';
import 'package:smarthealthcare/Models/Utils/Routes.dart';
import 'package:smarthealthcare/Models/Utils/Utils.dart';
import 'package:smarthealthcare/Views/Contetns/History/history.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final double topSpace = displaySize.width * 0.4;

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  List<dynamic> list = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorWhite,
      body: SizedBox(
          width: displaySize.width,
          height: displaySize.height,
          child: Column(
            children: [
              Expanded(
                  flex: 0,
                  child: Container(
                    decoration: BoxDecoration(color: colorPrimary),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 18.0, bottom: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: colorWhite,
                            ),
                          ),
                          Text(
                            "Users",
                            style: GoogleFonts.nunitoSans(
                                fontSize: 18.0, color: colorWhite),
                          ),
                          GestureDetector(
                            onTap: () => getData().then((value) =>
                                CustomUtils.showSnackBar(
                                    context,
                                    "Refreshing list",
                                    CustomUtils.DEFAULT_SNACKBAR)),
                            child: Icon(
                              Icons.refresh_outlined,
                              color: colorWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(
                height: 5.0,
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              for (var rec in list)
                                ListTile(
                                    leading: Icon(
                                      Icons.person_2_outlined,
                                      color: colorPrimary,
                                      size: 35.0,
                                    ),
                                    title: Text(
                                      rec['value']['name'],
                                      style: TextStyle(
                                          color: colorPrimary,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.0),
                                    ),
                                    subtitle: Text(
                                      rec['value']['email'],
                                      style: GoogleFonts.nunitoSans(
                                          color: color8, fontSize: 12.0),
                                    ),
                                    trailing: IconButton(
                                        onPressed: () =>
                                            Routes(context: context)
                                                .navigate(History(
                                              user: rec['key'],
                                            )),
                                        icon: Icon(Icons.history_outlined,
                                            color: color15)))
                            ]),
                      ),
                    ),
                  ))
            ],
          )),
    ));
  }

  Future<void> getData() async {
    _databaseReference
        .child(FirebaseStructure.USERS)
        .orderByChild("type")
        .equalTo(2)
        .once()
        .then((DatabaseEvent data) {
      list.clear();
      for (DataSnapshot element in data.snapshot.children) {
        list.add({'key': element.key, 'value': element.value});
      }
      setState(() {});
    });
  }

  String getDateTime(int mills) {
    return DateFormat('yyyy/MM/dd hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(mills));
  }
}
