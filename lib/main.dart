import 'dart:async';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:localdatabase/LocalDatabase/registration.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'LocalDatabase/database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({key, this.title});
  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  TextEditingController nameController = TextEditingController() ;
  TextEditingController passwordController = TextEditingController() ;
  TextEditingController updateNameController = TextEditingController() ;
  TextEditingController updatePasswordController = TextEditingController() ;
  List<Map> jsonList = [];
  List<Map> jsonListVisits = [];

  int id;
  String name='';
  String password='';

  File attImage = null; // to FILE import io file not html

  List<Registration> registrationa = [];

  PickedFile imageFile=null;
  var _image;
  String PictureBase64;

  Uint8List _bytesImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDataFromLocalDatabase(); /////CALL Function Fetch Data From LocalDataBase
  }

  fetchDataFromLocalDatabase()async {
    Registration registration = Registration.empty();
    registrationa = await registration.getdata();

    for (int i=0;i<registrationa.length;i++){
      setState(() {
        id = registrationa[i].Id;
        name = registrationa[i].name;
        password = registrationa[i].password;
        PictureBase64 = registrationa[i].imageNameBase64;
        _bytesImage = Base64Decoder().convert(PictureBase64);
      });
      print("dasdasd");
      print(PictureBase64);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
               Container(height: 300, child:  ListView.builder(
                  itemCount: registrationa.length,
                  itemBuilder: (BuildContext context, int index){
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment : MainAxisAlignment.spaceBetween,
                          children: [
                            Text(registrationa[index].Id.toString()),
                            Text(registrationa[index].name.toString()),
                            Text(registrationa[index].password.toString()),
                            Container(
                                child: _bytesImage == null
                                    ? new Text('No image value.')
                                    :  Image.memory(base64.decode(registrationa[index].imageNameBase64))  // To fetch image from LocalDatabse
                            ),
                            ElevatedButton(
                              child: Text("Update"),onPressed: (){
                              updateNameController.text = registrationa[index].name.toString();
                              updatePasswordController.text = registrationa[index].password.toString();
                               showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text("Alert Dialog Box"),
                                  content: Container(
                                      height: 200,
                                      child:Column(children: [
                                    TextFormField(
                                      controller: updateNameController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                        )
                                      ),
                                    ),
                                    TextFormField(
                                      controller: updatePasswordController,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red,
                                                width: 1.0),
                                          )

                                      ),
                                    ),
                                        ElevatedButton(onPressed: () async {
                                          Registration saveRegistration = Registration(
                                            Id: registrationa[index].Id,
                                            name: nameController.text,
                                            password:passwordController.text,
                                            imageNameBase64: PictureBase64.toString(),
                                          );  // Save Data in
                                          var result = await saveRegistration.UpdateLocalDB();
print(result);
print("kjjh");

                                        }, child: Text("Save"))
                                  ],))
                                ),
                              );
                            },
                              style: ElevatedButton.styleFrom(),
                            )
                          ],
                        ),
                        SizedBox(height: 5,)
                      ],

                    );
                  })),
                

                Form(child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a search term',
                      ),
                      controller: nameController,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a search term',
                      ),
                      controller: passwordController,
                    ),
                      Center(
                      child: _image != null
                          ? Image.file(
                        _image,
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.fitHeight,
                      )
                          : Container(
                        decoration: BoxDecoration(
                            color: Colors.red[200]),
                        width: 200,
                        height: 200,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      )),
                    RawMaterialButton(
                      onPressed: () async {
                        pickImage(context);
                      },
                      child: Icon(
                        Icons.camera_alt,
                        size: 18.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 0.5,
                      fillColor: Colors.red,
                    ),
                      ])),


                    ElevatedButton(onPressed: ()async{

                      Registration saveRegistration = Registration(
                        name: nameController.text,
                        password:passwordController.text,
                        imageNameBase64: PictureBase64.toString(),
                      );  // Save Data in
                      var result = await saveRegistration.save();  //tHis call for SAve
                      if(result.Id=="" || result.Id==null){
                        fetchDataFromLocalDatabase();
                        return showDialog(
                          context: context,
                          builder: (ctx) => const AlertDialog(
                            title: Text("Alert Dialog Box"),
                            content: Text("You have raised a Alert Dialog Box"),
                            actions: <Widget>[],
                          ),
                        );
                      }
                      else
                        {
                          return showDialog(
                            context: context,
                            builder: (ctx) => const AlertDialog(
                              title: Text("Alert Dialog Box"),
                              content: Text("You have Punched"),
                              actions: <Widget>[],
                            ),
                          );
                        }
                    }, child: const Text("Submit")),

                ElevatedButton(onPressed: ()async{
                  DbHelper dbHelper=new DbHelper();
                  var dbClient = await dbHelper.db;
                  int ids= await dbClient.delete('Registration');
                    }, child: const Text("Delete")),

                   /* ElevatedButton(onPressed: ()async{
                      Registration saveRegistration = Registration.empty();
                      List<Registration> getOfflineData = await saveRegistration.getdata();

                      if(getOfflineData.length>0){
                        await Future.forEach(getOfflineData, (getOfflineData)async{
                          print("sdfsdfsf");
                          jsonList.add({
                            "Id" : getOfflineData.Id,
                            "name" : getOfflineData.name,
                            "password" : getOfflineData.password,
                            "imageNameBase64" : getOfflineData.imageNameBase64,
                          });
                        });
                      }else{}

                    }, child: const Text("Sync Data"))*/
                  ],
                ))
        ),
      )



      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future pickImage (context) async{
    attImage = File((await ImagePicker().getImage(source: ImageSource.camera,imageQuality: 35, maxHeight: 100, maxWidth: 100)).path);
      print(attImage.path);

    List<int> imageBytes = attImage.readAsBytesSync();
    print(imageBytes);
    PictureBase64 = base64Encode(imageBytes);

      /*var decodeImg = img.decodeImage(attImage.readAsBytesSync(),);
    var encodeImage = img.encodeJpg(decodeImg, quality: 100,);
    attImage = File(attImage.path)..writeAsBytesSync(encodeImage,);
    List<int> imageBytes = await attImage.readAsBytes();
    PictureBase64 = Utility.base64String(attImage.readAsBytesSync());
    //PictureBase64 = base64.encode(imageBytes);
print(PictureBase64);
print("sdfsdhfkjjkh");*/
    setState(() {
      _image = File(attImage.path);
    });

  }



}


