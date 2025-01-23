import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

class CustomFilePicker extends StatefulWidget {
  final String label;
  final bool isRequired;
  final Function(String? path) onFileSelected;

  const CustomFilePicker({
    Key? key,
    required this.label,
    required this.onFileSelected,
    this.isRequired = false,
  }) : super(key: key);

  @override
  State<CustomFilePicker> createState() => _CustomFilePickerState();
}

class _CustomFilePickerState extends State<CustomFilePicker> {
  String? _selectedFilePath;

  Future<void> _pickFile(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Select from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  late final pickedFile;
                  try {
                    pickedFile = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                  } on Exception catch (e) {
                    ToastService.showErrorToast(
                      context,
                      length: ToastLength.medium,
                      message: "Failed to pick the Image!",
                    );
                  }
                  try {
                    if (pickedFile != null) {
                      setState(() {
                        _selectedFilePath = pickedFile.path;
                      });
                      widget.onFileSelected(pickedFile.path);
                    }
                  } catch (e) {
                    // TODO
                    ToastService.showErrorToast(
                      context,
                      length: ToastLength.medium,
                      message: "Failed to pick the Image! $e",
                    );
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Capture with Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _selectedFilePath = pickedFile.path;
                    });
                    widget.onFileSelected(pickedFile.path);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            if (widget.isRequired)
              Text(
                " *",
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
          ],
        ),
        SizedBox(height: 5),
        InkWell(
          onTap: () => _pickFile(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red.shade200, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              _selectedFilePath == null
                  ? "Select Images"
                  : _selectedFilePath!.split('/').last,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        ),
      ],
    );
  }
}
