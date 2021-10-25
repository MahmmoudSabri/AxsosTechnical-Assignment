import 'dart:async';
import 'dart:convert';

import 'Order.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget{

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<List<Order>> fetchPosts() async {

    http.Response response = await http.get(
        Uri.parse('https://axsos-interview-app.herokuapp.com/api/orders'));

    if(response!=null&&response.statusCode==200)
    {
      var responseJson = json.decode(response.body);
      print(responseJson['']);
      ordersList=(responseJson[''] as List)
          .map((p) => Order.fromJson(p))
          .toList();
      // print("----");
      // print(ordersList.length);
      suppliers.clear();
      suppliers.add("All Suppliers");
      if(ordersList!=null&&ordersList.length>0)
        for(Order order in ordersList)
        {
          if(order.seller_name!=null&&!suppliers.contains(order.seller_name))
          {
            suppliers.add(order.seller_name??"");
          }
        }
      setState(() {

      });
      return ordersList;
    }
    else
    {

      setState(() {
        requestStat=false;
      });
      final snackBar = SnackBar(
        content: Text('Failed to load Orders!'),

      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      throw Exception('Failed to load Orders');

    }

  }
  @override
  void initState() {

    super.initState();
    fetchPosts();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                    MyHomePage(title: "",)
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,

              colors: [Color(0xFF7b4299),Color(0xFF6f2c90),]
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/axsos-logo.png",
                  height: 300.0,
                  width: 300.0,
                ),
                Text("Technichal Assignment\n  Senior Software Engineer \n  Flutter Task",textAlign:TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Padding(padding: EdgeInsets.all(20)),
                Text("Mahmoud Sabri",textAlign:TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                  ),
                ),
              ],
            ),

            CircularProgressIndicator(
              valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
            ),
          ],
        ),
      ),
    );
  }
}
