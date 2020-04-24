import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff142850),
      child: Center(
        child: SpinKitDoubleBounce(
          color : const Color(0xff00a8cc),
          size: 60.0,
        )
      )
    );
  }
}