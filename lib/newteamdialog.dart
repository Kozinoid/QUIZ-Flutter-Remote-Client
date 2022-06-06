import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiflutter/datamodel.dart';

Function addNewTeam(BuildContext context, DataModel data) {
  TextEditingController _controller = TextEditingController();
  //----------------- Add New Team Dialog --------------
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Новая команда',
          ),
          content: Column(
            children: [
              TextField(
                controller: _controller,
              ),
              Text(''),
            ],
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
