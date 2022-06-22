import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiflutter/connection/net_connection.dart';
import 'package:quiflutter/dialogs/confirm_dialog.dart';
import 'package:quiflutter/model/data_model.dart';
import 'package:quiflutter/style/styles.dart';

class QuizDrawer extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    //DataModel data = context.read<DataModel>();  //<---- It works too
    DataModel data = Provider.of<DataModel>(context);
    return Consumer<NetConnection>(
      builder: (context, connection, child){
        return Drawer(
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
              ListTile(
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
                  connection.searchServerAndConnect();
                  Navigator.of(context).pop<Drawer>();
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
                    connection.sendClearTableCommand();
                  }
                  Navigator.of(context).pop<Drawer>();
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
                    Future(() => data.loadData()).then((value) => data.sendRefreshAllTable());
                  }
                  Navigator.of(context).pop<Drawer>();
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
                  {
                    data.saveData();
                  }
                  Navigator.of(context).pop<Drawer>();
                },
              ),
              //--------------------------------------------------------
            ],
          ),
        );
      },
    );
  }
}