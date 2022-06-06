import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiflutter/model/connectionmodel.dart';
import 'package:quiflutter/model/datamodel.dart';
import 'package:quiflutter/components/rrfloatingbutton.dart';
import 'package:quiflutter/style/styles.dart';
import 'package:quiflutter/components/teamlistitem.dart';
import 'dialogs/confirmdialog.dart';
import 'dialogs/newteamdialog.dart';

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
                // -------------------------  Team List  -----------------------
                body: Container(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        //-------- One Team Item  ------
                        return Dismissible(
                          // Confirm deleting Team
                          confirmDismiss: (direction) => showConfirmDialog(context, direction),
                          // Deleting Team
                          onDismissed: (direction) { data.removeTeam(index); },
                          key: Key(data.getTeam(index).teamName),
                          child: TeamListItem(
                            index: index,
                          ),
                        );
                      }),
                ),
                persistentFooterButtons: [
                  // ------------------ 'Add New Team' button  -----------------
                  RoundedRectangleFloatingButton(
                    child: Icon(Icons.add, color: quizListTextColor,),
                    onPressed: () {
                      addNewTeam(context, data);
                    },
                  ),
                  // ------------------ 'Sort Team List' button  ---------------
                  RoundedRectangleFloatingButton(
                    child: Icon(Icons.sort, color: quizListTextColor,),
                    onPressed: () {data.sortByScores();},
                  ),
                  // -------------- 'Toggle Full screen' button  ---------------
                  RoundedRectangleFloatingButton(
                    child: Icon(Icons.fullscreen, color: quizListTextColor,),
                    onPressed: () {},
                  ),
                  // ---------------  'Clear all' button  ----------------------
                  RoundedRectangleFloatingButton(
                    child: Icon(Icons.clear, color: quizListTextColor,),
                    onPressed: () async {
                        if (await showConfirmDialog(context, null)) data.clearAll();
                      },
                  ),
                  RoundedRectangleFloatingButton(
                    child: Icon(Icons.folder, color: quizListTextColor,),
                    onPressed: () {data.loadData();},
                  ),
                  RoundedRectangleFloatingButton(
                    child: Icon(Icons.save, color: quizListTextColor,),
                    onPressed: () async { await data.saveData();},
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
