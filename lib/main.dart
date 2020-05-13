import 'dart:io';
 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';



//import './models/transaction.dart';


void main() {
  //to prevent landscape orientation
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  runApp(MyApp());


}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        accentColor: Colors.lightGreen,
        textTheme: ThemeData.light().textTheme.copyWith(
          title:TextStyle(
            fontFamily:"",
            fontSize:30
          ),
          button: TextStyle(
            color:Colors.white
          )
        ),
        // fontFamily: "",
        // appBarTheme: AppBarTheme(
        //   textTheme: ThemeData.light().textTheme.copyWith(
        //     title: TextStyle(
        //       fontFamily:"",
        //       fontSize:30
        //     )
        //   )
        // ),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _userTransaction = [
    Transaction(id: "t1", title: "New shoes", amount: 69.99, date: DateTime.now()),
    Transaction(id: "t2", title: "Grocery", amount: 22.99, date: DateTime.now()),
    Transaction(id: "t1", title: "New shoes", amount: 69.99, date: DateTime.now()),
    Transaction(id: "t2", title: "Grocery", amount: 22.99, date: DateTime.now()),
    Transaction(id: "t1", title: "New shoes", amount: 69.99, date: DateTime.now()),
    Transaction(id: "t2", title: "Grocery", amount: 22.99, date: DateTime.now()),
    Transaction(id: "t1", title: "New shoes", amount: 69.99, date: DateTime.now()),
    Transaction(id: "t2", title: "Grocery", amount: 22.99, date: DateTime.now())
  ];

  bool _showChart= true ;

  List<Transaction> get _recentTransaction{

    return _userTransaction.where((element) {
        return element.date.isAfter(DateTime.now().subtract(Duration(days: 7)));

    } 
    ).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate){
    final newTx = Transaction(title: txTitle, amount: txAmount,id: DateTime.now().toString(),date: chosenDate);
    
    setState(() {
      _userTransaction.add(newTx);
    });
  }


  void _startAddNewTransaction(BuildContext context){
    showModalBottomSheet(context: context, builder: (_){
        return GestureDetector(
          child:NewTransaction(_addNewTransaction),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        ) ;
    });
  }

  void _deleteTransaction(String id){
      
      setState((){
        _userTransaction.removeWhere((element) => element.id == id);
      });
  }

  @override
  Widget build(BuildContext context){

  final mediaQuery = MediaQuery.of(context);

    //checking orientation
  final _isLandscape =  mediaQuery.orientation == Orientation.landscape;


    final PreferredSizeWidget appBar = Platform.isIOS ? CupertinoNavigationBar(
      middle: Text("Personal Expenses"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
       GestureDetector(
         child: Icon(CupertinoIcons.add),
         onTap: ()=> _startAddNewTransaction(context)
       )
      ],),

    ) : AppBar( 
          title: Text("Personal Expenses"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add), onPressed: (){
              _startAddNewTransaction(context);
            })
          ],
        );

    final txListWidget = Container(
                height: (mediaQuery.size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.75,
                child: TransactionList(_userTransaction, _deleteTransaction));

    
    final pageBody = SafeArea(child : SingleChildScrollView(
      
      child:Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if(_isLandscape == true) Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Text("Show chart", style: Theme.of(context).textTheme.title,),
                Switch.adaptive(
                  activeColor: Theme.of(context).accentColor,
                  value: _showChart, onChanged: (val){
                  print(_showChart);
                  setState(() {
                    _showChart = val;
                  });
                }) 
              ],),

              if(!_isLandscape) Container(
                height:( mediaQuery.size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.25,
                child: Chart(_recentTransaction)),
                if(!_isLandscape) txListWidget,

              if(_isLandscape) _showChart ? Container(
                height:( mediaQuery.size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.25,
                child: Chart(_recentTransaction)) :
              txListWidget
              
            ]
          )))
          ;

    return Platform.isIOS ?  
      CupertinoPageScaffold(
        navigationBar: appBar,
        child: pageBody
 ) 
    
    : Scaffold(
        appBar: appBar,
        body:  pageBody,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:Platform.isIOS ? Container() : FloatingActionButton(child:Icon(Icons.add) ,onPressed: ()=> _startAddNewTransaction(context))
    )

    ;
  }
}

