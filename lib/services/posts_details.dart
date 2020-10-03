import 'package:flutter/material.dart';
import 'package:skypealike/models/post.dart';
import 'package:skypealike/services/http_service.dart';

class PostDetails extends StatelessWidget {
  
  // final Person person;
  final Post post;
  final HttpService httpService = HttpService();
  
  // PostDetails({@required this.post});
  PostDetails({@required this.post});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.id.toString()),
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: () async {
          await httpService.deletePost(post.id);
          Navigator.of(context).pop();
        }
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('Title'),
                  subtitle: Text(post.title),
                ),
                ListTile(
                  title: Text('ID'),
                  subtitle: Text("${post.id}"),
                ),
                ListTile(
                  title: Text('Body'),
                  subtitle: Text(post.body),
                ),
                ListTile(
                  title: Text('User ID'),
                  subtitle: Text("${post.userId}"),
                ),
              ],
              ),
          ),
          ),
      ),
      
    );
  }
}