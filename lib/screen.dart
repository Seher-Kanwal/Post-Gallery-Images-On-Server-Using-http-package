import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final ImagePicker imagepicker = ImagePicker();

  File? image; //for file use i/o file

  Future getImages() async {
    final image = await imagepicker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);

    if (image != null) {
      setState(() {
        final temp = File(image.path);
        this.image = temp;
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("No image is selected"),
        ),
      );
    }
  }

  Future postData() async {
    setState(() { const CircularProgressIndicator(); });
    var stream = http.ByteStream(image!.openRead()); //reading byte by byte
    var length = await image!.length();
    var uri = Uri.parse('https://fakestoreapi.com//products'); //the url to which we have to send request
    var request = http.MultipartRequest('POST', uri); //in place of uri, you can write api's link
    request.fields['title'] = " Hell ";
    var multiport = http.MultipartFile('image', stream, length);
    //we passing in image a stream(which is acutlly a image but in byte form and lenght of that stream)
    //https://newbedev.com/use-flutter-to-send-a-http-post-request-containing-an-image-to-a-flask-api#:~:text=Use%20Flutter%20to%20send%20a%20http%20Post-Request%20%28containing,like%20File%20image%3Bwith%20the%20result%20of%20that%20picker.
    //go to that link to understand
    request.files.add(multiport); //this will add to multipart
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image is upload');
      return showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("Image is uploaded"),
        ),
      );
    } else {
      print('Uploading is failed');
      return showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("Uploaded is failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPLOAD'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                getImages();
              },
              child: Container(
                child: image == null
                    ? const Center(
                        child: Text(
                        "pick Image",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.lightBlue,
                         // fontWeight: FontWeight.bold,
                        ),
                      ))
                    : Center(
                        child: Image.file(
                          File(image!.path).absolute, //give  the path from the currently working directory
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 150,
            ),
            GestureDetector(
              onTap: () {
                postData();
              },
              child: Container(
                //color: Colors.blue,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: const Center(
                  child: Text(
                    "Upload",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
