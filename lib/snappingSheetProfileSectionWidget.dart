import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/authRepo.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:hello_me/cloudStorageFunctions.dart';

class ProfileSection extends StatefulWidget {

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  var url = "";

 @override
  void initState(){
    super.initState();
    getCurrentURL();
  }

  void getCurrentURL() async{
   final storage = StorageService.instance();
   final user = AuthRepository.instance().user!;
   try {
     String tempURL = await storage.downloadURLofProfile(user);
     setState(() {
       url = tempURL;
     });
   }
   catch (e){
     print(e);
   }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthRepository.instance().user!;
    final email = user.email;
    final storage = StorageService.instance();
    //final url = await storage.downloadURLofProfile(user);
    print("url!!!");
    print(url);
    return Container(
      //margin: EdgeInsets.all(30),
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        children: [
          //SizedBox(width: 10,),
          Column(
              children: [
                (url != "")
                    ? Container(
                  height: 70.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.scaleDown,
                    )
                  ),
                )
                : Container(
                    height: 70.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle
                    )
                ),
              ]),
          SizedBox(width: 20,),
          Column(
            children: [
              Text('$email',
                style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 18),), // TODO: style!!
              ElevatedButton(
                onPressed: () async {
                  try {
                    var result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      File file = File(result.files.single.path!);
                      await storage.uploadFile(file);
                      String temp = await storage.downloadURLofProfile(user);
                      setState(() {
                        url = temp;
                      });
                    } else {
                      // User canceled the picker
                      final dismissedFilePicker = SnackBar(
                          content: Text("No image selected"));
                      ScaffoldMessenger.of(context).showSnackBar(
                          dismissedFilePicker);
                    }
                  } catch (e) {
                    print(e);
                  }
                  //print('NICO');
                },
                child: Text('Change Avatar'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green[800]),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
