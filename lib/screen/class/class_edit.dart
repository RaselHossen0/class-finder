import 'package:class_rasel/Global.dart';
import 'package:class_rasel/screen/class/class_details.dart';
import 'package:class_rasel/screen/location/locationSelect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/class.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../models/class.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditClassController extends StateNotifier<ClassModel> {
  EditClassController(this.classId, this.token) : super(ClassModel.initial());
  final String classId;
  final String token;

  Future<void> fetchClassData() async {
    const String baseUrl = "https://classroom-api.raselhossen.tech";
    final response = await http.get(
      Uri.parse("$baseUrl/classes/$classId"),
      headers: {'Authorization': "Bearer $token"},
    );
    if (response.statusCode == 200) {
      state = ClassModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load class data');
    }
  }

  Future<void> updateClassData(String name, String description, String location,
      int price, String categoryId) async {
    const String baseUrl = "https://classroom-api.raselhossen.tech";
    EasyLoading.show(status: 'Updating...');
    final response = await http.put(
      Uri.parse("$baseUrl/classes/$classId"),
      headers: {
        'Authorization': "Bearer $token",
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'description': description,
        'location': location,
        'price': price,
        "categoryId": categoryId,
      }),
    );
    final responseBody = json.decode(response.body);
    if (response.statusCode == 200) {
      state = state.copyWith(name: name, description: description);

      EasyLoading.dismiss();
    } else {
      EasyLoading.showError(
          responseBody["error"]?.toString() ?? 'Failed to update class data');
    }
    if (response.statusCode == 200) {
      state = state.copyWith(name: name, description: description);
    } else {
      throw Exception('Failed to update class data');
    }
  }
}

final editClassProvider =
    StateNotifierProvider.family<EditClassController, ClassModel, String>(
  (ref, classId) {
    final box = GetStorage();
    String tk = box.read('token') ?? "";
    return EditClassController(classId, tk)..fetchClassData();
  },
);

class EditClassScreen extends ConsumerStatefulWidget {
  final ClassModel classModel;
  EditClassScreen({Key? key, required this.classModel}) : super(key: key);

  @override
  _EditClassScreenState createState() => _EditClassScreenState();
}

class _EditClassScreenState extends ConsumerState<EditClassScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  late TextEditingController priceController;
  late LatLng selectedLocation;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.classModel.name);
    descriptionController =
        TextEditingController(text: widget.classModel.description);
    locationController =
        TextEditingController(text: widget.classModel.location);
    priceController =
        TextEditingController(text: widget.classModel.price.toString());
    selectedLocation =
        LatLng(widget.classModel.coords.lat, widget.classModel.coords.lng);
  }

  Future<void> _pickLocation(BuildContext context) async {
    LatLng? newLocation = await displayLocationSelector(
      context,
      selectedLocation,
      locationController,
    );
    if (newLocation != null) {
      setState(() {
        selectedLocation = newLocation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Class")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Class Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                await DisplayLocationSelector(
                    context,
                    LatLng(widget.classModel.coords.lat,
                        widget.classModel.coords.lng),
                    locationController,
                    false,
                    selectedLocation);
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: "Location",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.map),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await ref
                      .read(editClassProvider(widget.classModel.id.toString())
                          .notifier)
                      .updateClassData(
                        nameController.text,
                        descriptionController.text,
                        locationController.text,
                        int.parse(priceController.text),
                        widget.classModel.category.id.toString(),
                      );
                  await ref.read(classProvider.notifier).refresh();
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16),
                  ),
                  backgroundColor: MaterialStateProperty.all(cPrimaryColor),
                ),
                child: const Text("Save Changes",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<LatLng?> displayLocationSelector(
    BuildContext context,
    LatLng initialLocation,
    TextEditingController searchLocationController) async {
  LatLng? selectedLocation = initialLocation;
  GoogleMapController? mapController;
  Set<Marker> markers = {
    Marker(
      markerId: MarkerId('initial_marker'),
      position: initialLocation,
      infoWindow: InfoWindow(title: 'Selected Location'),
    ),
  };

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Select Location"),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialLocation,
            zoom: 14,
          ),
          markers: markers,
          onMapCreated: (controller) {
            mapController = controller;
          },
          onTap: (LatLng position) {
            markers.clear();
            markers.add(
              Marker(
                markerId: MarkerId('selected_marker'),
                position: position,
                infoWindow: InfoWindow(title: 'Selected Location'),
              ),
            );
            selectedLocation = position;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, selectedLocation),
          child: const Text("Select"),
        ),
      ],
    ),
  );

  return selectedLocation;
}
