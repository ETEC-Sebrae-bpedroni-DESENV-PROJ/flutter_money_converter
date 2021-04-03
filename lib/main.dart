import 'package:flutter/material.dart';
import 'app/money_converter.dart';

const Color primaryColor = Colors.amber;
const Color accentColor = Colors.green;
const bool isDark = true;

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conversor de Moeda',
      theme: ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primarySwatch: primaryColor,
        primaryColor: primaryColor,
        accentColor: accentColor,
        iconTheme: IconThemeData(color: accentColor)
      ),
      home: MoneyConverter(),
    ));
}
