import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:jiffy/jiffy.dart';
import 'package:weather_app/models/Forecast.dart';

class DetailPage extends StatefulWidget {
  final Forecast? forecast;
  const DetailPage({Key? key, this.forecast}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  DateTime now = DateTime.now();
  String formattedDate = "";
  String path = "assets/images";
  String img = "";
  @override
  void initState() {
    super.initState();
    formattedDate = Jiffy(now).format('MMM do yy');
    setBackground();
  }

  void setBackground() {
    if (widget.forecast != null) {
      if (widget.forecast!.description.contains("sunny") ||
          widget.forecast!.description.contains("clear")) {
        img = "sun.jpg";
      } else if(widget.forecast!.description.contains("cloud") || widget.forecast!.description.contains("rain")) {
        img = "rainy.jpg";
      } else {
        img = "snow.jpg";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              "$path/$img",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.black45),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.forecast?.city}",
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            ?.copyWith(color: Colors.white),
                      ),
                      Text(
                        formattedDate,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.forecast?.temp}°C",
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            ?.copyWith(color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.cloudy_snowing,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.forecast?.description ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            widget.forecast?.description ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: Colors.white),
                          ),
                          Text(
                            "${widget.forecast?.wind}",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(color: Colors.white),
                          ),
                          Text(
                            "km/h",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: Colors.white),
                          ),
                          _progressBar(widget.forecast?.wind.toDouble() ?? 0)
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Feels Like",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${widget.forecast?.feels_like}°C",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Humidity",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: Colors.white),
                          ),
                          Text(
                            "${widget.forecast?.humidity}",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(color: Colors.white),
                          ),
                          Text(
                            "%",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: Colors.white),
                          ),
                          _progressBar(
                              widget.forecast?.humidity.toDouble() ?? 0)
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  SizedBox _progressBar(double value) {
    return SizedBox(
      height: 10,
      width: 75,
      child: FAProgressBar(
        direction: Axis.horizontal,
        changeColorValue: 50,
        animatedDuration: const Duration(seconds: 1),
        currentValue: value,
        backgroundColor: Colors.white,
        progressColor: Colors.blue,
        changeProgressColor: Colors.red,
      ),
    );
  }
}
