import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sohel_nuts/network/network.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {


  String dropdownValue = 'One';

  final List<Template> _widgets =[];


  void _retriveDate(){
    _widgets.forEach((x){
      var temp = (x.key as GlobalKey<_TemplateState>);
      var pr = temp.currentState.price.text;
      var qn = temp.currentState.quantity.text ;
      var out = int.parse(pr) * int.parse(qn);
      print('amount is ${temp.currentState.amount}');

      var ddValue = temp.currentState.size;

      print("$ddValue --------- $out");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(20.0),
      child:  Center(
          child:
              Column(
                children: <Widget>[
              FlatButton(
              color: Colors.blue,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () {
                  setState(() {
                    GlobalKey<_TemplateState> _key = GlobalKey();
                    _widgets.add(Template(key: _key,));
                  });
                },
                child: Text(
                  "ADD ROW",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),

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
                  Expanded(
                    flex: 2,
                    child: Text(''),
                  )


                ],
              ),

              Column(
                children: _widgets,
              ),

              FlatButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                        _retriveDate();
                    },
                    child: Text(
                      "SHOW RESULT",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),// Submit button

                ],
              )
        ),
      ),
    );
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
  var amount;

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
          child: TextFormField(
            keyboardType: TextInputType.number,
            validator: validateQuantity,
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
              var pr = int.parse(price.text);
              var qn = int.parse(quantity.text);
              setState(() {
                amount = pr*qn;
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
          child: Text('$amount', style: TextStyle(fontSize: 15.0), textAlign: TextAlign.left,),
        ),
        Expanded(
            flex: 1,
            child: IconButton(icon: Icon(Icons.delete), onPressed: null)
        )

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
