import 'package:flutter/material.dart';
import 'package:hello_me/authRepo.dart';

class GrabbingWidget extends StatelessWidget {
  final email = AuthRepository.instance().user!.email;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => print('tapped'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(blurRadius: 15, color: Colors.black.withOpacity(0.2)),
          ],
        ),
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('welcome back $email'),
            Icon(Icons.keyboard_arrow_up)
          ],
        ),
      ),
    );
  }
}
