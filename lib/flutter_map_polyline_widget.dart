import 'dart:async';

import 'package:background_geolocation_sample/app_db.dart';
import 'package:background_geolocation_sample/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FlutterMapPolylineWidget extends StatefulWidget {
  const FlutterMapPolylineWidget({Key? key}) : super(key: key);

  @override
  State<FlutterMapPolylineWidget> createState() => _FlutterMapPolylineWidgetState();
}

class _FlutterMapPolylineWidgetState extends State<FlutterMapPolylineWidget> {
  late Future<List<Polyline>> polylines;
  late List<Location> allPoints;
  late List<Location> points;
  late StreamSubscription _streamSubscription;
  bool justMapMatchedPoints = false;
  int accuracy = 25;

  Future<List<Polyline>> getPolylines() async {
    allPoints = (justMapMatchedPoints
            ? await AppDB.dbInstance!.locationDao.getAllMapMatchedLocations()
            : await AppDB.dbInstance!.locationDao.getAll()) ??
        [];
    points = allPoints.where((element) => (element.accuracy ?? 1000) <= accuracy).toList();
    final polyLines = [
      Polyline(
        points: points
            .map((e) => LatLng(
                  e.lat ?? 0.0,
                  e.lng ?? 0.0,
                ))
            .toList(),
        strokeWidth: 4,
        color: Colors.blue,
      ),
    ];
    return polyLines;
  }

  @override
  void initState() {
    AppDB db = AppDB.dbInstance!;
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      debugPrint('New Location');
      db.locationDao.insert(Location.fromBGLocation(location));
    });
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {});
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {});

    bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 5.0,
      stopOnTerminate: false,
      startOnBoot: true,
      debug: true,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
    )).then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });
    bg.BackgroundGeolocation.changePace(true);

    polylines = getPolylines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FutureBuilder<List<Polyline>>(
        future: polylines,
        builder: (BuildContext context, AsyncSnapshot<List<Polyline>> snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: FlutterMap(
                        options: MapOptions(
                          center: points.isNotEmpty
                              ? LatLng(
                                  points.last.lat!,
                                  points.last.lng!,
                                )
                              : LatLng(
                                  36.322062,
                                  59.5236709,
                                ),
                          zoom: 12,
                          onTap: (tapPosition, point) {
                            setState(() {
                              debugPrint('onTap');
                            });
                          },
                        ),
                        layers: [
                          TileLayerOptions(
                            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: ['a', 'b', 'c'],
                            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                          ),
                          PolylineLayerOptions(
                            polylines: snapshot.data!,
                            polylineCulling: true,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${allPoints.length} :Total '),
                          Text('${points.length} :Filtered '),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                polylines = getPolylines();
                              });
                            },
                            icon: const Icon(Icons.refresh),
                          )
                          // Row(
                          //   children: [
                          //     Text(
                          //       'Accuracy: $accuracy',
                          //     ),
                          //     const SizedBox(width: 20),
                          //     Expanded(
                          //       child: SfLinearGauge(
                          //         minimum: 0.0,
                          //         maximum: 50,
                          //         orientation: LinearGaugeOrientation.horizontal,
                          //         showLabels: true,
                          //         majorTickStyle: const LinearTickStyle(length: 0),
                          //         animateAxis: true,
                          //         markerPointers: [
                          //           LinearShapePointer(
                          //             value: accuracy.toDouble(),
                          //             shapeType: LinearShapePointerType.invertedTriangle,
                          //             dragBehavior: LinearMarkerDragBehavior.free,
                          //             onChanged: (newValue) {
                          //               setState(() {
                          //                 accuracy = newValue.toInt();
                          //                 polylines = getPolylines();
                          //               });
                          //             },
                          //           )
                          //         ],
                          //         animationDuration: 1000,
                          //         minorTickStyle: const LinearTickStyle(length: 0),
                          //         axisTrackStyle: LinearAxisTrackStyle(
                          //           color: Colors.grey,
                          //           edgeStyle: LinearEdgeStyle.bothCurve,
                          //           thickness: 10.0,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: snapshot.connectionState == ConnectionState.waiting,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Getting map data'));
        },
      ),
    );
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
