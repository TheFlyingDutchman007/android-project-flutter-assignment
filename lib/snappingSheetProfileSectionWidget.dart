import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              Text('fun is fun',), // TODO: style!!
              ElevatedButton(
                  onPressed: () => print('NICO'),
                  child: Text('Change Avatar')
              )
            ],
          )
        ],
      ),
    );
  }
}
