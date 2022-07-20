import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:weather_app/models/Forecast.api.dart';
import 'package:weather_app/models/Forecast.dart';
import 'package:weather_app/screens/detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double appbarHeight = 300;
  final double containerwidth = 375;
  final double containerHeight = 250;
  List<String> cities = ["Gaziantep", "Moscow", "Istanbul", "Izmir", "Dili"];
  List<Forecast?> citiesForecasts = [];

  ForecastApi forecastClient = ForecastApi();
  Forecast? forecast;
  Forecast? weather;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<List<Forecast?>> getDatas() async {
    for (var city in cities) {
      forecast = await forecastClient.getCurrentForecast(city);
      citiesForecasts.add(forecast);
    }
    return citiesForecasts;
  }

  Future<Forecast?> getData() async {
    weather = await forecastClient.getCurrentForecast("Moscow");
    return weather;
  }

  @override
  Widget build(BuildContext context) {
    final double top = appbarHeight - containerHeight + containerHeight / 2;
    final backgroundColor = Color(0xFFE7ECEF);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          _customAppbar(top, backgroundColor, weather),
          SizedBox(height: 150),
          _forecastsListView(backgroundColor)
        ],
      ),
    );
  }

  FutureBuilder<List<Forecast?>> _forecastsListView(Color backgroundColor) {
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var list = snapshot.data;
            return SizedBox(
              height: 175,
              child: ListView.builder(
                  clipBehavior: Clip.none,
                  itemCount: list!.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((context, index) {
                    Forecast? city = list[index];
                    if (city != null) {
                      return GestureDetector(
                        onTap: (() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                        forecast: city,
                                      )));
                        }),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          width: 150,
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 30.0,
                                    offset: Offset(-28, -28),
                                    color: Colors.white),
                                BoxShadow(
                                    blurRadius: 30.0,
                                    offset: Offset(28, 28),
                                    color: Color(0xFFA7A9AF))
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  city.city,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(color: Colors.black54),
                                ),
                              ),
                              Text("${city.temp}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(color: Colors.black54)),
                              Image.asset(
                                "assets/images/weather.png",
                                width: 40,
                                height: 40,
                              ),
                              Text(city.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(color: Colors.black54)),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Center();
                    }
                  })),
            );
          } else
            return Center();
        });
  }

  Container _customAppbar(
      double top, Color backgroundColor, Forecast? weather) {
    return Container(
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(30)),
              child: Image.asset(
                "assets/images/appbar.jpg",
                height: appbarHeight,
                width: double.infinity,
                fit: BoxFit.fill,
              )),
          FutureBuilder<Forecast?>(
              future: getData(),
              builder: (context, snap) {
                if (snap.hasData) {
                  var forecast = snap.data;
                  return _mainContainer(top, backgroundColor, forecast);
                } else
                  return Center();
              }),
          _searchTexfield(),
        ],
      ),
    );
  }

  Positioned _mainContainer(
      double top, Color backgroundColor, Forecast? forecast) {
    return Positioned(
        top: top,
        child: Column(
          children: [
            Container(
              height: containerHeight,
              width: containerwidth,
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 30.0,
                        offset: Offset(28, 28),
                        color: Color(0xFFA7A9AF))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Center(
                        child: Text(
                      forecast?.city ?? "",
                      style: Theme.of(context).textTheme.headline5,
                    )),
                  ),
                  Divider(thickness: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            forecast?.description ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(color: Colors.black45),
                          ),
                          Text(
                            "${forecast?.temp}",
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                ?.copyWith(color: Colors.black45),
                          ),
                          Text(
                            "Feels like: ${forecast?.feels_like}",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset(
                            "assets/images/weather.png",
                            height: 80,
                            width: 80,
                          ),
                          Text(
                            "humidity:${forecast?.humidity}",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Positioned _searchTexfield() {
    return Positioned(
      top: 100,
      child: Container(
        width: containerwidth,
        height: 50,
        child: const TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0),
            ),
            hintText: "SEARCH",
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
