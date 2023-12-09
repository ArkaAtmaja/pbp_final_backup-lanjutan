import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:news_c_kelompok4/database/sql_helper.dart';
import 'package:news_c_kelompok4/addNews/add_item_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:news_c_kelompok4/client/addNews_client.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> item = [];
  TextEditingController searchController = TextEditingController();
  String? imagePath;
  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void refresh(String query) async {
    final data = await SQLHelper.getBerita2(query);
    setState(() {
      item = data;
    });
  }

  @override
  void initState() {
    refresh("");
    getImageFromSharedPreferences("imagePath"); // Load the saved image path
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          IconButton(
  icon: Icon(Icons.add),
  onPressed: () async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItemScreen(
          title: 'Add News',
          id: null,
          judul: null,
          kategori: null,
          deskripsi: null,
          onItemAdded: (Map<String, dynamic> newItem) {
            setState(() {
              // Add the new item to the list
              item.add({
                'id': item.length + 1,
                'judul': newItem['judul'],
                'kategori': newItem['kategori'],
                'deskripsi': newItem['deskripsi'],
                'lokasi': newItem['lokasi'],
              });
            });
          },
        ),
      ),
    );
  },
),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Cari.."),
                    content: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: "Masukkan pencarian",
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text("Search"),
                        onPressed: () {
                          refresh(searchController.text);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: item.length,
        itemBuilder: (context, index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            secondaryActions: [
              IconSlideAction(
                caption: 'Update',
                color: Colors.blue,
                icon: Icons.update,
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddItemScreen(
                        title: 'Update Item',
                        id: item[index]['id'],
                        judul: item[index]['judul'],
                        kategori: item[index]['kategori'],
                        deskripsi: item[index]['deskripsi'],
                        onItemAdded: item[index]['']
                        //lokasi: item[index]['lokasi'],
                      ),
                    ),
                  ).then((_) => refresh(""));
                },
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () async {
                  await deleteBerita(item[index]['id']);
                },
              ),
            ],
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(10.0),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10.0),
                      child: imagePath != null
                          ? Image.file(
                              File(imagePath!),
                              width: 100,
                              height: 70,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'lib/images/cuaca.jpg',
                              width: 100,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item[index]['judul']),
                          Text("Kategori: " + item[index]['kategori']),
                          Text("Deskripsi: " + item[index]['deskripsi']),
                          Text("Lokasi: " + item[index]['lokasi']),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        setState(() {
                          _getCurrentPosition();
                          editLokasi(
                              item[index]['id'], _currentAddress.toString());
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> getImageFromSharedPreferences(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final savedImagePath = prefs.getString(key);
    if (savedImagePath != null) {
      setState(() {
        imagePath = savedImagePath;
      });
    }
  }

  Future<void> deleteBerita(int id) async {
    await SQLHelper.deleteBerita(id);
    refresh("");
  }

  Future<void> editLokasi(int id, String lokasi) async {
    await SQLHelper.editLokasiBerita(id, lokasi);
    refresh(""); // Refresh the list after updating the location
  }
}