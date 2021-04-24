import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/userStateManagement.dart';
import 'package:provider/provider.dart';
import 'package:hello_me/authRepo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      resizeToAvoidBottomInset: false,
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
  final passwordConfirmController = TextEditingController();
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
            SizedBox(height: 35.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Email'),
            ),
            SizedBox(height: 35.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Password'),
            ),
            SizedBox(height: 35.0),
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
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
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
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => showModalBottomSheet<dynamic>(
                  context: context,
                  builder: (BuildContext context){
                    return Wrap(
                      children: [Container(
                        padding: EdgeInsets.all(15),
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(height: 10,),
                            Text('Please confirm your password below'),
                            Divider(thickness: 2.5, color: Colors.black54),
                            SizedBox(height: 12.5,),
                            TextField(
                              controller: passwordConfirmController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'password'
                              ),
                            ),
                            SizedBox(height: 12.5,),
                            ElevatedButton(
                                onPressed: () async{
                                  final auth = AuthRepository.instance();
                                  final db = FirebaseFirestore.instance;
                                  if (passwordController.text == passwordConfirmController.text
                                  && passwordController.text.isNotEmpty){
                                    await auth.signUp(emailController.text, passwordController.text);
                                    db.collection('users').doc(auth.user!.uid).set(
                                      {
                                        "email" : auth.user!.email,
                                        "words" : []
                                      }
                                    );
                                    //print("Statusssss");
                                    //print(auth.status);
                                    //File file =File('assets/images/noImage.png');
                                    //StorageService.instance().uploadFile(file);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  }
                                  else{
                                    // TODO: fix hidden snackBar or do something else
                                    final errorMatch = SnackBar(
                                        content: Text(
                                            "Passwords must match"));
                                    FocusScope.of(context).unfocus();
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(errorMatch);
                                  }
                                },
                                child: Text('Confirm'),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.green[400]),
                                  //minimumSize: MaterialStateProperty.all(Size(300, 45)),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)))),
                            )
                          ],
                        ),
                      ),]
                    );
                  }),
              child: Text('New user? Click to sign up'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green[400]),
                  minimumSize: MaterialStateProperty.all(Size(300, 45)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)))),
            )
          ],
        ));
  }
}
