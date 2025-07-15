import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clone/models/tweet.dart';
import 'package:twitter_clone/pages/createtweet.dart';
import 'package:twitter_clone/pages/setting.dart';
import 'package:twitter_clone/providers/tweet_provider.dart';
import 'package:twitter_clone/providers/user_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(preferredSize: Size.fromHeight(4), child: Container(color: Colors.grey, height: 1)),
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () =>Scaffold.of(context).openDrawer(),
              child: Padding(
                padding: EdgeInsetsGeometry.all(8),
                child: CircleAvatar(
                    backgroundImage: NetworkImage(currentUser.user.profilePicture)
                  ),
              ),
            );
          }
        ),
        title: FaIcon(
          FontAwesomeIcons.twitter,
          color: Colors.white,
          size: 40,
        ),
      ),
      body: ref.watch(feedProvider).when(
        data: (List<Tweet> tweets) {
          return ListView.separated(
            separatorBuilder: ((context, index) => Divider(color: Colors.black,)),
            itemCount: tweets.length,
            itemBuilder: (context, count) {
            return ListTile(
              leading: CircleAvatar(foregroundImage: NetworkImage(tweets[count].profilePicture)),
              title: Text(tweets[count].name, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Container(
                padding: EdgeInsets.all(10),
                child: Text(tweets[count].tweet, style: TextStyle(color: Colors.black, fontSize: 16))
                ),
              );
          });
        }, 
        error: (error, stacktrace) => Center(child: Text("error")), 
        loading: () {
        return const CircularProgressIndicator();
      }),
      drawer: Drawer(
        child: Container(
          color: Colors.indigo,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.only(top: 40),
                child: Image.network(
                  currentUser.user.profilePicture
                ),
              ),
              ListTile(
                title: Text(
                  "Hello, ${currentUser.user.name}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),  
                ),
              ),
              ListTile(
                title: Text("Settings", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Settings()));
                }
              ),
              
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: ListTile(
                      leading: Icon(Icons.exit_to_app, color: Colors.white,),
                      title: Text("Sign Out", style: TextStyle(color: Colors.white)),
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        ref.read(userProvider.notifier).clearUserState();
                      }
                    ),
                  ),
                ),
              ),
          ],
                ),
        )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffB5A440),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateTweet()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}