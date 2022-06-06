import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiflutter/style/styles.dart';

import '../model/datamodel.dart';

class TeamListItem extends StatelessWidget {
  const TeamListItem({Key key, this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final DataModel teamList = Provider.of<DataModel>(context);
    Color bkcolor;
    switch (teamList.isMaxMin(index)){
      case -1:
        bkcolor = quizLowScoreColor;
        break;
      case 1:
        bkcolor = quizHighScoreColor;
        break;
      default:
        bkcolor = quizMiddleScoreColor;
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
        title: Row(
          children: [
            Text(
              '${index + 1}: ',
              style: middleFont,
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
        leading: IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {teamList.decrementTeamScore(index);},
        ),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {teamList.incrementTeamScore(index);},
        ),
        tileColor: bkcolor,
      ),
    );
  }
}
