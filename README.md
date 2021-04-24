Answers for dry questions:

1.
The class used is SnappingSheetController, it allows the developer to control where the snapping
position is and  even stop the current snapping;

2.
the parameter which controls this behavior is the snappingPositions parameter which takes in a list
of SnappingPosition.factor or SnappingPosition.pixels. In those objects we can specify the duration
and the curve of the sheet.

3.
InkWell over GestureDetector: The InkWell is following the Material design pattern and automatically
shows splash when there is a tap. GestureDetector doesn't do so automatically.
GestureDetector over InkWell: The first is more general. The InkWell widget must have a Material
widget as an ancestor unlike GestureDetector.
