import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    // Init connection and data
    netConnection = NetConnection();
    dataModel = DataModel(connection: netConnection);
    netConnection.streamController.stream.listen((connectionState) {dataModel.loadData();});
    // Start listening of application lifecycles
    WidgetsBinding.instance.addObserver(this);
    // Connect to server
    netConnection.connect();
    // First load all data
    //dataModel.loadData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // Save all data before exit
    dataModel.saveData();
    netConnection.disconnect();                            // DISCONNECTION
    netConnection.streamController.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    if (state == AppLifecycleState.paused) {
      // if the App is paused save all data
      dataModel.saveData();
      netConnection.disconnect();                          // DISCONNECTION
    } else if (state == AppLifecycleState.resumed) {
      // Connect to server
      netConnection.connect();
      // if the App is resumed load all data
      //dataModel.loadData();
    }
    super.didChangeAppLifecycleState(state);
  }

//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NetConnection>.value(value: netConnection),
        // Connection provider
        ChangeNotifierProvider<DataModel>.value(value: dataModel),
        // Data provider
      ],
      child: Consumer<DataModel>(
        builder: (context, data, child) {
          return Scaffold(
            backgroundColor: quizMainBackColor,
            drawer: Drawer(
              child: ListView(
                children: [
                  //-------------------- Menu header -----------------------
                  DrawerHeader(
                      margin: EdgeInsets.all(0),
                      decoration: ShapeDecoration(
                        color: quizMainPanelColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'QUIZ menu',
                          style: menuFont,
                        ),
                      )),

                  //--------------- Menu item 'Connection' -----------------
                  Consumer<NetConnection>(
                    builder: (context, connection, child) {
                      return ListTile(
                        tileColor: quizMainBackColor,
                        leading: connection.connected
                            ? Icon(
                                Icons.wifi_tethering_sharp,
                                color: quizListTextColor,
                              )
                            : Icon(
                                Icons.portable_wifi_off,
                                color: quizListTextColor,
                              ),
                        title: Text(
                          'Connection',
                          style: menuFont,
                        ),
                        onTap: () {
                          connection.connect();
                        },
                      );
                    },
                  ),

                  //--------------- Menu item 'Clear All' ------------------
                  ListTile(
                    tileColor: quizMainBackColor,
                    leading: Icon(
                      Icons.clear,
                      color: quizListTextColor,
                    ),
                    title: Text(
                      'Clear all',
                      style: menuFont,
                    ),
                    onTap: () async {
                      if (await showConfirmDialog(
                          context, null, 'Clear all', 'Are you shure?'))
                        {
                          data.clearAll();
                          netConnection.sendClearTableCommand();
                        }
                    },
                  ),

                  //------------------ Menu item 'Load' --------------------
                  ListTile(
                    tileColor: quizMainBackColor,
                    leading: Icon(
                      Icons.folder,
                      color: quizListTextColor,
                    ),
                    title: Text(
                      'Load',
                      style: menuFont,
                    ),
                    onTap: () async {
                      if (await showConfirmDialog(context, null, 'Load table',
                          'Load last saved table?')) {
                        data.loadData();
                      }
                    },
                  ),

                  //------------------ Menu item 'Save' --------------------
                  ListTile(
                    tileColor: quizMainBackColor,
                    leading: Icon(
                      Icons.save,
                      color: quizListTextColor,
                    ),
                    title: Text(
                      'Save',
                      style: menuFont,
                    ),
                    onTap: () async {
                      if (await showConfirmDialog(
                          context, null, 'Save table', 'Save changes?'))
                        data.saveData();
                    },
                  ),
                  //--------------------------------------------------------
                ],
              ),
            ),
            appBar: AppBar(
              actions: [
                // ------------- DOUBLE 'Connect' button  ------------------
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
                        connection.connect();
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
            ),

            // -------------------------  Team List  -----------------------
            body: Container(
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    //-------- One Team Item  ------
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
