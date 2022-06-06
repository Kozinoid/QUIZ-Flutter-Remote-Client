import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiflutter/datamodel.dart';
import 'package:quiflutter/styles.dart';

Function addNewTeam(BuildContext context, DataModel data) {
  // Text edit controller to read new Team Name
  TextEditingController _controller = TextEditingController();

  //----------------- Add New Team Dialog --------------
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Новая команда',
          ),
          content: Container(
            width:  200.0,
            height: 150.0,
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _controller,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                ),
                Text('', style: middleFont),
              ],
            ),
          ),
          actions: [
            TextButton(
                child: Text('Yes'),
                onPressed: () {
                  if (data.addNewTeam(name: _controller.text)) {
                    Navigator.pop(context);
                  }
                }),
            TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        );
      });
}
