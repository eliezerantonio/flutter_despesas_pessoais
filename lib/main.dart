import 'dart:math';
import 'dart:io';

import 'package:despesas/widgets/chart.dart';
import 'package:despesas/widgets/transaction_form.dart';
import 'package:despesas/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/transaction.dart';

main() => runApp(ExpensesAPP());

class ExpensesAPP extends StatefulWidget {
  const ExpensesAPP({Key key}) : super(key: key);

  @override
  _ExpensesAPPState createState() => _ExpensesAPPState();
}

class _ExpensesAPPState extends State<ExpensesAPP> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: MyHomePage(),
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'QuickSand',
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            button:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;

  final List<Transaction> _transactions = [];
  //pegar transacoes recentes
  List<Transaction> get _recentTrasactions {
    return _transactions.where(
      (transacao) {
        //pegar data de agora e subtraindo 7 dias
        return transacao.date.isAfter(
          DateTime.now().subtract(
            Duration(days: 7),
          ),
        );
      },
    ).toList();
  }
//inicio metodos
  //addicionar transacao

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(
      () {
        _transactions.add(newTransaction);
      },
    );

    //fechar modal
    Navigator.of(context).pop();
  }

//remover
  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((transacao) => transacao.id == id);
    });
  }

//abrir transacao
  _opentransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  //obter iconButton para cada platform

  Widget _getIconButtom(IconData icon, Function fn) {
    return Platform.isIOS
        ? GestureDetector(
            onTap: fn,
            child: Icon(icon),
          )
        : IconButton(
            icon: Icon(icon),
            onPressed: fn,
            color: Colors.black,
          );
  }

//fim metodos

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    //icons
    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
    final chartList =
        Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;

    final actions = [
      if (isLandscape)
        _getIconButtom(
          _showChart ? iconList : chartList,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButtom(
        Platform.isIOS
            ? CupertinoIcons.add
            : Icons.add, //icon consoante a platform
        () => _opentransactionFormModal(context),
      )
    ];

//inico appbar
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text("Despesas Pessoais"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min, //ocupando o size minimo possivel
              children: actions,
            ),
          )
        : AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              "Despesas Pessoais",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20 * mediaQuery.textScaleFactor),
            ),
            actions: actions,
          );
    //fim appbar

//subtraindo o tamnho do appbar e do status bar
    final avaliabeHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final badyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if (isLandscape) //ocultar o sitch no podo retrato
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text("Exibir grafico"),
            //       //adptative para se adpter cosontate  a plataforma
            //       Switch.adaptive(
            //         activeColor: Theme.of(context).accentColor,
            //         value: _showChart,
            //         onChanged: (value) {
            //           setState(() {
            //             _showChart = value;
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            if (_showChart || !isLandscape)
              Container(
                height: avaliabeHeight *
                    (isLandscape
                        ? 0.7
                        : 0.3), // se estiver no landscape mudar para 70
                child: Chart(
                  _recentTrasactions,
                ),
              ),
            if (!_showChart || !isLandscape)
              Container(
                height: avaliabeHeight * (isLandscape ? 1 : 0.7),
                child: TransactionList(
                  _transactions,
                  _removeTransaction,
                ),
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: null,
            child: badyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: badyPage,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _opentransactionFormModal(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
