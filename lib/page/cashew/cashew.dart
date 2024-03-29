
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sohel_nuts/model/cashew.dart';
import 'package:sohel_nuts/network/network.dart';
import 'package:sohel_nuts/model/cashew.dart';

typedef OnDelete();


class Cashew extends StatefulWidget {


  @override
  _CashewState createState() => _CashewState();
}

class _CashewState extends State<Cashew> {

  // dynamic widgets
  String dropdownValue = 'One';

  final List<Template> _widgets =[];
  var quantity;
  var price;
  var totalQuantity =0;
  var totalPrice = 0.0;
  var totalAmount = 0.0;


  final GlobalKey<ScaffoldState> mScaffoldState = new GlobalKey<ScaffoldState>();

  GlobalKey<FormState> _key = new GlobalKey();


  var salesPrice = new TextEditingController();

  var _token;
  var _id;


  final bool _validate = false;

  var margin = 0;
  var value = 0;
  var cost = 0;

  List item=[];


  Future<String> getSize() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? 0;
    var url =  Network.cashew_item;
    var res = await http
        .get(url, headers: {"Accept": "application/json","Authorization": token});
    var resBody = json.decode(res.body);

    print(resBody);
    setState(() {
      item = resBody;
      dropdownValue = item[0];
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getToken();
    _getId();
    getSize();
  }

  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.green,
          // Your app THEME-COLOR
          textTheme: new TextTheme(
            body1: new TextStyle(color: Colors.green, fontSize: 16.0),
          ),
        ),
        home: Scaffold(
          key: mScaffoldState,
          appBar: AppBar(
              automaticallyImplyLeading: true,
              centerTitle: true,
              title: Text('CASHEW NUTS'),
              leading: IconButton(icon:Icon(Icons.arrow_back),
                onPressed:() => Navigator.pop(context, false),
              )
          ),
          body:
          item.length  > 0 ?
          Container(
            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text('Item',),
                    ),

                    Spacer(),

                    Expanded(
                      flex: 3,
                      child: Text('Quantity'),
                    ),

                    Spacer(),

                    Expanded(
                      flex: 3,
                      child: Text('Price'),
                    ),

                    Spacer(),

                    Expanded(
                      flex: 2,
                      child: Text('AMT'),
                    ),

                  ],
                ),

                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child:
                      IconButton(icon: Icon(Icons.add), onPressed: (){
                        setState(() {
                          GlobalKey<_TemplateState> _key = GlobalKey();
                          _widgets.add(Template(key: _key,));
                        }
                        );
                      }),
                    ),
                    Expanded(
                      flex: 2,
                      child:
                      IconButton(icon: Icon(Icons.delete), onPressed: (){
                        int i = _widgets.length;

                        setState(() {
                          _widgets.removeAt(i-1);
                        });
                      }),
                    ),
                  ],
                ),


                Divider(height: 20.0,),
                Form(
                  key: _key,
                  autovalidate: _validate,
                  child: Column(
                    children: <Widget>[

                      Column(
                        children: _widgets,
                      ),

                      Divider(height: 20.0,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex:3,
                            child: Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 3,
                            child: Text('$totalQuantity', style: TextStyle(fontSize: 20.0),textAlign: TextAlign.center,),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 3,
                            child: Text('$totalPrice', style: TextStyle(fontSize: 20.0), textAlign: TextAlign.center,),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 2,
                            child: Text('$totalAmount',  style: TextStyle(fontSize: 20.0), textAlign: TextAlign.left,),
                          ),

                        ],
                      ), // Total

                      Divider(height: 20,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text('Sales Price', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),textAlign: TextAlign.right,),

                          ),
                          Spacer(),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator: validatePrice,
                              controller: salesPrice,
                              style: TextStyle(fontSize: 20.0, color: Colors.green),
                            ),
                          ),
                          Expanded(flex: 1,child: Text(''),),
                        ],
                      ),  // Sales price

                    ],
                  ),
                ),


                Container(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Margin', style: TextStyle(fontSize: 20.0),),
                          Text('$margin', style: TextStyle(fontSize: 20.0),),
                          Text('TK', style: TextStyle(fontSize: 20.0),),
                        ],
                      ),
                      Divider(height: 20.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Value', style: TextStyle(fontSize: 20.0),),
                          Text('$value', style: TextStyle(fontSize: 20.0),),
                          Text('TK', style: TextStyle(fontSize: 20.0),),
                        ],
                      ),
                      Divider(height: 20.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Cost', style: TextStyle(fontSize: 20.0),),
                          Text('$cost', style: TextStyle(fontSize: 20.0),),
                          Text('TK', style: TextStyle(fontSize: 20.0),),
                        ],
                      ),
                      Divider(height: 20.0,),
                    ],
                  ),
                ),


              ],
            ),
          ) :
          Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          bottomNavigationBar:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 15,
                child:FlatButton(
                  padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
                  onPressed: _clear,
                  child: new Text('CLEAR', style: TextStyle(color: Colors.white, fontSize: 25.0),), color: Colors.green,),
              ),
              Spacer(),
              Expanded(
                flex: 15,
                child:FlatButton(
                  padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
                  onPressed: _show ,child: new Text('SHOW', style: TextStyle(color: Colors.white, fontSize: 25.0),), color: Colors.green,),
              ),
              Spacer(),
              Expanded(
                flex: 15,
                child:FlatButton(
                  padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
                  onPressed: _save ,child: new Text('SAVE', style: TextStyle(color: Colors.white, fontSize: 25.0),), color: Colors.green,),
              ),
            ],
          ),
        ),
      );

  }



  void _clear() {

    setState(() {
      _widgets.clear();
      salesPrice.text = '';

      totalQuantity = 0;
      totalPrice = 0.0;
      totalAmount = 0.0;

      margin = 0;
      value = 0;
      cost = 0;

    });

  }


  void _show() {

    var ta = 0.0;
    var tq = 0;
    var tp = 0.00;

    _widgets.forEach((x){
      var temp = (x.key as GlobalKey<_TemplateState>);
      var price = temp.currentState.price.text;
      var quantity = temp.currentState.quantity.text ;
      tq += int.parse(quantity);
      tp += double.parse(price);

      ta += temp.currentState.amount;

      var ddValue = temp.currentState.size;

      // print("$ddValue --------- $out");
    });

    var avg = tp/_widgets.length;
    print('total price is $avg');
    print('total amount is $totalAmount');
    print('total quantity is $totalQuantity');

    setState(() {
      totalPrice = avg.toDouble();
      print(totalPrice);
      totalAmount = ta;
      totalQuantity = tq;
    });

   // setState(() {

      if( _key.currentState.validate()) {


        http.post(
            Network.cashew_result,
            headers: {"Accept": "application/json", "Authorization": _token},
            body: {
              "price": '$avg',
              "sales": salesPrice.text,
              'quantity' : '$totalQuantity',
            }
        ).then((response) async {
          var _margin = jsonDecode(response.body)['margin'];
          var _value = jsonDecode(response.body)['value'];
          var _cost = jsonDecode(response.body)['cost'];

          print('margin $_margin');
          print('value $_value');
          print('cost $_cost');
          setState(() {

          margin = _margin;

          value = _value;

          cost = _cost;

          });
        }).catchError((e) {
          print(e.toString());
        });
      }else{
//        setState(){
//          _validate = true;
       // }
      }

    //});


  }


  void _save() {

    http.post(
        Network.save_cashew,
        headers: {"Accept": "application/json", "Authorization": _token},
        body: {
          // form data
        }
    ).then((response) async{
      var res = jsonDecode(response.body)['response'];
      if(res == 'success')
      {
        mScaffoldState.currentState.showSnackBar(
          SnackBar(
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
              content: Text('Saved Successfully')),
        );
      }
    }).catchError((e) {
      print(e.toString());
    });
  }


  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = (prefs.getString('token'));
    });
  }

  _getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = (prefs.getInt('id'));
    });
  }

  bool validate() {
    var valid = _key.currentState.validate();
    if(valid) _key.currentState.save();
    return valid;

  }

  String validateQuantity(String value) {
    if(value.length == 0)
    {
      return "Quantity is Required";
    }else{
      return null;
    }
  }

  String validatePrice(String value) {
    if(value.length == 0)
    {
      return "Price is Required";
    }else{
      return null;
    }
  }

  String _dropdownValidate(value) {
    if(value == null)
    {
      return "Please select a item ";
    }
  }

}





