import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiflutter/connectionmodel.dart';
import 'package:quiflutter/datamodel.dart';
import 'package:quiflutter/rrfloatingbutton.dart';
import 'package:quiflutter/styles.dart';
import 'package:quiflutter/teamlistitem.dart';
import 'confirmdialog.dart';
import 'newteamdialog.dart';

//------------------------ ROOT STATEFUL WUDGET --------------------------------
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//--------------------------  Root state  --------------------------------------
class _MyHomePageState extends State<MyHomePage> {
  ConnectionModel connection = ConnectionModel();
  DataModel dataModel = DataModel();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConnectionModel>.value(value: connection),
        ChangeNotifierProvider<DataModel>.value(value: dataModel),
      ],
      child: Consumer<ConnectionModel>(
        builder: (context, connection, child) {
          return Consumer<DataModel>(
            builder: (context, data, child) {
              return Scaffold(
                backgroundColor: quizMainBackColor,
                appBar: AppBar(
                  title: Text(
                    widget.title,
                    style: TextStyle(
                        color: quizListTextColor,
                        backgroundColor: quizMainPanelColor),
                  ),
                  centerTitle: true,
                ),
                body: Container(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          // Confirm deleting Team
                          confirmDismiss: (direction) async {
                            return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmDialog(context);
                                });
                          },
                          // Deleting Team
                          onDismissed: (direction) {
                            data.removeTeam(index);
                          },
                          key: Key(data.getTeam(index).teamName),
                          child: TeamListItem(
                            index: index,
                          ),
                        );
                      }),
                ),
                persistentFooterButtons: [
                  // ------------------ 'Add New Team' button  -----------------------
                  RoundedRectangleFloatingButton(
                    child: Icon(Icons.add, color: quizListTextColor,),
                    onPressed: () {
                      addNewTeam(context, data);
                    },
                  ),
                  RoundedRectangleFloatingButton(
                    child: Icon(Icons.sort, color: quizListTextColor,),
                    onPressed: () {data.sortByScores();},
                  ),
                  RoundedRectangleFloatingButton(
                    child: Icon(Icons.fullscreen, color: quizListTextColor,),
                    onPressed: () {},
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
