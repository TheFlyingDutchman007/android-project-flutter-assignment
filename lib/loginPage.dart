import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/userStateManagement.dart';
import 'package:provider/provider.dart';
import 'package:hello_me/authRepo.dart';

class LoginPage extends StatelessWidget {
  final saved;
  LoginPage(this.saved);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: LoginScreen(saved),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final saved;
  LoginScreen(this.saved);
  @override
  _LoginScreenState createState() => _LoginScreenState(saved);
}

class _LoginScreenState extends State<LoginScreen> {
  Set<WordPair> saved;
  _LoginScreenState(this.saved);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginErrorSnackBar =
      SnackBar(content: Text("There was an error logging into the app"));
  //final debugSnackBar = SnackBar(content: Text("logged in!!"));

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            Text(
              "Welcome to Startup Names Generator, please log in below",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  height: 1,
                  fontSize: 16),
            ),
            SizedBox(height: 45.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Email'),
            ),
            SizedBox(height: 45.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Password'),
            ),
            SizedBox(height: 45.0),
            Consumer<AuthRepository>(builder: (context, auth, _) {
              if (auth.status == Status.Authenticating) {
                return Center(child: CircularProgressIndicator());
              }
              return ElevatedButton(
                onPressed: () async {
                  if (await auth.signIn(emailController.text, passwordController.text)){
                    //await auth.signOut(); // hardcoded signOut for debug
                    final db = DatabaseService.instance();
                    final user = AuthRepository.instance().user;
                    for(WordPair w in saved){
                      db.addPair(user!, w);
                    }
                    Set<WordPair> fromDB = await db.getWords(user!);
                    saved.addAll(fromDB);
                    Navigator.of(context).pop();
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(loginErrorSnackBar);
                  }
                },
                child: Text('Log In'),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    minimumSize: MaterialStateProperty.all(Size(300, 45)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)))),
              );
            }),
            SizedBox(height: 45.0)
          ],
        ));
  }
}
