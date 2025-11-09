import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_project/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
   await Supabase.initialize(url: 'https://bulsfiwuvlhlodtsbfcd.supabase.co', anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ1bHNmaXd1dmxobG9kdHNiZmNkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjExNDU4ODMsImV4cCI6MjA3NjcyMTg4M30.gROM_gjNfCGvehTaVYe64P-UBU_ssnPleSebrWFRzsE');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}
