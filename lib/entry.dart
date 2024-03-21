import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://gtkzbgdcmazdbkgbkkss.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd0a3piZ2RjbWF6ZGJrZ2Jra3NzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDk3MzEwOTAsImV4cCI6MjAyNTMwNzA5MH0.Ixaek-MHcJ_ju7LrwAqoU3oYQpNUz0GXlwaphpJQK6o',
  );
  runApp(MyApp());
}

class CTAButton extends StatelessWidget {
  final double left;
  final double right;
  final double bottom;
  final String text;
  final Function()? onTap;
  final Color color;
  const CTAButton(
      {super.key,
      this.color = Colors.black,
      this.left = 100,
      this.right = 100,
      this.bottom = 0,
      required this.text,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: left, right: right, bottom: bottom),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: MyFormPage(),
    );
  }
}

class MyFormPage extends StatefulWidget {
  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;
  String name = "";
  String brand = "";
  String clr = "";
  String regnum = "";
  String type = "";

  @override
  Widget build(BuildContext context) {
    TextEditingController regno = TextEditingController();
    TextEditingController dname = TextEditingController();
    TextEditingController cbrand = TextEditingController();
    TextEditingController ccolour = TextEditingController();
    TextEditingController ctype = TextEditingController();
    TextEditingController phone = TextEditingController();

    void showErrorDialog(
      BuildContext context,
      String title,
      String message,
    ) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }

    void dispose() {
      regno.clear();
      dname.clear();
      cbrand.clear();
      ccolour.clear();
      ctype.clear();
      phone.clear();
    }

    saveProject() async {
      try {
        if (regno.text.isEmpty ||
            dname.text.isEmpty ||
            cbrand.text.isEmpty ||
            ccolour.text.isEmpty ||
            ctype.text.isEmpty ||
            phone.text.isEmpty) {
          showErrorDialog(
            context,
            'Oops, something went wrong',
            'Please fill in all the fields',
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => Container(
              color: Colors.blueGrey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Saving your data, this might take some time',
                    style: GoogleFonts.dmSerifDisplay(
                        fontWeight: FontWeight.w500, fontSize: 25),
                  )
                ],
              ),
            ),
          );
          var presponse = await supabase.from('vehicle_details').insert({
            'reg_num': regno.text.toString(),
            'driver_name': dname.text.toString(),
            'color': ccolour.text.toString(),
            'vehicle_type': ctype.text.toString(),
            'brand': cbrand.text.toString(),
            'phone_num': phone.text.toString()
          }).select();
          //clear the text fields after saving
          dispose();
          //pop the loading screen after loading

          Navigator.of(context).pop();
          if (presponse.isNotEmpty) {
            showErrorDialog(
                context, 'Successfully added Database🥳', 'Happy Coding');
          } else {
            showErrorDialog(context, 'Oops something went wrong 😭',
                'Make sure you have an active internet connection');
          }
        }
      } catch (e) {
        showErrorDialog(context, "Oops, something went wrong", e.toString());
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Data Entry page'),
        //theme: ThemeData(brightness: Brightness.dark),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: regno,
                decoration: InputDecoration(
                  labelText: 'reg_no',
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the registration num';
                  }
                  return null;
                },
                onSaved: (value) {
                  regnum = value!;
                },
              ),
              TextFormField(
                controller: dname,
                decoration: InputDecoration(
                  labelText: 'name',
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value!;
                },
              ),
              TextFormField(
                controller: cbrand,
                decoration: InputDecoration(
                  labelText: 'brand',
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the brand';
                  }
                  return null;
                },
                onSaved: (value) {
                  brand = value!;
                },
              ),
              TextFormField(
                controller: ccolour,
                decoration: InputDecoration(
                  labelText: 'colur',
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the color';
                  }
                  return null;
                },
                onSaved: (value) {
                  clr = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: ctype,
                decoration: InputDecoration(
                  labelText: 'type',
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the type';
                  }
                  return null;
                },
                onSaved: (value) {
                  type = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  filled: true,
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }

                  return null;
                },
              ),
              SizedBox(height: 16),
              SizedBox(height: 16),
              CTAButton(
                text: 'Save',
                onTap: () => saveProject(),
                left: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
