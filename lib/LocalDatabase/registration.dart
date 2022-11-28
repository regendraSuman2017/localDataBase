import 'package:localdatabase/LocalDatabase/database.dart';

class Registration{
int Id;
String name;
String password;
String imageNameBase64;

Registration({
  this.Id,
  this.name,
  this.password,
  this.imageNameBase64,
});

Registration.empty();

Map<String, dynamic> toMap(){
  Map map = <String, dynamic>{
    'Id':Id,
  'name' : name,
  'password' : password,
  'imageNameBase64' : imageNameBase64,
};
  return map;
}

Registration.formMap(Map<String,dynamic> map){
Id = map['Id'];
name = map['name'];
password = map['password'];
imageNameBase64 = map['imageNameBase64'];
}

Future<Registration> save()async{
  print(this.toMap());
  print("this.toMap() 37");
  DbHelper dbHelper = new DbHelper();
  var dbClient = await dbHelper.db;
  this.Id = await dbClient.insert('Registration', this.toMap());
  return this;
  ///// INSERT DATA into LOCALDATABSE
}

Future<List<Registration>> getdata()async{
  DbHelper dbHelper = new DbHelper();
  var dbClient = await dbHelper.db;

  List<Map> maps = await dbClient.query('Registration',columns: ['Id', 'name', 'password', 'imageNameBase64'
       ],where: "Id!=? order by Id desc",whereArgs: [""]);

  List<Registration> ams = [];

  if(maps.isNotEmpty) {
    print("maps 59");
    print(maps);
    for (int i = 0; i < maps.length; i++) {
      ams.add(Registration.formMap(maps[i]));
    }
  }
  else {
    print('visitDatabase offline id: '+maps.toString());
  }

  /*maps.forEach((result) {
    Registration product = Registration.fromMap(result);
    ams.add(product);
  });*/
  return ams;

}

Future<String> UpdateLocalDB()async{

  DbHelper dbHelper = new DbHelper();
  var dbClient = await dbHelper.db;

  var queryVisitBoth =  await dbClient.rawUpdate('Update Registration set '
  "name=?,"
  "password=? where Id=",[this.name,this.password,this.Id]
  );

  if(queryVisitBoth>0){
    return "Yes";
  }
  else {
    return "No";
  }


}
}