
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:monsalondz/screens/salon/SalonScreen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import '../models/Salon.dart';
import '../services/location_services.dart';
import 'HistouriqueLocal.dart';
import 'SalonProvider.dart';


class MapsProvider extends ChangeNotifier {
  List<Placemark> locations = [];
  LatLng? latLng;
  String? myLocationString;
  String? myWilaya;
  Set<Marker> markers = {};
  BuildContext? context;

  clear(){
    locations.clear();
    myLocationString = "";
    myWilaya = "";
    markers.clear();
    notifyListeners();
  }

  Future<void> getMyLocation() async {
    clear();
    LocationData mylocation = await LocationService().getLocation();
    latLng = LatLng(mylocation.latitude!, mylocation.longitude!);
    List<Placemark> locationss = await placemarkFromCoordinates(mylocation.latitude!, mylocation.longitude!,localeIdentifier:'en' );
    myLocationString = "${locationss.first.subAdministrativeArea} ${locationss.first.administrativeArea} ${locationss.first.country}";
    myWilaya = "${locationss.first.administrativeArea}".split(" ").first;
    //await setMarker('0', latLng!,"You!",myLocationString);
    await getCloseSalons(myWilaya!);
    notifyListeners();
  }

  Future<void> setMarker(String id, LatLng currentLocation, String? salonName, String? salonLocation, dynamic salon) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(currentLocation.latitude, currentLocation.longitude);

    BitmapDescriptor markIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(15, 15),devicePixelRatio: 15),
      'assets/icons/salon.png'
    );
    Marker newMarker = Marker(
      markerId: MarkerId(id),
      position: currentLocation,
      infoWindow: InfoWindow(
        onTap: (){
          if(salon != null){
            Provider.of<HistoryProvider>(context!,listen: false).setSalonsHistory(salon);
            Provider.of<SalonProvider>(context!,listen: false).search = true;
            Provider.of<SalonProvider>(context!,listen: false).clearSalon();
            Timer(const Duration(milliseconds: 200),(){
              PersistentNavBarNavigator.pushNewScreen(context!,
                screen: SalonScreen(salon: salon,),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.slideUp,
              );
            });
          }

        },
        title: salonName?.toUpperCase(),
        snippet: "${placemarks.first.street}, ${placemarks.first.administrativeArea}, ${placemarks.first.country} "
      ),
      icon: markIcon,
    );
    markers.add(newMarker);
    notifyListeners();
  }


  getCloseSalons(String wilaya) async{
    await FirebaseFirestore.instance.collection("salon")
        .where("wilaya", isEqualTo: wilaya)
        .get()
    .then((salons) async {

      if(salons.docs.isNotEmpty){
        for (var element in salons.docs) {
          Salon data = Salon.fromJson(element.data());
          data.id = element.id;
          if(element.data()["latitude"] != null && element.data()["longitude"] != null) await setMarker(data.id!, LatLng(data.latitude!,data.longitude!), data.nom,data.location, data);
        }
      }
      notifyListeners();
    });
  }
}