import 'dart:io';
import 'dart:typed_data';

import 'package:CLOSSET/models/user.dart';
import 'package:CLOSSET/screens/login_screen.dart';
import 'package:CLOSSET/screens/manufacturer_registration.dart';
import 'package:CLOSSET/utils/colors.dart';
import 'package:CLOSSET/utils/utils.dart';
import 'package:CLOSSET/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController =
      TextEditingController(text: "male");
  final List<CroppedFile?> images = [];
  final picker = ImagePicker();
  bool _isManufacturer = false;
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  addImage() {
    ImageSource source = ImageSource.camera;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Select Image Source",
                style: TextStyle(
                  fontSize: 18,
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("Camera"),
                  leading: const Icon(Icons.camera_alt),
                  onTap: () {
                    source = ImageSource.camera;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Gallery"),
                  leading: const Icon(Icons.photo_album),
                  onTap: () {
                    source = ImageSource.gallery;
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }).then((value) => picker.pickImage(source: source).then((value) {
          if (value == null) return;
          ImageCropper()
              .cropImage(
                  aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                  compressQuality: 100,
                  compressFormat: ImageCompressFormat.jpg,
                  uiSettings: [
                    AndroidUiSettings(
                        toolbarTitle: 'Crop Image',
                        // toolbarColor: GlobalStyle.primaryColor,
                        toolbarWidgetColor: Colors.white,
                        // activeControlsWidgetColor: GlobalStyle.primaryColor,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: false)
                  ],
                  sourcePath: value.path)
              .then((value) {
            if (value == null) return;
            setState(() {
              images.add(value);
            });
          });
        }));
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, 'Please fill all the fields');
      return;
    }
    User user = User(
      id: 0,
      name: _usernameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      profile_image: '',
      gender: _genderController.text,
      password: _passwordController.text,
    );
    String res = ""; // "Some error occurred
    User.registerUser(user, images.isNotEmpty ? images[0]!.path : "")
        .catchError(
      (error) {
        res = error.toString();
      },
    ).then((value) {
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => _isManufacturer
              ? ManufacturerRegistration(
                  userId: value.id,
                )
              : const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: SizedBox(
              width: double.infinity,
              // height: MediaQuery.of(context).size.height + 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/ic_instagram.svg',
                    color: primaryColor,
                    height: 64,
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  Stack(
                    children: [
                      images.isNotEmpty
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: FileImage(File(
                                images[0]!.path,
                              )),
                              backgroundColor: Colors.red,
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundColor: Colors.red,
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: addImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                    hintText: 'Enter your username',
                    textInputType: TextInputType.text,
                    textEditingController: _usernameController,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                    hintText: 'Enter your email',
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    textEditingController: _passwordController,
                    isPass: true,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                    hintText: 'Enter your Mobile Number',
                    textInputType: TextInputType.number,
                    textEditingController: _phoneController,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Row(
                      children: [
                        const Expanded(child: Text("Gender")),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                              items: const [
                                DropdownMenuItem(
                                  value: "male",
                                  child: Text("male"),
                                ),
                                DropdownMenuItem(
                                  value: "female",
                                  child: Text("feamle"),
                                )
                              ],
                              onChanged: ((value) {
                                _genderController.text = value!;
                              })),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _isManufacturer,
                        onChanged: (value) {
                          setState(() {
                            _isManufacturer = value!;
                          });
                        },
                      ),
                      const Text("Are you a manufacturer?"),
                    ],
                  ),
                  InkWell(
                    onTap: signUpUser,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        color: blueColor,
                      ),
                      child: !_isLoading
                          ? const Text(
                              'Sign up',
                            )
                          : const CircularProgressIndicator(
                              color: primaryColor,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Already have an account?',
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            ' Login.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
