import 'package:flutter/material.dart';
import 'firestore/Repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:my_app/model/LocationInfo.dart';
import 'package:location/location.dart';



class SearchPeopleWidget extends StatefulWidget{

  @override
  State createState() => SearchPeopleState();
}

class SearchPeopleState extends State<SearchPeopleWidget> {
  FirebaseUser user;

  bool isLocationKnown = false;
  Location location = Location();
  Map<String, double> currentLocation;


  @override
  void initState() {

    location.onLocationChanged().listen((value) {
      print('location changed');
      currentLocation = value;
      repository.updatePosition(currentLocation["latitude"].toString(), currentLocation["longitude"].toString());
      if(!isLocationKnown) {
        repository.fetchLocationInfo(currentLocation["latitude"].toString(),
            currentLocation["longitude"].toString()).then((loc) {
          print('FORMATTED ' + loc.formatted);
          isLocationKnown = true;
          repository.updateLocationInfo(loc.formatted);
        });
      }

    });

    authService.getCurrentUser().then((firebaseUser) {
      setState(() {
        user = firebaseUser;
      });
    });

  }


  double degreesToRadians(double degrees) {
    return degrees * 3.14159 / 180;
  }

  double distanceInKmBetweenEarthCoordinates(
      double lat1, double lon1, double lat2, double lon2) {
    var earthRadiusKm = 6371;

    var dLat = degreesToRadians(lat2 - lat1);
    var dLon = degreesToRadians(lon2 - lon1);

    lat1 = degreesToRadians(lat1);
    lat2 = degreesToRadians(lat2);

    var a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }


  @override
  Widget build(BuildContext context) {
    if(user == null) {
      return Text('loading..');
    }else {
      return new Scaffold(
          body: Container(
          child: Column(
          children: <Widget>[
          Text('People around you: ',
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
          ),
          Flexible(
            child: new StreamBuilder(
              stream: repository.getPeopleAroundYou(),
              builder: (context, snapshot) {
                return StreamBuilder(
                    stream: repository.getCurrentUser(user.uid),
                    builder: (context, currentUserSnapshot) {
                      if (snapshot.hasData) {
                        return new ListView.builder(
                          padding: new EdgeInsets.all(8.0),
                          reverse: false,
                          itemBuilder: (_, int index) {
                            var currentUser = currentUserSnapshot.data.documents[0];

                            DocumentSnapshot document =
                            snapshot.data.documents[index];
                            var lat = document['lat'].toString() == "null" ? "-" : document['lat'].toString();
                            var lon = document['lon'].toString() == "null" ? "-" : document['lon'].toString();
                            var email = document['email'].toString() == "null" ? "-" : document['email'].toString();
                            var latCurrentUser = currentUser['lat'].toString() == "null" ? "-" : currentUser['lat'].toString();
                            var lonCurrentUser = currentUser['lon'].toString() == "null" ? "-" : currentUser['lon'].toString();
                            var status = document['status'].toString() == "null" ? "-" : document['status'].toString();
                            var locationInfo = document['locationInfo'].toString() == "null" ? "-" : document['locationInfo'].toString();
                            var distance = "-";

                            print('test: ' + lat + ' ' + lon + ' ' + latCurrentUser + ' ' + lonCurrentUser);
                            if (lat != "-" && lon != "-" && latCurrentUser != "-" && lonCurrentUser != "-") {
                              print(lat);
                              double latD = double.parse(lat);
                              double lonD = double.parse(lon);
                              double latCurrentUserD = double.parse(latCurrentUser);
                              double lonCurrentUserD = double.parse(lonCurrentUser);
                              print('DISTANCE: ' + distanceInKmBetweenEarthCoordinates(latD, lonD, latCurrentUserD, lonCurrentUserD).toString());
                              distance = distanceInKmBetweenEarthCoordinates(latD, lonD, latCurrentUserD, lonCurrentUserD).toStringAsFixed(1);
                            }

                            return peopleItem(email, lat, lon, status, distance, locationInfo);
                          },
                          itemCount: snapshot.data.documents.length,
                        );
                      } else {
                        return Container();
                      }
                    });
              }))
          ])));
    }

  }
}

Widget peopleItem(String nickname, String lat, String lon, String status, String distance, String locationInfo) {
  return Container(
      decoration: new BoxDecoration(
        color: Colors.amber,
        borderRadius: new BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10.0),
          Text(nickname),
          Text(lat + ', ' + lon),
          Text(status),
          Text(distance),
          Text(locationInfo),
          SizedBox(
            height: 10.0,
          ),
        ],
      ));
}
