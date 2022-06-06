import 'package:flutter/material.dart';

class ConfirmDialog extends AlertDialog {
  ConfirmDialog(BuildContext context)
      : super(
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
