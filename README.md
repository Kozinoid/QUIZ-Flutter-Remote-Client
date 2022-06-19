//**************************  КОМАНДЫ СЕРВЕРУ  *************************************************
//--------------------------  Результат одной команды  -----------------------------------------
private void SendOneTeam(String name, int score)
{
String message = "#r#e#f<" + name + ">" + score + "#";
if (myTCPDevice.connected) myTCPDevice.onSendRequest(message);
}

    //--------------------------  Переименование команды  ------------------------------------------
    private void SendRenameTeam(String name, String newname)
    {
        String message = "#r#e#n<" + name + "><" + newname + ">#";
        if (myTCPDevice.connected) myTCPDevice.onSendRequest(message);
    }

    //--------------------------  Добавление команды  ----------------------------------------------
    private void SendAddTeam(String name, int score)
    {
        String message = "#a#d#d<" + name + ">" + score + "#";
        if (myTCPDevice.connected) myTCPDevice.onSendRequest(message);
    }

    //---------------------------  Удаление команды  -----------------------------------------------
    private void SendDeleteTeam(String name)
    {
        String message = "#d#e#l<" + name + ">#";
        if (myTCPDevice.connected) myTCPDevice.onSendRequest(message);
    }

    //------------------------  Вся таблица  -------------------------------------------------------
    private void SendTabl()
    {
        String message = "#t#a#b";
        if (myTCPDevice.connected) myTCPDevice.onSendRequest(message);
        for (int i = 0; i < teamList.size(); i++)
        {
            SendAddTeam(teamList.get(i).getTeamName(), teamList.get(i).getScore());
        }
    }

    //-----------------------  Полноэкранный режим  ------------------------------------------------
    private void SendFullScreen()
    {
        String message = "#f#s#m";
        if (myTCPDevice.connected) myTCPDevice.onSendRequest(message);
    }

    //-----------------------  Сохраняем текущий IP  -----------------------------------------------
    private void SaveIP()
    {
        sPref = getPreferences(MODE_PRIVATE);
        SharedPreferences.Editor ed = sPref.edit();
        ed.putString(SAVED_TEXT, tcpConnectionIDText);
        ed.commit();
    }

    //-----------------------  Загружаем текущий IP  -----------------------------------------------
    private void LoadIP()
    {
        sPref = getPreferences(MODE_PRIVATE);
        mIPTextView.setText(sPref.getString(SAVED_TEXT, "tcp://192.168.0.99:8060/"));
    }

// actions: [
//   // ---------------  'Connect' button  ----------------------
//   RoundedRectangleFloatingButton(
//     child: connection.connected
//         ? Icon(
//             Icons.wifi_tethering_sharp,
//             color: quizIconColor,
//           )
//         : Icon(
//             Icons.portable_wifi_off,
//             color: quizIconColor,
//           ),
//     onPressed: () {
//       connection.searchIP();
//     }, //-------------------------------  CONNECT  ------------------------------------
//   ),
//
//   // ---------------  'Clear all' button  ----------------------
//   RoundedRectangleFloatingButton(
//     child: Icon(
//       Icons.clear,
//       color: quizIconColor,
//     ),
//     onPressed: () async {
//       if (await showConfirmDialog(
//           context, null, 'Clear all', 'Are you shure?'))
//         data.clearAll();
//     },
//   ),
//
//   // ---------------  'Load all' button  ----------------------
//   RoundedRectangleFloatingButton(
//     child: Icon(
//       Icons.folder,
//       color: quizIconColor,
//     ),
//     onPressed: () async {
//       if (await showConfirmDialog(context, null, 'Load table',
//           'Load last saved table?')) data.loadData();
//     },
//   ),
//
//   // ---------------  'Save all' button  ----------------------
//   RoundedRectangleFloatingButton(
//     child: Icon(
//       Icons.save,
//       color: quizIconColor,
//     ),
//     onPressed: () async {
//       if (await showConfirmDialog(
//           context, null, 'Save table', 'Save changes?'))
//         data.saveData();
//     },
//   )
// ],