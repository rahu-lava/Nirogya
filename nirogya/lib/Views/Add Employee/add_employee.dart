import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nirogya/Data/Employee/employee_repo.dart';
import 'package:nirogya/Model/Employee/employee.dart';
import 'package:nirogya/Views/Attendence%20Screen/attendence_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  bool isWhatsAppSame = false;
  XFile? imageFile;
  final EmployeeRepository _employeeRepository = EmployeeRepository();

  @override
  void dispose() {
    super.dispose();
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Capture from Camera'),
            onTap: () async {
              final pickedFile =
                  await picker.pickImage(source: ImageSource.camera);
              if (pickedFile != null) {
                setState(() {
                  imageFile = pickedFile;
                });
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Select from Gallery'),
            onTap: () async {
              final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  imageFile = pickedFile;
                });
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<String> _saveImageToStorage(String employeeId) async {
    if (imageFile == null) {
      throw Exception('No image selected');
    }

    // Get the application documents directory
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String employeeImagesDir =
        path.join(appDocDir.path, 'employee_images');

    // Create the directory if it doesn't exist
    final Directory dir = Directory(employeeImagesDir);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    // Save the image file with the employee ID as the filename
    final String fileExtension = path
        .extension(imageFile!.path); // Get file extension (e.g., .jpg, .png)
    final String savedImagePath =
        path.join(employeeImagesDir, '$employeeId$fileExtension');
    final File savedImage = File(savedImagePath);
    await savedImage.writeAsBytes(await imageFile!.readAsBytes());

    return savedImagePath;
  }

  void _saveEmployee() async {
    if (nameController.text.isEmpty ||
        contactController.text.isEmpty ||
        dateController.text.isEmpty ||
        imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and upload an image!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Generate a unique ID for the employee
      final String employeeId =
          DateTime.now().millisecondsSinceEpoch.toString();

      // Save the image to storage using the employee ID as the filename
      final String imagePath = await _saveImageToStorage(employeeId);

      // Parse the date of joining
      final List<String> dateParts = dateController.text.split('/');
      final DateTime dateOfJoining = DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
      );

      // Create the Employee object
      final Employee employee = Employee(
        id: employeeId, // Use the generated unique ID
        name: nameController.text,
        contact: contactController.text,
        profileImage: imagePath,
        dateOfJoining: dateOfJoining,
      );

      // Save the employee using the repository
      await _employeeRepository.addEmployee(employee);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Employee saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to the attendance screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AttendanceScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save employee: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Input
                  const Text(
                    'Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: nameController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                          12), // Limit to 10 digits
                    ],
                    decoration: InputDecoration(
                      hintText: 'Enter employee name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Contact Input
                  const Text(
                    'Contact Number',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: contactController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Allow only digits
                      LengthLimitingTextInputFormatter(
                          10), // Limit to 10 digits
                    ],
                    decoration: InputDecoration(
                      hintText: 'Enter employee contact number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isWhatsAppSame,
                        onChanged: (value) {
                          setState(() {
                            isWhatsAppSame = value!;
                          });
                        },
                      ),
                      const Text('WhatsApp number is the same'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Image Upload
                  const Text(
                    'Profile Image',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[200],
                      ),
                      child: imageFile == null
                          ? const Center(
                              child: Text('Tap to upload image'),
                            )
                          : Image.file(
                              File(imageFile!.path),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Date Picker
                  const Text(
                    'Date of Joining',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: InputDecoration(
                      hintText: 'Select date of joining',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Fixed Save Button at the Bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveEmployee,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Save Employee',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
