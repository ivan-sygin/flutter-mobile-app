import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sochi/api/main_api/main_api.dart';
import 'package:sochi/api/map/map_api.dart';
import 'package:sochi/pages/page_selector.dart';
import 'package:sochi/storages/requests_storage.dart';

class CreatingPositionPage extends StatefulWidget {
  const CreatingPositionPage({super.key, required this.url});
  final String url;
  @override
  State<CreatingPositionPage> createState() => _CreatingPositionPageState();
}

class _CreatingPositionPageState extends State<CreatingPositionPage> {
  String? locationData;
  LocationData? _locationData;
  bool _isLoadingPosition = false;

  bool _loading = false;
  Future getPosition() async {
    setState(() {
      _isLoadingPosition = true;
    });
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          // tochno postavit

          _isLoadingPosition = false;
        });
        return;
      }
    }
    _locationData = await location.getLocation();
    setState(() {
      _isLoadingPosition = false;
    });
  }

  String urlForImage() {
    if (_locationData == null)
      return MapApi.urlRandom();
    else
      return MapApi.urlForMap(
          _locationData!.longitude, _locationData!.latitude);
  }

  void completeCreating() async {
    if (_locationData != null) {
      setState(() {
        _loading = true;
      });
      final req = await MainApi.addNewRequest("pohren", widget.url,
          _locationData!.longitude, _locationData!.latitude);

      if (req.error == null) {
        final requestStorage =
            Provider.of<RequestStorage>(context, listen: false);
        requestStorage.addRequestLocal(req);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(req.error!)));
      }
      setState(() {
        _loading = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PageSelector()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Прикрепите адрес",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Это поможет нам найти магазин с возможным нарушением",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (!_isLoadingPosition)
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 4,
                                    color: Colors.black26,
                                    offset: Offset(0, 3))
                              ],
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(urlForImage()))),
                        ),
                      )
                    else
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 4,
                                  color: Colors.black26,
                                  offset: Offset(0, 3))
                            ],
                          ),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    if (!_isLoadingPosition && _locationData == null)
                      Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: () => getPosition(),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_location_alt_outlined,
                                    size: 32,
                                  ),
                                  Text(
                                    "Прикрепить позицию",
                                    style: TextStyle(fontSize: 24),
                                  )
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () => completeCreating(),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          "Продолжить",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.normal),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            if (_loading)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black54,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 20,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Проверяем Вашу заявку",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
