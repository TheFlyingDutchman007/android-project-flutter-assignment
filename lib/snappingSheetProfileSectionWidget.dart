import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/authRepo.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:hello_me/cloudStorageFunctions.dart';

class ProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = AuthRepository.instance().user!;
    final email = user.email;
    final storage = StorageService.instance();
    //final url = await storage.downloadURLofProfile(user);
    final url = null;
    //print(url);
    return Container(
      //margin: EdgeInsets.all(30),
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        children: [
          //SizedBox(width: 10,),
          Column(
            children: [
              Container(
                height: 70.0,
                width: 70.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        (url != null) // TODO: add default empty profile pic
                            ? url
                            : './assets/images/leedleleedle.jpg'
                    ),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                ),
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
                      if(result != null) {
                        File file = File(result.files.single.path!);
                        storage.uploadFile(file);
                      } else {
                        // User canceled the picker
                        final dismissedFilePicker = SnackBar(
                            content: Text("No image selected"));
                        ScaffoldMessenger.of(context).showSnackBar(dismissedFilePicker);
                      }
                    }catch (e){
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
