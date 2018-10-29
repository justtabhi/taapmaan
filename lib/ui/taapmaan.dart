import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../util/utils.dart' as util;
import 'package:http/http.dart' as http;

class taapmaan extends StatefulWidget{
  @override
    State<StatefulWidget> createState() {
      // TODO: implement createState
      return new taapmaanState();
    }
}

class taapmaanState extends  State<taapmaan>{

  String _cityEntered;
  Future _goToNextScreen(BuildContext context) async{
    Map result=await Navigator.of(context).push(
      new MaterialPageRoute(builder: (BuildContext context){
        return new ChangeCity();
      })
    );
    if(result!=null&&result.containsKey('enter')){
      _cityEntered=result['enter'];
      //print("From first Screen"+result['enter'].toString());
    }
  }


  void showStuff() async {
    Map data=await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Taapmaan"),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.menu),
            onPressed: () {_goToNextScreen(context);},)
          ],
        ),
        body: new Stack(
          children: <Widget>[
            new Center(
              child: new Image.asset('images/godwin.jpg',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,),
            ), 
            new Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
              child: new Text('${_cityEntered==null?util.defaultCity:_cityEntered}',style: cityStyle(),),
            ),
            new Container(
              alignment: Alignment.center,
              child: new Image.asset('images/light_rain.png'),
            ),
            //Container which will have weather data
            new Container(
              //margin: EdgeInsets.fromLTRB(30.0, 350.0, 0.0, 0.0),
              child: updateTempWidget(_cityEntered),
            )
          ],
        ),
      );
    }
  Future<Map> getWeather(String appId,String city) async {
    String apiUrl='http://api.openweathermap.org/data/2.5/find?q=$city&appid=${util.appId}&units=metric';
    http.Response response=await http.get(apiUrl);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city){
    
     return new FutureBuilder(
       future: getWeather(util.appId,city==null?util.defaultCity:city),
       builder: (BuildContext context,AsyncSnapshot<Map> snapshot){
         //where we get all of the json data, we setup widget etc.
         if(snapshot.hasData){
           Map content= snapshot.data;
           //print(content);
           return new Container(
             margin: EdgeInsets.fromLTRB(30.0, 350.0, 0.0, 0.0),
             child: new Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 new ListTile(
                   title: new Text(content['list'][0]['main']['temp'].toString()+ ' C',
                   style: new TextStyle(color: Colors.white,
                   fontStyle: FontStyle.normal,
                   fontSize: 49.9,
                   fontWeight: FontWeight.w500),
                   ),
                   subtitle: new ListTile(
                     title: new Text(
                       "Humidity:${content['list'][0]['main']['humidity'].toString()}\n"
                          "Min: ${content['list'][0]['main']['temp_min'].toString()+' C'}\n"
                          "Max: ${content['list'][0]['main']['temp_max'].toString()+' C'}",
                     style: extraData(),),
                   ),
                 )
               ],
             ),
           );
         }else{
           return new Container();
         }
     },);
  }
}

class ChangeCity extends StatelessWidget {
  
  var _cityFieldController=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: new Text('Change City'),
        centerTitle: true,
      ),
      body: new Stack(
        
            children: <Widget>[
              new Center(
              child:new Image.asset('images/andy.jpg',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,),
              ),
              new ListView(
                children: <Widget>[
                  new ListTile(
                    title: new TextField(
                      decoration: new InputDecoration(
                        hintText: 'Enter City',
                        hintStyle: new TextStyle(color: Colors.white)
                      ),
                      controller: _cityFieldController,
                      keyboardType: TextInputType.text,
                      style: new TextStyle(color: Colors.white),
                    ),
                  ),
                  new ListTile(
                    title: new FlatButton(
                      onPressed: (){
                        Navigator.pop(context,{
                            'enter': _cityFieldController.text
                        });

                      },
                      color: Colors.blueGrey,
                      textColor: Colors.white,
                      child: new Text('Get Weather'),
                    ),
                  )
                ],
              )
       ],
      ),
    );
  }
}

TextStyle cityStyle(){
  return new TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}
TextStyle tempStyle(){
  return new TextStyle(
    color: Colors.white,
    fontSize: 49.9,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500
  );
}
TextStyle extraData(){
  return new TextStyle(
    color: Colors.white70,
    fontSize: 17.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500
  );
}