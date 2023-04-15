// ignore_for_file: avoid_unnecessary_containers
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:monsalondz/providers/MapsProvider.dart';
import 'package:monsalondz/widgets/Category.dart';
import 'package:monsalondz/widgets/Populars.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import '../../../services/location_services.dart';
import 'package:location/location.dart';
import '../theme/colors.dart';
import '../widgets/Pubs.dart';
import '../widgets/Recent.dart';
import '../widgets/RecentSearch.dart';
import '../widgets/SearchBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController? _scrollController;
  bool lastStatus = true;
  double height = 200;

  void _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController != null && _scrollController!.hasClients &&
        _scrollController!.offset > (height - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: false,
      controller: _scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver:  SliverSafeArea(
              top: false,
              sliver: SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                floating: false,
                forceElevated: false,
                elevation: 0,
                backgroundColor: Colors.white,
                title: AnimatedSwitcher(
                  key: const Key("show"),
                  duration: const Duration(milliseconds: 200),
                  child: isShrink ?
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Image.asset("assets/images/logo.png",height: kToolbarHeight-10,),
                  ):
                  const SizedBox(key: Key("not"),
                  ),
                ),
                flexibleSpace: const FlexibleSpaceBar(
                  background: SafeArea(child: Search()),
                ),
              ),
            ),
          )
        ];
      },
      body: const HomeBody(),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          children: [

            // SERACH
            //const Search(),
            //const SizedBox(height: 25,),
            const Pubs(),
            const SizedBox(height: 25,),

            //Categories
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 12),
                child: const Text(
                  "Découvrir les soins",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Container(
                height: 650,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: const ListCatigories()),
            const SizedBox(height: 25,),

            //Populars
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 12,bottom: 15),
                child: const Text(
                  "Meilleurs Salons",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 300, child: Populars()),
           

            //Recent
            const RecentItem(),
            const SizedBox(height: 25,),

            //Search History
            const RecentSearch(),

            const SalonNearOfMe(),

            const SizedBox(height: 70,),

          ],
        ),
      ),
    );
  }
}


class SalonNearOfMe extends StatelessWidget {
  const SalonNearOfMe({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.28,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/maps.jpg"),fit: BoxFit.cover,),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Center(
        child: ElevatedButton(
          onPressed:(){
            EasyLoading.show();
            Provider.of<MapsProvider>(context,listen: false).getMyLocation().then((v) async {
              PersistentNavBarNavigator.pushNewScreen(context,
                screen: const MapSample(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.slideUp,
              );
            }).whenComplete(() => EasyLoading.dismiss());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            fixedSize: const Size(double.maxFinite, 50),
            elevation: 10,
            foregroundColor: clr3,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Salons à proximité",style: TextStyle(color: Colors.white,fontSize: 20),),
              SizedBox(width: 10,),
              Icon(Icons.location_on_outlined,color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  CameraPosition myLocation = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    Provider.of<MapsProvider>(context,listen: false).context = context;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<MapsProvider>(
        builder: (context, maps, child){
        return GoogleMap(
          mapType: MapType.normal,
          indoorViewEnabled: true,
          zoomControlsEnabled : false,
          initialCameraPosition: CameraPosition(
            target: maps.latLng!,
            zoom: 14.5,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
         markers: maps.markers,
        );
        }
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          onPressed: () => _getMyLocation(),
          backgroundColor: Colors.black,
          child: const Icon(Icons.gps_fixed),
        ),
      ),
    );
  }

  Future<void> _getMyLocation() async {
    //final provider = Provider.of<MapsProvider>(context,listen: false);
    //provider.getMyLocation();
    LocationData _myLocation = await LocationService().getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_myLocation.latitude!, _myLocation.longitude!),
      zoom: 14.5,
    ),));
  }
}


