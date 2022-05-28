import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/post_api_service.dart';

class SinglePostPage extends StatelessWidget {
  final int postId;
  const SinglePostPage({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildSinglePost(context),
      ),
    );
  }

  FutureBuilder<Response> _buildSinglePost(BuildContext context) {
    return FutureBuilder<Response>(
      future: Provider.of<PostApiService>(context).getPost(postId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final Map post = json.decode(snapshot.data?.bodyString ?? " ");
          return _buildPostView(context, post);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Padding _buildPostView(BuildContext context, Map post) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            post['title'],
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            post['body'],
          ),
        ],
      ),
    );
  }
}
