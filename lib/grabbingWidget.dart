import 'package:flutter/material.dart';
import 'package:hello_me/authRepo.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class GrabbingWidget extends StatelessWidget {
  final email = AuthRepository.instance().user!.email;
  final SnappingSheetController controller;
  GrabbingWidget(this.controller);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //print(controller.currentPosition); // for debugging
        if (controller.currentPosition > 135.854854 || controller.currentPosition <= 37.5) {
          controller.snapToPosition(
              SnappingPosition.factor(
                positionFactor: 0.2,
                snappingCurve: Curves.elasticOut,
                snappingDuration: Duration(milliseconds: 400)
              ));
        }
        else{
          controller.snapToPosition(
              SnappingPosition.pixels(
                  positionPixels: 37.5,
                  snappingCurve: Curves.elasticOut,
                  snappingDuration: Duration(milliseconds: 400)
              ));
        }
      },
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
