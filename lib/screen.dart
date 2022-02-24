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
    if(image==null)
      {
        const AlertDialog(
          title: CircularProgressIndicator(),

        );
      }
    else if (image != null) {
      setState(() {
        final temp = File(image.path);
        this.image = temp;
      });
    } else {
      showDialog(context: context, builder:(_)=> const AlertDialog(
        title: Text("No image is selected"),
      ),);
    }
  }

  Future postData() async {
    setState((){
       CircularProgressIndicator();
    });
    var stream = http.ByteStream(image!.openRead());
    var length= await image!.length();
    //var uri= await http.MultipartRequest(Uri.parse('https://fakestoreapi.com//products'));
    var uri= Uri.parse('https://fakestoreapi.com//products');
    var request= http.MultipartRequest('POST', uri);
    request.fields['title']= " Hell ";
    var multiport= http.MultipartFile('image', stream, length);
    request.files.add(multiport);
    var response = await request.send();
    if(response.statusCode==200)
      {
        print('Image is upload');
       return  showDialog(context: context, builder:(_)=> const AlertDialog(
          title: Text("Image is uploaded"),
        ),);
      }
    else{
      print('Uploading is failed');
     return showDialog(context: context, builder:(_)=> const AlertDialog(
        title: Text("Uploaded is failed"),
      ),);
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
              onTap: (){
               getImages();
              },
              child: Container(
                child: image == null
                    ? const Center(child: Text("pick Image",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                ),))
                    : Center(
                      child: Image.file(
                        File(image!.path).absolute,
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
              onTap: (){
                postData();
              },
              child: Container(
                //color: Colors.blue,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15)
                  ),
                ),
                child: const Center(
                  child: Text("Upload",style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
