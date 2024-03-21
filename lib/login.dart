import 'package:admin/screens/main/components/side_menu.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

void main() {
  runApp(MaterialApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Outpost management system',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.white,
        hintColor: Colors.white,
        scaffoldBackgroundColor: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Colors.white),
          prefixStyle: const TextStyle(color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> signInUser() async {
      try {
        final authResponse = await supabase.auth.signInWithPassword(
            password: passwordController.text, email: emailController.text);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content:
        //         Text("Logged in :${authResponse.user!.email!}")));
        if (authResponse == null) {
          print('Something went wrong');
        } else {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MainScreen(),
          ));
        }
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Outpost management system'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  'assets/images/52554.png', // Replace with your own image asset
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                )),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: 'E-mail id',
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Enter '),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 32),
            MaterialButton(
                onPressed: signInUser,
                // () async {
                //   final authResponse = await supabase.auth.signInWithPassword(
                //       password: passwordController.text,
                //       email: emailController.text);
                //   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //   //     content:
                //   //         Text("Logged in :${authResponse.user!.email!}")));
                //   if (authResponse != null) {
                //     Navigator.of(context).push(MaterialPageRoute(
                //       builder: (context) => MainScreen(),
                //     ));
                //   }
                // },
                child: Text("Sign in")),
          ],
        ),
      ),
    );
  }
}
