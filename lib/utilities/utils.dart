import 'package:flutter/material.dart';

showSpackSnackBar(String content, BuildContext context, Color color, IconData icon){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.down,
          showCloseIcon: true,
          margin: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20//MediaQuery.of(context).size.height -200
          ),
          backgroundColor: color,
          content: Container(
            // color: color,
            child: Row(
              children: [
                Icon(icon, color: Colors.white,),
                Flexible(child: Text(' $content', maxLines: 2, style: TextStyle(color: Colors.white),)),
              ],
            ),
          ))
  );
}