import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:mediminder/global_bloc.dart';
import 'package:mediminder/ui/home_page.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:mediminder/generated/l10n.dart';
import 'package:mediminder/common.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(const MedicineReminder());
}

class MedicineReminder extends StatefulWidget {
  const MedicineReminder({ Key? key }) : super(key: key);

  @override
  _MedicineReminderState createState() => _MedicineReminderState();
}

class _MedicineReminderState extends State<MedicineReminder> {
  GlobalBloc globalBloc = GlobalBloc();

  Widget _buildMRApp(BuildContext context) => AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'app_name'.trans(),
        theme: theme,
        darkTheme: darkTheme,
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: const Locale.fromSubtags(languageCode: 'en'),
      ));

  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>.value(
      value: globalBloc,
      child: _buildMRApp(context)
    );
  }
}
