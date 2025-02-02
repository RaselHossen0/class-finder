import 'dart:io';

import 'package:class_rasel/Global.dart';
import 'package:class_rasel/componants/RoundButton.dart';
import 'package:class_rasel/create_event_service.dart';
import 'package:class_rasel/every%20class/get_controller.dart';
import 'package:class_rasel/models/event.dart';
import 'package:class_rasel/screen/enge/event_show.dart';
import 'package:class_rasel/screen/event/eventProvider.dart';
import 'package:class_rasel/screen/location/locationSelect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

LatLng gett = LatLng(0, 0);

class CreateEditEvent extends ConsumerStatefulWidget {
  final bool isEditMode;
  final Event? event;

  const CreateEditEvent({super.key, required this.isEditMode, this.event});

  @override
  ConsumerState<CreateEditEvent> createState() => _CreateEditEventState();
}

class _CreateEditEventState extends ConsumerState<CreateEditEvent> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final List<File> _selectedImages = [];

  LatLng markerLocation = LatLng(23.8041, 90.4152);
  final cont creatEv = Get.find();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.event != null) {
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description;
      _dateController.text =
          "${widget.event!.createdAt.toLocal()}".split(' ')[0];
      _locationController.text = widget.event!.location;
      markerLocation = widget.event!.coordinates!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  Future<void> _submitEvent() async {
    setState(() {
      isLoading = true;
    });

    EasyLoading.show(
        status: widget.isEditMode ? 'Updating event...' : 'Creating event...');

    try {
      final response = widget.isEditMode
          ? await createOrUpdateEvent(
              _titleController.text,
              _dateController.text,
              _descriptionController.text,
              creatEv.classId!,
              _locationController.text,
              markerLocation,
              _selectedImages,
              creatEv.token,
              isUpdate: true,
              eventId: widget.event!.id,
            )
          : await createOrUpdateEvent(
              _titleController.text,
              _dateController.text,
              _descriptionController.text,
              creatEv.classId!,
              _locationController.text,
              markerLocation,
              _selectedImages,
              creatEv.token,
              isUpdate: false,
            );

      if (response != null &&
          (response.statusCode == 201 || response.statusCode == 200)) {
        await refreshEvents(ref);
        EasyLoading.showSuccess(widget.isEditMode
            ? 'Event updated successfully'
            : 'Event created successfully');
        Get.back();
      } else {
        EasyLoading.showError('Unexpected error occurred. Please try again.');
      }
    } catch (e) {
      print("Error: $e");
      EasyLoading.showError('An error occurred. Please try again.');
    } finally {
      setState(() {
        isLoading = false;
      });
      EasyLoading.dismiss();
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool readOnly = false, VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Select Photos', style: TextStyle(fontSize: 14)),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: cPrimaryColor),
              onPressed: _pickImages,
              child: Text('Pick Images', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        SizedBox(height: 8),
        _selectedImages.isNotEmpty
            ? SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.file(
                        _selectedImages[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              )
            : Center(
                child: Text(
                  'No images selected',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cPrimaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: Text(widget.isEditMode ? 'Edit Event' : 'Create Event',
            style: TextStyle(color: Colors.black)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Event Name', _titleController),
                _buildTextField('Event Description', _descriptionController),
                _buildTextField('Select Date', _dateController,
                    readOnly: true, onTap: _selectDate),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField('Locations', _locationController),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        await DisplayLocationSelector(context, markerLocation,
                            _locationController, false, gett);
                      },
                      child: Text('Select Location',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                _buildImagePicker(),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: cPrimaryColor),
                    onPressed: isLoading ? null : _submitEvent,
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            widget.isEditMode ? 'Update Event' : 'Create Event',
                            style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
