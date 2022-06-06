import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(BuildContext context, DismissDirection direction) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Team'),
          content: Text('Are you shure?'),
          actions: [
            TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                }),
            TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                })
          ],
        );
      }
  );
}
