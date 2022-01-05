import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color color;

  const Badge({
    Key? key,
    required this.child,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              right: 8,
              top: 5,
              child: Container(
                padding: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.amber,
                ),

                constraints: BoxConstraints(
                  minHeight: 16,
                  minWidth: 16,
                ),
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.adamina(
                      fontWeight: FontWeight.bold, fontSize: 10,),
                ),
              )),
          child
        ],
      );
  }
}
