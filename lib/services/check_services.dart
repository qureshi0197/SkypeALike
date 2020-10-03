import 'package:flutter/material.dart';
import 'package:skypealike/models/post.dart';
import 'package:skypealike/services/http_service.dart';
import 'package:skypealike/services/posts_details.dart';

// This class is made to check data we are getting from the server

class CheckServices extends StatelessWidget {
  final HttpService httpService = HttpService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
      ),
      body: FutureBuilder(
        future: httpService.getPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot){
          if(snapshot.hasData){
            
            List<Post> posts = snapshot.data;

            return ListView(
              children: posts.map((Post post) 
                => ListTile(
                  title: Text(post.id.toString()),
                  subtitle: Text(post.title),
                  onTap: () => 
                    Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => PostDetails(post: post,))), 
              )).toList()
            );
          }
          return Center(child: CircularProgressIndicator());
        },
        ),
      
    );
  }
}