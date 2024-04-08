import 'package:flutter/material.dart';
import 'package:smarthealthcare/Controllers/AuthController.dart';
import 'package:smarthealthcare/Models/DB/User.dart';
import 'package:smarthealthcare/Models/Utils/Colors.dart';
import 'package:smarthealthcare/Models/Utils/Common.dart';
import 'package:smarthealthcare/Models/Utils/Images.dart';
import 'package:smarthealthcare/Models/Utils/Routes.dart';
import 'package:smarthealthcare/Models/Utils/Utils.dart';
import 'package:smarthealthcare/Views/Contetns/History/history.dart';
import 'package:smarthealthcare/Views/Contetns/Users/user.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({Key? key}) : super(key: key);

  AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: displaySize.width * 0.8,
      decoration: BoxDecoration(color: color6),
      child: ListView(
        children: [
          SizedBox(
            width: double.infinity,
            height: displaySize.height * 0.15,
            child: Container(
                decoration: BoxDecoration(color: colorPrimary),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 12.0, left: 15.0, right: 15.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60.0,
                          width: 60.0,
                          child: ClipOval(
                            child: Image.asset(
                              user,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  CustomUtils.loggedInUser!.name,
                                  style: TextStyle(
                                      color: color6,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  CustomUtils.loggedInUser!.email,
                                  style: TextStyle(
                                      color: color6,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                )),
          ),
          ListTile(
            onTap: () => Navigator.pop(context),
            tileColor: color6,
            leading: Icon(
              Icons.home_outlined,
              color: color15,
            ),
            title: Text(
              'Home',
              style: TextStyle(color: color15, fontWeight: FontWeight.w400),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: color15,
              size: 15.0,
            ),
          ),
          if (CustomUtils.loggedInUser!.type == LoggedUser.USER)
            ListTile(
              onTap: () => Routes(context: context).navigate(const History()),
              tileColor: color6,
              leading: Icon(
                Icons.history_outlined,
                color: color15,
              ),
              title: Text(
                'History',
                style: TextStyle(color: color15, fontWeight: FontWeight.w400),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color15,
                size: 15.0,
              ),
            ),
          if (CustomUtils.loggedInUser!.type == LoggedUser.DOCTOR)
            ListTile(
              onTap: () => Routes(context: context).navigate(const Users()),
              tileColor: color6,
              leading: Icon(
                Icons.group_work_outlined,
                color: color15,
              ),
              title: Text(
                'Users',
                style: TextStyle(color: color15, fontWeight: FontWeight.w400),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color15,
                size: 15.0,
              ),
            ),
          ListTile(
            onTap: () => _authController.logout(context),
            tileColor: color6,
            leading: Icon(
              Icons.logout_outlined,
              color: color15,
            ),
            title: Text(
              'Logout',
              style: TextStyle(color: color15, fontWeight: FontWeight.w400),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: color15,
              size: 15.0,
            ),
          ),
        ],
      ),
    );
  }
}
