import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiflutter/model/tcpconnection.dart';
import 'package:quiflutter/model/datamodel.dart';
import 'package:quiflutter/components/rrfloatingbutton.dart';
import 'package:quiflutter/style/styles.dart';
import 'package:quiflutter/components/teamlistitem.dart';
import 'dialogs/confirmdialog.dart';
import 'dialogs/newteamdialog.dart';
import 'model/netconnection.dart';

//------------------------ ROOT STATEFUL WUDGET --------------------------------
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//--------------------------  Root state  --------------------------------------
class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{
  NetConnection connection = NetConnection();
  DataModel dataModel = DataModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // First load all data
    dataModel.loadData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // Save all data before exit
    dataModel.saveData();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    if (state == AppLifecycleState.paused){
      // if the App is paused save all data
      dataModel.saveData();
    } else if(state == AppLifecycleState.resumed){
      // if the App is resumed load all data
      dataModel.loadData();
    }
    super.didChangeAppLifecycleState(state);
  }
//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NetConnection>.value(value: connection),
        ChangeNotifierProvider<DataModel>.value(value: dataModel),
      ],
      child: Consumer<NetConnection>(
        builder: (context, connection, child) {
          return Consumer<DataModel>(
            builder: (context, data, child) {
              return Scaffold(
                backgroundColor: quizMainBackColor,
                appBar: AppBar(
                  actions: [

                    // ---------------  'Connect' button  ----------------------
                    RoundedRectangleFloatingButton(
                      child: connection.connected
                          ? Icon(Icons.wifi_tethering_sharp, color: quizListTextColor,)
                          : Icon(Icons.portable_wifi_off, color: quizListTextColor,),
                      onPressed: ()  {connection.searchIP();},//-------------------------------  CONNECT  ------------------------------------
                    ),

                    // ---------------  'Clear all' button  ----------------------
                    RoundedRectangleFloatingButton(
                      child: Icon(Icons.clear, color: quizListTextColor,),
                      onPressed: () async {
                        if (await showConfirmDialog(context, null, 'Clear all', 'Are you shure?')) data.clearAll();
                      },
                    ),

                    // ---------------  'Load all' button  ----------------------
                    RoundedRectangleFloatingButton(
                      child: Icon(Icons.folder, color: quizListTextColor,),
                      onPressed: () async {
                        if (await showConfirmDialog(context, null, 'Load table', 'Load last saved table?'))  data.loadData();
                      },
                    ),

                    // ---------------  'Save all' button  ----------------------
                    RoundedRectangleFloatingButton(
                      child: Icon(Icons.save, color: quizListTextColor,),
                      onPressed: () async {
                        if (await showConfirmDialog(context, null, 'Save table', 'Save changes?'))  data.saveData();
                      },
                    )

                  ],
                  title: Text( widget.title,
                    style: TextStyle(
                        color: quizListTextColor,
                        backgroundColor: quizMainPanelColor),
                  ),
                  //centerTitle: true,
                ),

                // -------------------------  Team List  -----------------------
                body: Container(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        //-------- One Team Item  ------
                        return Dismissible(
                          // Confirm deleting Team
                          confirmDismiss: (direction) => showConfirmDialog(context, direction,  'Delete team ${data.getTeam(index).teamName}', 'Are you shure?'),
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
                    onPressed: () {},//--------------------------------  FULLSCREEN  ------------------------------------
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
