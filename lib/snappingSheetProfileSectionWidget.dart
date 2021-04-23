import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/authRepo.dart';

class ProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final email = AuthRepository.instance().user!.email;
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
                        './assets/images/leedleleedle.jpg'
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
                  onPressed: () => print('NICO'),
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
