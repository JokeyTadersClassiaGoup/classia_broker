import 'package:flutter/material.dart';

class CompanyImage extends StatelessWidget {
  const CompanyImage({super.key});

  @override
  Widget build(BuildContext context) {
    var heightScreen = MediaQuery.of(context).size.height;

    return SizedBox(
      // height: heightScreen * 0.4,
      // width: heightScreen * 0.6,
      child: Image.asset(
        'assets/splash-2.png', // Corrected image path
        fit: BoxFit.fill,
        height: 80,
        // color: Colors.white,
      ),
    );
  }
}
