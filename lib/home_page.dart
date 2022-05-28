import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:chopper_sample/data/post_api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'single_post_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            final response = await Provider.of<PostApiService>(context, listen: false)
                .postPost({'key': 'value'});
            if (kDebugMode) {
              print(response.body);
            }
          },
        ),
        body: _buidBody(
          context,
        ),
      ),
    );
  }

  FutureBuilder<Response> _buidBody(BuildContext context) {
    return FutureBuilder<Response>(
      future: Provider.of<PostApiService>(context).getPostts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final list = json.decode(snapshot.data?.bodyString ?? " ");
          return _buildPosts(context, list);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  ListView _buildPosts(BuildContext context, List posts) {
    return ListView.builder(
      itemCount: posts.length,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          child: ListTile(
            title: Text(
              posts[index]['title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              posts[index]['body'],
            ),
            onTap: () => _navigateToPosts(context, posts[index]['id']),
          ),
        );
      },
    );
  }

  void _navigateToPosts(BuildContext context, int postId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SinglePostPage(
          postId: postId,
        ),
      ),
    );
  }
}
