import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/providers/tweet_provider.dart';

class CreateTweet extends ConsumerWidget {
  const CreateTweet ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController tweetController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text("Post a Tweet")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 4,
              controller: tweetController,
              decoration: const InputDecoration(border: OutlineInputBorder()), 
              maxLength: 280, 
            ),
          ),
          Container(
            width: 150,
            decoration: BoxDecoration(
            color: Color(0xffB5A440),
            borderRadius: BorderRadius.circular(30)
              ),
            child: TextButton(
              onPressed: () async {
                ref.read(tweetProvider).postTweet(tweetController.text);
                Navigator.pop(context);
                },
              child: const Text(
               "Post Tweet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}