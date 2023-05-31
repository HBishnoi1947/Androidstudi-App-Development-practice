import 'dart:convert';

import 'package:api_flutter/Models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<PostsModel> postList = []; 
  Future<List<PostsModel>> getPostApi() async{
    postList = [];
    try{
      final respone = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
      var data = jsonDecode(respone.body.toString());
      if(respone.statusCode==200){
        for(Map i in data){
          postList.add(PostsModel.fromJson(i));
        }
      }
    }
    catch(e){return postList;}
    // print("harsh :  ${respone.body.toString()}");
    // print("harsh :  $postList");
    // print("harsh :  $data");
    return postList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API ${postList.length}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getPostApi(),
              builder: (context,snapshot){
                if(!snapshot.hasData || postList.isEmpty) {
                  // print("Harsh1 : $snapshot");
                  return const Center(child: Text('Loading'));
                }
                else{
                  // print("Harsh2 : $snapshot");
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: postList.length,
                    itemBuilder: (context,index){
                    return Card(child: Padding(padding: const EdgeInsets.all(8),child: Text("$index \n${postList[index].title}")));
                  });
                } 
              }
            ),
          )
        ],
      ),
    );
  }
}
