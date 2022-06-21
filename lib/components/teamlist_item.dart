import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiflutter/style/styles.dart';

import '../model/data_model.dart';

class TeamListItem extends StatelessWidget {
  const TeamListItem({Key key, this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final DataModel teamList = Provider.of<DataModel>(context);
    Color backColor;
    switch (teamList.isMaxMin(index)){
      case -1:
        backColor = quizLowScoreColor;
        break;
      case 1:
        backColor = quizHighScoreColor;
        break;
      default:
        backColor = quizMiddleScoreColor;
    }
    return Card(
      shape: RoundedRectangleBorder(
        side:
        BorderSide(color: Colors.black, width: 1.0),
        borderRadius:
        BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: EdgeInsets.all(0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 3.0),
        title: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '${index + 1}.',
                style: smallFont,
              ),
            ),
            Text(
              '${teamList.getTeam(index).teamName}',
              style: middleFont,
            ),
          ],
        ),
        subtitle: Text(
          '${teamList.getTeam(index).teamScore}',
          textAlign: TextAlign.center,
          style: bigFont,
        ),
        leading: TextButton(
          //icon: Icon(Icons.remove, color: quizMainTextColor,),
          child: Text('-', style: bigFont,),
          onPressed: () {
            teamList.decrementTeamScore(index);
            },
        ),
        trailing: TextButton(
          //icon: Icon(Icons.add, color: quizMainTextColor, ),
          child: Text('+', style: bigFont,),
          onPressed: () {
            teamList.incrementTeamScore(index);
            },
        ),
        tileColor: backColor,
      ),
    );
  }
}