class Template extends StatefulWidget {

  Template({Key key,}) : super(key: key);

  @override
  _TemplateState createState() => _TemplateState();
}

class _TemplateState extends State<Template> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSize();
  }

  String dropdownValue = "One";
  List item=[];

  var size;
  final TextEditingController price = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  int amount = 0;

  GlobalKey<FormState> key = new GlobalKey();

  bool _validate = false;




  Future<String> getSize() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? 0;
    var url =  Network.cashew_item;
    var res = await http
        .get(url, headers: {"Accept": "application/json","Authorization": token});
    var resBody = json.decode(res.body);

    print(resBody);
    setState(() {
      item = resBody;
      dropdownValue = item[0];
    });
  }


  @override
  Widget build(BuildContext context) {
    return
      Container(
          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: new DropdownButtonFormField(
                  validator: _dropdownValidate,
                  items: item.map((item) {
                    return new DropdownMenuItem(
                      child: new Text(item),
                      value: item,
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      size = newVal;
                    });
                  },
                  value: size,
                  hint: Text("SELECT", style: TextStyle(fontSize: 14.0),),
                ),
              ),

              Spacer(),

              Expanded(
                flex: 3,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: quantity,
                  style: TextStyle(color: Colors.green, fontSize: 20.0),
                ),
              ),

              Spacer(),

              Expanded(
                flex: 3,
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (text){
                    var pr = double.parse(price.text);
                    var qn = int.parse(quantity.text);
                    setState(() {
                     var amt = pr*qn;
                     amount = amt.toInt();
                    });
                  },
                  controller: price,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Spacer(),

              Expanded(
                flex: 2,
                child: Text('$amount', style: TextStyle(fontSize: 18.0), textAlign: TextAlign.left,),
              ),

            ],
          )
      );
  }


  bool validate() {
    var valid = key.currentState.validate();
    if(valid) key.currentState.save();
    return valid;

  }

  String validateQuantity(String value) {
    if(value.length == 0)
    {
      return "Quantity is Required";
    }else{
      return null;
    }
  }

  String validatePrice(String value) {
    if(value.length == 0)
    {
      return "Price is Required";
    }else{
      return null;
    }
  }

  String _dropdownValidate(value) {
    if(value == null)
    {
      return "Please select a item ";
    }
  }


}
