import 'dart:io';

import 'package:CLOSSET/models/designer.dart';
import 'package:CLOSSET/models/post.dart';
import 'package:CLOSSET/models/user.dart';
import 'package:CLOSSET/providers/designer_provider.dart';
import 'package:CLOSSET/providers/user_provider.dart';
import 'package:CLOSSET/screens/desinger_registration.dart';
import 'package:CLOSSET/utils/colors.dart';
import 'package:CLOSSET/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  final List<CroppedFile?> images = [];
  final picker = ImagePicker();
  Designer? designer;

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

  void postImage() async {
    setState(() {
      isLoading = true;
    });
    User user = Provider.of<UserProvider>(context, listen: false).user;
    Post post = Post(
      id: 0,
      designerID: designer?.id ?? 0,
      clothType: "shirt",
      material: "cotton",
      price: 100,
      description: _descriptionController.text,
      time: DateTime.now(),
      image: "",
      likeCount: 0,
      commentCount: 0,
      viewCount: 0,
    );

    Post.createPost(post, images.isNotEmpty ? images[0]!.path : "");

    try {
      String res = "success";
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
        }
        clearImage();
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      // _descriptionController.clear();
      images.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  void didChangeDependencies() {
    designer = Provider.of<DesignerProvider>(context).designer;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return designer?.id == 0
        ? const DesingerRegistrationPage()
        : Container(
            child: images.isEmpty
                ? Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.upload,
                      ),
                      onPressed: addImage,
                    ),
                  )
                : Scaffold(
                    appBar: AppBar(
                      backgroundColor: mobileBackgroundColor,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: clearImage,
                      ),
                      title: const Text(
                        'Post to',
                      ),
                      centerTitle: false,
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => postImage(),
                          child: const Text(
                            "Post",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                        )
                      ],
                    ),
                    // POST FORM
                    body: Column(
                      children: <Widget>[
                        isLoading
                            ? const LinearProgressIndicator()
                            : const Padding(padding: EdgeInsets.only(top: 0.0)),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                userProvider.user.profile_image,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: TextField(
                                controller: _descriptionController,
                                decoration: const InputDecoration(
                                    hintText: "Write a caption...",
                                    border: InputBorder.none),
                                maxLines: 8,
                              ),
                            ),
                            SizedBox(
                              height: 45.0,
                              width: 45.0,
                              child: AspectRatio(
                                aspectRatio: 487 / 451,
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          alignment: FractionalOffset.topCenter,
                                          image: FileImage(
                                            File(images[0]!.path),
                                          ))),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
          );
  }
}
