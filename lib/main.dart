import 'package:firebase_core/firebase_core.dart';
import 'package:fixadmin/viewmodel/customer%20viewmodel.dart';
import 'package:fixadmin/viewmodel/home%20viewmodel.dart';
import 'package:fixadmin/viewmodel/manage%20tech%20viewmodel.dart';
import 'package:fixadmin/viewmodel/orderdetails%20viewmodel.dart';
import 'package:fixadmin/viewmodel/profile%20viewmodel.dart';
import 'package:fixadmin/viewmodel/service%20viewmodel.dart';
import 'package:fixadmin/viewmodel/technician%20viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view/splash.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( Proclass());
}

class Proclass extends StatelessWidget {
  const Proclass({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CustomersViewModel()),
        ChangeNotifierProvider(create: (context) => AdminHomeViewModel()),
        ChangeNotifierProvider(create: (context) => ManageTechnicianViewModel()),
        ChangeNotifierProvider(create: (context) => OrderDetailsViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileSettingsViewModel()),
        ChangeNotifierProvider(create: (context) => ServiceCategoriesViewModel()),
        ChangeNotifierProvider(create: (context) => TechniciansViewModel()),


      ],
      child:  MaterialApp(
        home: Splash(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}