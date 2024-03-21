import 'package:admin/checkpost.dart';
import 'package:admin/entry.dart';
import 'package:admin/staff.dart';
import 'package:admin/vehicle.dart';
import 'package:flutter/material.dart';

class MyFiles extends StatelessWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttons =
        ElevatedButton.styleFrom(minimumSize: Size(700, 60));
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
            ),
            ElevatedButton(
                style: buttons,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => MyFormPage())));
                },
                child: Text('DATA ENTRY')),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: buttons,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => vehicle())));
                },
                child: Text('VEHICLE DETAILS')),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: buttons,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => staff())));
                },
                child: Text('STAFF DETAILS')),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: buttons,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => checkpost())));
                },
                child: Text('CHECKPOST DETAILS'))
          ],
        ),
      ],
    );
  }
}
