import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';

import 'package:dims_vet_rx/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:dims_vet_rx/screens/others_data_screen/login_screen.dart';
import 'package:dims_vet_rx/screens/others_data_screen/privacy_policy.dart';

import 'package:dims_vet_rx/utilities/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/hive_adapter.dart';
import 'database/hive_boxes_open.dart';
void main() async{
  // --------------------------------------------------------------------------
  // Simple Usage
  // --------------------------------------------------------------------------
  // InnoSetup(
  //   app: InnoSetupApp(
  //     name: 'Navana Rx Digital',
  //     version: Version.parse('0.1.0.0'),
  //     publisher: 'author',
  //     urls: InnoSetupAppUrls(
  //       homeUrl: Uri.parse('https://example.com/'),
  //     ),
  //   ),
  //   files: InnoSetupFiles(
  //     executable: File('build/windows/runner/test_app.exe'),
  //     location: Directory('build/windows/runner'),
  //   ),
  //   name: const InnoSetupName('windows_installer'),
  //   location: InnoSetupInstallerDirectory(
  //     Directory('build/windows'),
  //   ),
  //   icon: InnoSetupIcon(
  //     File('assets/images/app_icon.ico'),
  //   ),
  // ).make();


  await initHive();
//  adapter and box initialization code

  await AdapterAssign().adapterList();
  await BoxesOpen().openBoxes();
  if(await checkLoginStatus() == true){
    checkAndRunDailyFunction();
  }

  runApp(MyApp(checkLoginStatus: await checkLoginStatus()));
}

class MyApp extends StatefulWidget {
  final checkLoginStatus;
  const MyApp({super.key, this.checkLoginStatus});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),

      home: widget.checkLoginStatus == true ? HomeScreen() : LoginPage(),
    );
  }
}




class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{
  @override
  void initState() {
    super.initState();
    // Listen for window close events
    print("my close");
    if(Platform.isWindows){
      WidgetsBinding.instance.addObserver(this);
    }


  }
  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    // DesktopWindow.removeListener(_onWindowClose);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // The app is in the foreground
      print('App is in the foreground');
      Helpers.successSnackBar("Success", "App is in the foreground");
    } else if (state == AppLifecycleState.paused) {
      // The app is in the background
      print('App is in the background');
      Helpers.successSnackBar("Success", "App is in the background");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation Dialog Example'),
      ),
      body: Center(
        child: Text('Your Application Content Here'),
      ),
    );
  }

  void _onWindowClose(bool isExiting) async {
    if (isExiting) {
      // Show confirmation dialog
      bool exitConfirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure you want to exit?'),
            actions: <Widget>[
              FilledButton(
                onPressed: () {
                  // Close the dialog and exit the application
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'),
              ),
              FilledButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
            ],
          );
        },
      );

      if (exitConfirmed) {
        // Exit the application
        exit(0);
      }
    }
  }


}


