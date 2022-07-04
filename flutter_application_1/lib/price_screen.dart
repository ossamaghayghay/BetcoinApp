import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'coin_data.dart';
import 'package:http/http.dart' as http;

const apiKey="29DD81EA-7D6C-44BD-8B39-023BF426FB97";

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);
  
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  
  int value=1;
  dynamic rate1;
  dynamic rate2;
  dynamic rate3;
  List<String> cryptoList = [
   'BTC',
   'ETH',
   'LTC',
  ];
   Object valueSelected="USD";
  /*:::::::::::::::::::::::::::::Android Drop Items Method:::::::::::::::::::::: */
   DropdownButton androidDropItems()
    {
    List<DropdownMenuItem<String>>?  dropdownItem=[];
     for(int i=0;i<currenciesList.length;i++){
      String currency=currenciesList[i];
      var newItem=DropdownMenuItem(
        child: Text(currency),
        value: currency,
        );
      dropdownItem.add(newItem);
    }
      return DropdownButton(
              value: valueSelected,
              items:dropdownItem,
              onChanged: (val){
                setState(() {
                   valueSelected = val ;
                   getData(valueSelected,cryptoList);
                });
              }
              );
  }
  /*:::::::::::::::::::::::::::::ioS CupertinoPicker Method:::::::::::::::::::::: */
 CupertinoPicker iOSPicker()
   {
     List<Widget>  pickerList=[];
    for(int i=0;i<currenciesList.length;i++){
     String currency=currenciesList[i];
     pickerList.add(Text(currency));
    }
   return CupertinoPicker(
        itemExtent:40,
        backgroundColor: Colors.lightBlue,
        onSelectedItemChanged: (val)
        {
          setState(() {
            valueSelected=val;
            getData(valueSelected,cryptoList);
            });
        },
        children:pickerList,
        );
   }
  /*::::::::::::::::::::Check If The APP In Which App is Running:::::::::::::: */
  runPlatformAPP()
  {
   if(Platform.isAndroid){
    return androidDropItems();
   }
   if(Platform.isIOS)
   {
    return iOSPicker();
   }
  }
/*:::::::::::::::BUILD:::::::::::::::::::::::: */
  @override
  void initState() {
    getData(valueSelected,cryptoList);
    super.initState();
  }
  /*::::::::::::::::::::::::::::GET API DATA::::::::::::::::: */
  Future<void> getData(dynamic val,dynamic typeCurrency)async{
    var url1="https://rest.coinapi.io/v1/exchangerate/${typeCurrency[0]}/$val?apikey=$apiKey" ;
    var url2="https://rest.coinapi.io/v1/exchangerate/${typeCurrency[1]}/$val?apikey=$apiKey" ;
    var url3="https://rest.coinapi.io/v1/exchangerate/${typeCurrency[2]}/$val?apikey=$apiKey" ;
    http.Response response1=await http.get(Uri.parse(url1));
    http.Response response2=await http.get(Uri.parse(url2));
    http.Response response3=await http.get(Uri.parse(url3));
    var data1=response1.body;
    var data2=response2.body;
    var data3=response3.body;
    var decodedata1=jsonDecode(data1);
    var decodedata2=jsonDecode(data2);
    var decodedata3=jsonDecode(data3);
    // int.parse(decodedata["rate"]);
    setState(() {
      rate1=(decodedata1["rate"]*value).toInt();
      rate2=(decodedata2["rate"]*value).toInt();
      rate3=(decodedata3["rate"]*value).toInt();
    });
    // print(decodedata["time"]).toI;
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child:  Column(
              children: [
                Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '$value ${cryptoList[0]} = $rate1 $valueSelected',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '$value  ${cryptoList[1]} = $rate2 $valueSelected',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '$value ${cryptoList[2]} = $rate3 $valueSelected',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                     Card(child: Text('$value',style: const TextStyle(color: Colors.black),),color: const Color.fromARGB(255, 198, 198, 198),elevation: 50,),
                    IconButton(
                      onPressed: (){
                        setState(() {
                          value++;

                        });
                      },
                      icon: const Icon(Icons.add,color: Colors.amber,size: 40,)
                      ),
                  ],
                ),
              
              ],
            ),
          ),

          Container(
            height: 150.0,
            width: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:runPlatformAPP(),
          ),
        ],
      ),
      
    );
  }
}
