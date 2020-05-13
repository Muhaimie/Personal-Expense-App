import 'package:expense/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';


class TransactionList extends StatelessWidget {

final List<Transaction> transactions;

final Function deleteTransaction;

TransactionList(this.transactions,this.deleteTransaction);

@override
Widget build(BuildContext context) {

  final mediaQuery = MediaQuery.of(context);

  return  transactions.isEmpty ?
  LayoutBuilder(builder: (ctx, constraint){
      return Column(
        children: <Widget>[
          Text("No transaction added yet!",style:Theme.of(context).textTheme.title),
          SizedBox(height:10),
          Container(
            height: constraint.maxHeight * 0.6,
            child: Image.asset("assets/images/waiting.png", fit:BoxFit.cover))
        ],
    );
  })
   : ListView.builder(
                  itemBuilder: (ctx, index) {
                    return 
                    Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical:8,horizontal:5),
                        child: ListTile(
                        leading: CircleAvatar(radius:30, 
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: FittedBox(child: Text("\$${transactions[index].amount}")))),
                          title: Text(transactions[index].title, style:Theme.of(context).textTheme.title),
                          subtitle: Text(DateFormat.yMMMd().format(transactions[index].date)),
                          trailing: mediaQuery.size.width > 500 ? 
                          FlatButton.icon(textColor:  Theme.of(context).errorColor,onPressed: ()=>deleteTransaction(transactions[index].id), icon: Icon(Icons.delete), label: Text("Delete")) :
                          IconButton(icon: Icon(Icons.delete), color:Theme.of(context).errorColor, 
                            onPressed: (){
                              deleteTransaction(transactions[index].id);
                            }),
                      ),
                    );
                  },
                  itemCount: transactions.length,
    );
}
}