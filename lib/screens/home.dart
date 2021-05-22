import 'dart:convert';
import 'dart:io';
import 'package:Aaraam/screens/detail.dart';
import 'package:Aaraam/utilities/Users.dart';
import 'package:Aaraam/utilities/constants.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  @override
  MainPage createState() => MainPage();
}

class MainPage extends State<Home> {
  String user_id = '';
  bool _isLoading = false, noDataviewVisible = false, viewVisible = true;
  List<dtpl> listModel = [];
  List<Data> homedataList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    fetchJSONData();
  }

  fetchJSONData() async {
    String apiURL =
        'https://www.drugvillatechnologies.com/oncology/api/dtpl.php';
    var jsonResponse = await http.get(Uri.parse(apiURL));

    if (jsonResponse.statusCode == 200) {
      var response = json.decode(jsonResponse.body);
      print(jsonResponse.statusCode);
      print(response);
      print(apiURL);

      Map<String, dynamic> map = response;
      String status = map["status"];

      if (status == "1") {
        setState(() {
          _isLoading = false;
          listModel = (response["data"] as List)
              .map<dtpl>((json) => new dtpl.fromJson(json))
              .toList();
          print(listModel.length);
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text(
            "My Bookings",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                letterSpacing: 0.5,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.lightGreen,
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: _isLoading
                ? Shimmer.fromColors(
                    child: ListView.builder(
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.image, size: 50.0),
                          title: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                ),
                                Container(
                                  decoration: shimmerBoxDecorationStyle,
                                  width: double.infinity,
                                  height: 12.0,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                ),
                                Container(
                                  width: 100.0,
                                  height: 12.0,
                                  decoration: shimmerBoxDecorationStyle,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                ),
                                Container(
                                  width: 40.0,
                                  height: 12.0,
                                  decoration: shimmerBoxDecorationStyle,
                                ),
                              ],
                            ),
                            /* height: 20.0,*/
                          ),
                        );
                      },
                    ),
                    baseColor: Color(0xFFE0E0E0),
                    highlightColor: Colors
                        .black12) /*Center(child: CircularProgressIndicator())*/
                : GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Stack(children: <Widget>[
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: listModel.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _tile(context, index);
                        },
                      ),
                    ]))));
  }

  ListTile _tile(BuildContext context, int index) => ListTile(
        title: Container(
            child: Padding(
          padding: EdgeInsets.only(left: 20.0, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                listModel[index].heading,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontFamily: 'OpenSans',
                ),
              ),
              SizedBox(height: 10),
              Text(
                listModel[index].description,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black45,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans'),
              ),
              SizedBox(height: 10),
              Container(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: listModel[index].homedata.length,
                  itemBuilder: (context, int index_sub) {
                    return CategoryCard(
                      imageAssetUrl: listModel[index].homedata[index_sub].image,
                      categoryName: listModel[index]
                          .homedata[index_sub]
                          .doctor_category_name,
                      name: listModel[index].homedata[index_sub].doctor_name,
                      experience:
                          listModel[index].homedata[index_sub].experience,
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        )),
      );
}

class CategoryCard extends StatelessWidget {
  final String imageAssetUrl, categoryName, name, experience;

  CategoryCard(
      {required this.imageAssetUrl,
      required this.categoryName,
      required this.name,
      required this.experience});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(right: 14, bottom: 2),
        child: Stack(
          children: <Widget>[
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7.0, vertical: 7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5.0),
                    ]),
                alignment: Alignment.center,
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                          'https://www.drugvillatechnologies.com/oncology/adminpanel/doctor/' +
                              imageAssetUrl),
                    ),
                    SizedBox(height: 7),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      categoryName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: 14,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 5),
                    Text(
                      experience,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: 14,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
