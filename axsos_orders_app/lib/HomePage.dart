import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Order.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List<Order> ordersList = [];
bool requestStat = true;
List<String> suppliers = [];

class _MyHomePageState extends State<MyHomePage> {
  String _selectedSupplier = 'All Suppliers';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (ordersList.isEmpty) fetchPosts();
  }

  Future<List<Order>> fetchPosts() async {
    http.Response response = await http
        .get(Uri.parse('https://axsos-interview-app.herokuapp.com/api/orders'));

    if (response != null && response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      print(responseJson['']);
      ordersList =
          (responseJson[''] as List).map((p) => Order.fromJson(p)).toList();
      // print("----");
      // print(ordersList.length);
      suppliers.clear();
      suppliers.add("All Suppliers");
      if (ordersList != null && ordersList.length > 0)
        for (Order order in ordersList) {
          if (order.seller_name != null &&
              !suppliers.contains(order.seller_name)) {
            suppliers.add(order.seller_name ?? "");
          }
        }
      setState(() {});
      return ordersList;
    } else {
      setState(() {
        requestStat = false;
      });
      final snackBar = SnackBar(
        content: Text('Failed to load Orders!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      throw Exception('Failed to load Orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: ordersList.length != 0
              ? RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      ordersList = [];
                      fetchPosts();
                    });
                  },
                  child: Column(children: [
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFF383838),
                        image: new DecorationImage(
                          image: new AssetImage(
                            "assets/axsos-logo.png",
                          ),
                        ),
                      ),
                    ),
                    Card(
                      color: Color(0xFFf5f5f5),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Supplier',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 0.5,
                                      style: BorderStyle.solid,
                                      color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                              ),
                              child: DropdownButton<String>(
                                underline: DropdownButtonHideUnderline(
                                    child: Container()),
                                value: _selectedSupplier,
                                items: suppliers.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        value,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSupplier = value ?? "";
                                  });
                                },
                                isExpanded: true,
                              ),
                            ),
                            TextButton.icon(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFF0c272b))),
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Reset Filters',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedSupplier = suppliers.first;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            'DELIVERY DAY',
                            textAlign: TextAlign.center,
                          ),
                          width: width * 0.3,
                        ),
                        Container(
                            width: width * 0.3,
                            child: Text(
                              'SUPPLIER',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            width: width * 0.3,
                            child: Text(
                              'TOTAL',
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Divider(
                        thickness: 1.5,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        // controller: scrollController,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) =>
                            ordersList[index].seller_name ==
                                        _selectedSupplier ||
                                    _selectedSupplier == 'All Suppliers'
                                ? buildItem(context, index, width)
                                : Container(),

                        itemCount: ordersList.length,
                      ),
                    ),
                  ]),
                )
              : (requestStat
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF6f2c90)),
                    ))
                  : Center(
                      child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          requestStat = true;
                          ordersList = [];
                          fetchPosts();
                        });
                      },
                      child: const Text('Reload'),
                    ))),
        ),
      ),
    );
  }

  Widget buildItem(context, index, width) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ordersList[index].delivery_day ?? "",
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            color: ordersList[index].status == 'PAID'
                                ? Color(0xFFb9dccc)
                                : Color(0xFFc4c5fb),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Text(
                          ordersList[index].status ?? "",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width * 0.3,
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ordersList[index].seller_name ?? "",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Row(
                        children: [
                          if (ordersList[index].status != 'DELIVERED')
                            Container(
                              padding: EdgeInsets.only(left: 2, right: 2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  color: Color(0xFF3d3d3d),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2))),
                              child: Text(
                                'MARKET',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          SizedBox(
                            width: 5,
                          ),
                          if (ordersList[index].is_first == 'true')
                            Container(
                              padding: EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  color: Color(0xFFfdfd76),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Text(
                                '1st',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                ordersList[index].total!=null&&ordersList[index].total != '0'&&ordersList[index].total!=''&&ordersList[index].total!='null'
                    ? Container(
                        width: width * 0.2,
                        child: Text(
                          '\$' + (ordersList[index].total ?? ""),
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(
                        width: width * 0.2,
                      ),
              ],
            ),
            Divider(),
          ],
        ),
      );
}
