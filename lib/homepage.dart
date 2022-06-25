import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiflutter/components/drawer.dart';
import 'package:quiflutter/connection/net_connection.dart';
import 'package:quiflutter/model/data_model.dart';
import 'package:quiflutter/components/quiz_floating_button.dart';
import 'package:quiflutter/style/styles.dart';
import 'package:quiflutter/components/teamlist_item.dart';
import 'dialogs/confirm_dialog.dart';
import 'dialogs/new_team_dialog.dart';

//------------------------ ROOT STATEFUL WUDGET --------------------------------
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//--------------------------  Root state  --------------------------------------
class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  NetConnection netConnection;
  DataModel dataModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Init connection
    netConnection = NetConnection();
    // Init  data model
    dataModel = DataModel(connection: netConnection);
    // Init connection state listener
    netConnection.streamController.stream.listen((connectionState) {
        // Refresh server data if connected
        if (connectionState is Connected) dataModel.sendRefreshAllTable();
    });

    WidgetsBinding.instance.addObserver(this);  // Start listening of application lifecycles
    netConnection.searchServerAndConnect();     // Connect to server
    dataModel.loadData();                       // First load all data
  }

  @override
  void dispose() {
    // TODO: implement dispose
    dataModel.saveData();                   // Save all data before exit
    netConnection.disconnect();             // DISCONNECTION
    netConnection.streamController.close(); // Close listening connection state
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    if (state == AppLifecycleState.paused) {
      dataModel.saveData();                       // if the App is paused save all data
      netConnection.disconnect();                 // DISCONNECTION
    } else if (state == AppLifecycleState.resumed) {
      netConnection.searchServerAndConnect();     // Connect to server
      dataModel.loadData();                       // if the App is resumed load all data
    }
    super.didChangeAppLifecycleState(state);
  }

//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Connection provider for listening connection state and sending network commands to server
        ChangeNotifierProvider<NetConnection>.value(value: netConnection),
        // Data provider for data model access
        ChangeNotifierProvider<DataModel>.value(value: dataModel),
      ],
      child: Consumer<DataModel>(
        // For listening data model changes
        builder: (context, data, child) {
          return Scaffold(
            backgroundColor: quizMainBackColor,
            //========================  MAIN MENU  =============================
            drawer: QuizDrawer(),
            appBar: AppBar(
              actions: [
                // --------------  'Connect' button in App Bar -----------------
                Consumer<NetConnection>(
                  builder: (context, connection, child) {
                    return RoundedRectangleFloatingButton(
                      child: connection.connected
                          ? Icon(
                              Icons.wifi_tethering_sharp,
                              color: quizIconColor,
                            )
                          : Icon(
                              Icons.portable_wifi_off,
                              color: quizIconColor,
                            ),
                      onPressed: () {
                        if (!connection.connected) connection.searchServerAndConnect();
                      },
                    );
                  },
                ),
              ],
              title: Text(
                widget.title,
                style: TextStyle(
                    color: quizMainTextColor,
                    backgroundColor: quizMainPanelColor),
              ),
              centerTitle: true,
              backgroundColor: quizMainPanelColor,
              foregroundColor: quizMainTextColor,
            ),

            // =========================  Team List  ===========================
            body: Container(
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    //------------------ One Team Item  -------------------
                    return Dismissible(
                      // Confirm deleting Team
                      confirmDismiss: (direction) => showConfirmDialog(
                          context,
                          direction,
                          'Delete team ${data.getTeam(index).teamName}',
                          'Are you shure?'),
                      // Deleting Team
                      onDismissed: (direction) {
                        data.removeTeam(index);
                        //if (netConnection.connected) netConnection.sendDeleteTeam(data.getTeam(index).teamName);
                      },
                      key: Key(data.getTeam(index).teamName),
                      child: TeamListItem(
                        index: index,
                      ),
                    );
                  }),
            ),
            //========================  FOOTER MENU  ===========================
            persistentFooterButtons: [
              // ------------------ 'Add New Team' button  -----------------
              RoundedRectangleFloatingButton(
                child: Icon(
                  Icons.add,
                  color: quizIconColor,
                ),
                onPressed: () {
                  addNewTeam(context, data);
                },
              ),
              // ------------------ 'Sort Team List' button  ---------------
              RoundedRectangleFloatingButton(
                child: Icon(
                  Icons.sort,
                  color: quizIconColor,
                ),
                onPressed: () {
                  data.sortByScores();
                },
              ),
              // -------------- 'Toggle Full screen' button  ---------------
              RoundedRectangleFloatingButton(
                child: Icon(
                  Icons.fullscreen,
                  color: quizIconColor,
                ),
                onPressed: () {
                  if (netConnection.connected)
                    netConnection.sendFullscreenModeCommand();
                }, //--------------------------------  FULLSCREEN  ------------------------------------
              ),
            ],
          );
        },
      ),
    );
  }
}
