import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/authRepo.dart';

class ProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(width: 10,),
          // todo:: add image
          SizedBox(width: 10,),
          Column(
            children: [
              Text('fun is fun'),
              ElevatedButton(
                  onPressed: null,
                  child: Text('Change Avatar')
              )
            ],
          )
        ],
      ),
    );
  }
}
