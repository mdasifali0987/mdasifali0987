import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myshop/screens/orders_screen.dart';
import 'package:myshop/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              'Hello Few',
              style: GoogleFonts.kanit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1),
            ),
            automaticallyImplyLeading: false,
            elevation: 0,
          ),
          Divider(color: Colors.cyan, height: 1),
          ListTile(
              leading: Icon(
                Icons.shop,
                color: Colors.cyan,
              ),
              title: Text(
                'Shop',
                style: GoogleFonts.kanit(
                    color: Colors.cyan, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              }),
          Divider(
            color: Colors.cyan,
            height: 2,
            thickness: 2,
            endIndent: 8,
            indent: 8,
          ),
          ListTile(
              leading: Icon(
                Icons.payment,
                color: Colors.cyan,
              ),
              title: Text(
                'Orders',
                style: GoogleFonts.kanit(
                    color: Colors.cyan, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrderScreen.routeName);
              }),
          Divider(
            color: Colors.cyan,
            height: 2,
            thickness: 2,
            endIndent: 8,
            indent: 8,
          ),
          ListTile(
              leading: Icon(
                Icons.edit,
                color: Colors.cyan,
              ),
              title: Text(
                'Manage Products',
                style: GoogleFonts.kanit(
                    color: Colors.cyan, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              }),
          Divider(
            color: Colors.cyan,
            height: 2,
            thickness: 2,
            endIndent: 8,
            indent: 8,
          ),
        ],
      ),
    );
  }
}
