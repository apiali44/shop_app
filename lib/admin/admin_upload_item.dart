import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shop_app/api_connection/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';



class AdminUploadItemsScreen extends StatefulWidget {
  @override
  State<AdminUploadItemsScreen> createState() => _AdminUploadItemsScreenState();
}

class _AdminUploadItemsScreenState extends State<AdminUploadItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return pickedImageXFile == null ? _defaultScreen() : uploadItemFromScreen();
  }

  final ImagePicker _picker = ImagePicker();
  XFile? pickedImageXFile;
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ratingsController = TextEditingController();
  var tagController = TextEditingController();
  var priceController = TextEditingController();
  var sizeController = TextEditingController();
  var colorController = TextEditingController();
  var descController = TextEditingController();
  var imageLink = "";

  captureImageWithPhoneCamera() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);
    Get.back();
    setState(() => pickedImageXFile);
  }

  pickImageFromGallery() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);
    Get.back();
    setState(() => pickedImageXFile);
  }

  showDialogBoxForImage(){
    return showDialog(
      context: context,
      // false = user must tap button, true = tap outside dialog
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.black,
          title: const Text('Upload Image', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),),
          children: [
            SimpleDialogOption(
              onPressed: (){
                captureImageWithPhoneCamera();
              },
              child: const Text(
                "Capture with Camera",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SimpleDialogOption(
              onPressed: (){
                pickImageFromGallery();
              },
              child: const Text(
                "Upload from gallery",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SimpleDialogOption(
              onPressed: (){
                Get.back();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],

        );
      },
    );
  }

  Widget _defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome Admin",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.deepPurple, Colors.deepPurple]),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(colors: [
            Colors.black26,
            Color.fromARGB(31, 145, 143, 143),
            Colors.deepPurple
          ], radius: 0.4),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate,
                color: Colors.white,
                size: 200,
              ),
              Material(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: () {
                    showDialogBoxForImage();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      "Add New Item",
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
        ),
      ),
    );
  }

  uploadItemImage() async {
    var requestImgurApi = http.MultipartRequest(
      "POST",
      Uri.parse("https://api.imgur.com/3/image"),
    );
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    requestImgurApi.fields['title'] = imageName;
    requestImgurApi.headers['Authorization'] = "Client-ID " + "2c2d1cc76ea3b61";

    var imageFile = await http.MultipartFile.fromPath(
      'image',
      pickedImageXFile!.path,
      filename: imageName,
    );
    
    requestImgurApi.files.add(imageFile);
    var responseFromImgurApi = await requestImgurApi.send();
    var responseDataFromImgurApi = await responseFromImgurApi.stream.toBytes();
    var resultFromImgurApi = String.fromCharCodes(responseDataFromImgurApi);

    Map<String, dynamic> jsonRes = json.decode(resultFromImgurApi);
    imageLink = (jsonRes["data"]["link"]).toString();
    String deleteHash = (jsonRes["data"]["deletehash"]).toString();

    saveItemInfo();
  }

  saveItemInfo() async {
    List<String> tagList = tagController.text.split(',');
    List<String> sizeList = sizeController.text.split(',');
    List<String> colorsList = colorController.text.split(',');
    try{
      var res = await http.post(
        Uri.parse(API.uploadNewItem),
        body: {
          'item_id': '1',
          'item_name': nameController.text.trim().toString(),
          'item_rating': ratingsController.text.trim().toString(),
          'item_tag': tagList.toString(),
          'item_price': priceController.text.trim().toString(),
          'item_size': sizeList.toString(),
          'item_colors': colorsList.toString(),
          'item_desc': descController.text.trim().toString(),
          'item_image': imageLink.toString(),
        }
      );
      if (res.statusCode == 200) {
        var resItemRec = jsonDecode(res.body);
        if (resItemRec['success'] == true) {
          Fluttertoast.showToast(
              msg: "New Item saved successfully");
          setState(() {
            pickedImageXFile = null;
            nameController.clear();
            ratingsController.clear();
            tagController.clear();
            priceController.clear();
            sizeController.clear();
            colorController.clear();
            descController.clear();
          });
          Get.to(()=> AdminUploadItemsScreen());
        } else {
          Fluttertoast.showToast(
              msg: "Item failed to save. Please try again");
        }
    }
  }
    catch(errorMsg){
      print("Error::$errorMsg");
    }
}

  Widget uploadItemFromScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Item Upload Page",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient:
            LinearGradient(colors: [Colors.deepPurple, Colors.white10]),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            setState(() {
              pickedImageXFile = null;
              nameController.clear();
              ratingsController.clear();
              tagController.clear();
              priceController.clear();
              sizeController.clear();
              colorController.clear();
              descController.clear();
            });
            Get.to(() => AdminUploadItemsScreen());
          },
          icon: const Icon(Icons.clear, color: Colors.white,),
        ),
        actions: [
          ElevatedButton(
              onPressed: (){
                Fluttertoast.showToast(
                    msg: "Uploading now...");
                uploadItemImage();
              },
              child: const Text("Done", style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(pickedImageXFile!.path),
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black26,
                      offset: Offset(0, -3),
                    )
                  ]),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                child: Column(
                  children: [
                    //email password and login button
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          //email
                          TextFormField(
                            controller: nameController,
                            validator: (val) =>
                            val == "" ? "Please write item name" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.text_fields,
                                color: Colors.black,
                              ),
                              hintText: 'item name',
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ), //item name
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: ratingsController,
                            validator: (val) =>
                            val == "" ? "Please write item rating" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.hotel_class,
                                color: Colors.black,
                              ),
                              hintText: 'item rating',
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ), //item ratings
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: tagController,
                            validator: (val) =>
                            val == "" ? "Please write item tag" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.sell,
                                color: Colors.black,
                              ),
                              hintText: 'item tag',
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ), //item tag
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: priceController,
                            validator: (val) =>
                            val == "" ? "Please write item price" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.currency_pound,
                                color: Colors.black,
                              ),
                              hintText: 'item price',
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ), //item price
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: sizeController,
                            validator: (val) =>
                            val == "" ? "Please write item size" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.straighten,
                                color: Colors.black,
                              ),
                              hintText: 'item size',
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),//item size
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: colorController,
                            validator: (val) =>
                            val == "" ? "Please write item color" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.palette,
                                color: Colors.black,
                              ),
                              hintText: 'item color',
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ), //item color
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: descController,
                            validator: (val) =>
                            val == "" ? "Please write item description" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.edit_note,
                                color: Colors.black,
                              ),
                              hintText: 'item description',
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  )),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ), //item desc
                          const SizedBox(height: 18),
                          Material(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  Fluttertoast.showToast(
                                      msg: "Uploading now...");
                                  uploadItemImage();
                                }
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Text(
                                  "Upload now",
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
