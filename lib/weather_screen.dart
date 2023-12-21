import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/additional_info_data.dart';
import 'package:flutter_weather_app/hourly_forecast_card.dart';
import 'package:flutter_weather_app/secrets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  double temp = 0;
 

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String city = 'Jaipur';
      final result = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$openWeatherApiKey"));
      final data = jsonDecode(result.body);

      if (data['cod'] != '200') {
        throw data['message'];
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }
   @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          final currentInfo = data['list'][0];
          final currentTemp = currentInfo['main']['temp'];
          final currentSky = currentInfo['weather'][0]['main'];
          final humidity = currentInfo['main']['humidity'];
          final windSpeed = currentInfo['wind']['speed'];
          final pressure = currentInfo['main']['pressure'];

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
              
                  // box1(),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 66, 64, 64),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3.0,
                            offset: Offset(2.0, 2.0))
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                "$currentTemp K",
                                style: const TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 50,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "$currentSky",
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                        // ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  // header1(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: const Text(
                          "Weather Forecast",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                        itemCount: 7,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final time =
                              DateTime.parse(data['list'][index + 1]['dt_txt']);
                          return HourlyForecastCard(
                            time: DateFormat.Hm().format(time),
                            value: data['list'][index + 1]['main']['temp']
                                .toString(),
                            icon: data['list'][index + 1]['weather'][0]
                                            ['main'] ==
                                        'Clouds' ||
                                    data['list'][index + 1]['weather'][0]
                                            ['main'] ==
                                        'rain'
                                ? Icons.cloud
                                : Icons.sunny,
                          );
                        }),
                  ),

                  const SizedBox(height: 20),
                  // header2(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: const Text(
                          "Additional Information",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  // additionalInfo(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalInfoData(
                          icon: Icons.water_drop,
                          data: "Humidity",
                          value: "$humidity".toString(),
                        ),
                        AdditionalInfoData(
                          icon: Icons.air,
                          data: 'Wind Speed',
                          value: '$windSpeed'.toString(),
                        ),
                        AdditionalInfoData(
                          icon: Icons.beach_access,
                          data: 'Pressure',
                          value: "$pressure".toString(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
