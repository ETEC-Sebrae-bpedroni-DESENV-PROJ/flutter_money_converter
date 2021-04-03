import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';

var url = Uri.parse('https://api.hgbrasil.com/finance?format=json');

class MoneyConverter extends StatefulWidget {
  @override
  _MoneyConverterState createState() => _MoneyConverterState();
}

class _MoneyConverterState extends State<MoneyConverter> {
  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();
  final bitcoinController = TextEditingController();

  Future<Map> resultData;

  Map<String, dynamic> currencies;

  List<String> mode = ['buy', 'sell'];
  int modeIndex = 0;

  Future<Map> fetchData () async {
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    resultData = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Conversor de Moeda")),
      body: FutureBuilder(
        future: resultData,
        builder: (ctx, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
              break;
            default:
              if (snapshot.hasError) {
                return Center(child: Text("Erro ao carregar dados"));
              } else {
                currencies = snapshot.data["results"]["currencies"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 120.0),
                      Center(
                        child: ToggleSwitch(
                          initialLabelIndex: modeIndex,
                          labels: ['Compra', 'Venda'],
                          activeBgColor: Theme.of(context).accentColor,
                          onToggle: _onModeChanged,
                        )
                      ),
                      Divider(),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Real",
                          prefixText: "R\$ ",
                          border: OutlineInputBorder()
                        ),
                        controller: realController,
                        onChanged: _realChanged,
                      ),
                      Divider(),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Dólar",
                          prefixText: "US\$ ",
                          border: OutlineInputBorder()
                        ),
                        controller: dollarController,
                        onChanged: _dollarChanged,
                      ),
                      Divider(),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Euro",
                          prefixText: "€ ",
                          border: OutlineInputBorder()
                        ),
                        controller: euroController,
                        onChanged: _euroChanged,
                      ),
                      Divider(),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Bitcoin",
                          prefixText: "฿ ",
                          border: OutlineInputBorder()
                        ),
                        controller: bitcoinController,
                        onChanged: _bitcoinChanged,
                      )
                    ]
                  )
                );
              }
          }
        })
    );
  }

  void _onModeChanged(int index) {
    setState(() {
      modeIndex = index;
      _realChanged(realController.text);
    });
  }

  void _realChanged(String text) {
    double value = double.tryParse(text);
    if (value != null) {
      dollarController.text = (value / currencies['USD'][mode[modeIndex]]).toStringAsFixed(2);
      euroController.text = (value / currencies['EUR'][mode[modeIndex]]).toStringAsFixed(2);
      bitcoinController.text = (value / currencies['BTC'][mode[modeIndex]]).toStringAsFixed(2);
    } else {
      dollarController.text = '';
      euroController.text = '';
      bitcoinController.text = '';
    }
  }

  void _dollarChanged(String text) {
    double value = double.tryParse(text);
    if (value != null) {
      realController.text = (value * currencies['USD'][mode[modeIndex]]).toStringAsFixed(2);
      euroController.text = (value * currencies['USD'][mode[modeIndex]] / currencies['EUR'][mode[modeIndex]]).toStringAsFixed(2);
      bitcoinController.text = (value * currencies['USD'][mode[modeIndex]] / currencies['BTC'][mode[modeIndex]]).toStringAsFixed(2);
    } else {
      realController.text = '';
      euroController.text = '';
      bitcoinController.text = '';
    }
  }

  void _euroChanged(String text) {
    double value = double.tryParse(text);
    if (value != null) {
      realController.text = (value * currencies['EUR'][mode[modeIndex]]).toStringAsFixed(2);
      dollarController.text = (value * currencies['EUR'][mode[modeIndex]] / currencies['USD'][mode[modeIndex]]).toStringAsFixed(2);
      bitcoinController.text = (value * currencies['EUR'][mode[modeIndex]] / currencies['BTC'][mode[modeIndex]]).toStringAsFixed(2);
    } else {
      realController.text = '';
      dollarController.text = '';
      bitcoinController.text = '';
    }
  }

  void _bitcoinChanged(String text) {
    double value = double.tryParse(text);
    if (value != null) {
      realController.text = (value * currencies['BTC'][mode[modeIndex]]).toStringAsFixed(2);
      dollarController.text = (value * currencies['BTC'][mode[modeIndex]] / currencies['USD'][mode[modeIndex]]).toStringAsFixed(2);
      euroController.text = (value * currencies['BTC'][mode[modeIndex]] / currencies['EUR'][mode[modeIndex]]).toStringAsFixed(2);
    } else {
      realController.text = '';
      dollarController.text = '';
      euroController.text = '';
    }
  }
}
