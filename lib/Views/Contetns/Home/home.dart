import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthealthcare/Models/DB/User.dart';
import 'package:smarthealthcare/Models/Strings/app.dart';
import 'package:smarthealthcare/Models/Utils/Colors.dart';
import 'package:smarthealthcare/Models/Utils/Common.dart';
import 'package:smarthealthcare/Models/Utils/FirebaseStructure.dart';
import 'package:smarthealthcare/Models/Utils/Images.dart';
import 'package:smarthealthcare/Models/Utils/Utils.dart';
import 'package:smarthealthcare/Views/Contetns/Home/drawer.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  dynamic dataLive = null;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getData();
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
                              Visibility(
                                  visible: CustomUtils.loggedInUser!.type ==
                                      LoggedUser.USER,
                                  child: GestureDetector(
                                    onTap: () {
                                      enrollForQR();
                                    },
                                    child: Icon(
                                      Icons.input_outlined,
                                      color: colorWhite,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      )),
                  Expanded(
                      flex: CustomUtils.loggedInUser!.type == LoggedUser.DOCTOR
                          ? 1
                          : 0,
                      child: Center(
                        child: SizedBox(
                            width: displaySize.width * 0.8,
                            child: Image.asset(homeImage)),
                      )),
                  if (dataLive != null)
                    getLiveTile(Icons.person_2_outlined, "BMI",
                        dataLive['body-bmi-val'] ?? '',
                        symbol: 'bmi'),
                  if (dataLive != null)
                    getLiveTile(
                        Icons.line_weight_outlined,
                        "BMI Status",
                        (dataLive['body-bmi-sta'] ?? '')
                            .toString()
                            .toUpperCase()),
                  if (dataLive != null)
                    getLiveTile(Icons.monitor_heart_outlined, "BPM",
                        dataLive['body-bpm'] ?? '',
                        symbol: 'bpm'),
                  if (dataLive != null)
                    getLiveTile(Icons.height_outlined, "Height",
                        dataLive['body-hight'] ?? '',
                        symbol: 'm'),
                  if (dataLive != null)
                    getLiveTile(Icons.monitor_weight_outlined, "Weight",
                        dataLive['body-weight'] ?? '',
                        symbol: 'g'),
                  if (dataLive != null)
                    getLiveTile(Icons.thermostat_auto_outlined, "Temperature",
                        dataLive['body-temp'] ?? '',
                        symbol: '°C')
                ],
              )),
        ));
  }

  void getData() {
    _databaseReference
        .child(FirebaseStructure.LIVEDATA)
        .child(CustomUtils.loggedInUser!.uid)
        .onValue
        .listen((DatabaseEvent data) async {
      setState(() {
        dataLive = data.snapshot.value;
      });
    });
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

  Widget getLiveTile(IconData icon, String title, dynamic value,
      {String? symbol,
      int type = 0,
      void Function(int?)? onToggle,
      void Function(double)? onChangeEnd,
      int expandedFlex = 1}) {
    return Expanded(
        flex: expandedFlex,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ListTile(
                    leading: Icon(
                      icon,
                      color: colorPrimary,
                      size: displaySize.width * 0.08,
                    ),
                    title: Text(
                      title.toString(),
                      style: TextStyle(
                          color: color15,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0),
                    ),
                    subtitle: (type == 2)
                        ? Slider(
                            activeColor: colorPrimary,
                            inactiveColor: colorGrey,
                            value: value.toDouble(),
                            max: 100,
                            divisions: 100,
                            onChangeEnd: onChangeEnd,
                            onChanged: (double value) {},
                          )
                        : null,
                    trailing: ((type == 1)
                        ? ToggleSwitch(
                            activeBgColor: [colorPrimary],
                            initialLabelIndex: value ? 1 : 0,
                            totalSwitches: 2,
                            labels: const ['OFF', 'ON'],
                            onToggle: onToggle,
                          )
                        : Text(
                            '$value ${symbol ?? ''}',
                            style: TextStyle(
                                color: color15,
                                fontWeight: FontWeight.w400,
                                fontSize: 18.0),
                          ))),
              ),
            ),
          ),
        ));
  }

  Future<void> enrollForQR() async {
    _databaseReference
        .child(FirebaseStructure.QR)
        .set({'isNew': true, 'user': CustomUtils.loggedInUser!.uid}).then(
            (value) => CustomUtils.showSnackBar(context,
                "Enrollment Successfull", CustomUtils.SUCCESS_SNACKBAR));
  }
}
