import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viva_two_final_app/modals/quotes.dart';
import 'package:viva_two_final_app/providers/quote_db_helper.dart';
import 'package:viva_two_final_app/utils/globals.dart';
import 'package:viva_two_final_app/views/previus_quote.dart';
import 'dart:developer';

import '../../../utils/colours.dart';

List<List<Quotes>> preQuoteList = [];

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.mood}) : super(key: key);

  String mood;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static bool data = true;
  late Future<List<Quotes>> res;
  List<Quotes> quotes = [];

  mySetState() async {
    await Future.delayed(const Duration(seconds: 3), () async {
      quotes = await res;

      setState(() {});
      mySetState();
    });
  }

  initDatabase() async {
    await QuoteDatabaseHelper.quoteDatabaseHelper.deleteAllData();
    await QuoteDatabaseHelper.quoteDatabaseHelper.insertData(emotionList: emotionQuotes);
    res = QuoteDatabaseHelper.quoteDatabaseHelper.fetchAllData(mood: widget.mood);
    // log(res.toString(), name: "Success");
  }

  deley10Sec() async {
    log(data.toString(), name: "data befour Function");
    if (data == true) {
      await Future.delayed(
        Duration(seconds: 11),
        () async {
          res = QuoteDatabaseHelper.quoteDatabaseHelper.fetchAllData(mood: widget.mood);
          quotes = await res;
          preQuoteList.add(quotes);
          setState(() {});
          quotes = [];
          deley10Sec();
        },
      );
    } else {
      log(data.toString(), name: "data in else");
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDatabase();
    mySetState();
    deley10Sec();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Drawer(
          backgroundColor: gradient1,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            "R",
                            style: TextStyle(color: gradient1, fontWeight: FontWeight.bold, fontSize: 40),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      InkWell(
                        onTap: () {
                          //deley10Sec();
                        },
                        child: Row(
                          children: [
                            Text(
                              'Home',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 520,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: preQuoteList.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Text(
                        'Previus ${i + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        data = false;
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PreviousQuotePage(mood: "${widget.mood}",index: i),
                            ));
                        setState(() {});

                        log(data.toString(), name: "data in LIstTile");
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              gradient1,
              gradient2,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Image.asset(
                        "assets/images/drawer.png",
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "${widget.mood} Quotes..✌",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.restart_alt_outlined,
                      color: Colors.white.withOpacity(
                        0.8,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 610,
                width: 320,
                child: (quotes.isEmpty && quotes.length < 15)
                    ? Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ListView.builder(
                        itemCount: 15,
                        itemBuilder: (context, i) {
                          return Container(
                            padding: EdgeInsets.only(top: 25, bottom: 25, right: 15, left: 15),
                            margin: EdgeInsets.only(bottom: 30),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.7),
                                )),
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                quotes[i].quote,
                                style: TextStyle(
                                  color: Colors.white,
                                  wordSpacing: 1,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
