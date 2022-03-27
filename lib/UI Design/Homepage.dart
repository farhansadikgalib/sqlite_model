import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_model/Database/Database_Handler.dart';
import 'package:sqlite_model/Model/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late DatabaseHandler handler;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(()async{
      await this.addUsers();
      setState(() {
      });
    });

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder(
          future:  this.handler.retriveUsers(),

          builder: (BuildContext context, AsyncSnapshot<List<USER>>snapshot) {
            if(snapshot.hasData){
              return ListView.builder(

                  itemCount: snapshot.data?.length,


                  itemBuilder:(BuildContext context,int index){
                    return Dismissible(direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.orange,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child:Icon(Icons.delete_forever),
                    ),
                      key: ValueKey<int>(snapshot.data![index].id!),
                      onDismissed: (DismissDirection direction) async{
                      await this.handler.deleteUser(snapshot.data![index].id!);
                      setState(() {
                        snapshot.data!.remove(snapshot.data![index]);
                      });
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(snapshot.data![index].name),
                          subtitle: Text(snapshot.data![index].age.toString()),
                        ),
                      ),


                    );
                  });
            }
            else{
              return Center(child: CircularProgressIndicator(color: Colors.green,),);
            } ;
          })


    );
  }

 Future<int> addUsers()async {

    USER u1= USER(name: "Farhan", age: 25, country: "Bangladesh");
    USER u2= USER(name: "Shawon", age: 36, country: "Qatat");
    USER u3= USER(name: "Sakib", age: 27, country: "Uganda");
    USER u4= USER(name: "Sifat", age: 28, country: "USA");
    USER u5= USER(name: "Asif", age: 48, country: "Noakhali");
    List<USER> usrList = [u1,u2,u3,u4,u5];

    return await this.handler.insertUser(usrList);


 }
}
