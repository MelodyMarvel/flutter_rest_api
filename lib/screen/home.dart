// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert'; 

// class HomeSCreen extends StatefulWidget {
//   const HomeSCreen({super.key});

//   @override
//   State<HomeSCreen> createState() => _HomeSCreenState();
// }

// class _HomeSCreenState extends State<HomeSCreen> {
//   List<dynamic> users = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Rest API Call'),
//       ),
//       body:ListView.builder(
//         itemCount: users.length,
//         itemBuilder: (context, index){
//           final user = users[index];
//           final name = user['name']['first'];
//           final email = user['email'];
//           final ImageUrl = user['picture']['thumbnail'];
//           return ListTile(
//             leading: ClipRRect(
//               borderRadius: BorderRadius.circular(100),
//               child: CircleAvatar(
//                 child: Image.network(ImageUrl),
//                 ),
//             ),
              
//             title: Text(name.toString()),
//             subtitle: Text(email),

//           );
//       }
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: fetchUsers
//         ),
//     );
//   }

//   void fetchUsers() async{
//     print('fetchUsers called');
//     const Url = 'https://randomuser.me/api/?results=10';
//     final uri = Uri.parse(Url);
//     final response = await http.get(uri);
//     final body = response.body;
//     final json = jsonDecode(body);
//     setState(() {
//       users = json['results'];
//     });
//       print('fetchUsers completed');
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<dynamic> users = [];
  late List<dynamic> photos = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      // Fetch user data
      const url1 = 'https://jsonplaceholder.typicode.com/users';
      final response1 = await http.get(Uri.parse(url1));
      final List<dynamic> data1 = jsonDecode(response1.body);
      users.addAll(data1);

      // Fetch photo data
      const url2 = 'https://jsonplaceholder.typicode.com/photos';
      final response2 = await http.get(Uri.parse(url2));
      final List<dynamic> data2 = jsonDecode(response2.body);
      photos.addAll(data2);

      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Combine user and photo data into a single list
    List<Map<String, dynamic>> combinedData = [];
    for (int i = 0; i < max(users.length, photos.length); i++) {
      combinedData.add({
        'name': i < users.length ? users[i]['name'] ?? '' : '',
        'email': i < users.length ? users[i]['email'] ?? '' : '',
        'thumbnailUrl': i < photos.length ? photos[i]['thumbnailUrl'] ?? '' : '',
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users and Photos'),
      ),
      body: ListView.builder(
        itemCount: combinedData.length,
        itemBuilder: (context, index) {
          final userData = combinedData[index];
          final name = userData['name'];
          final email = userData['email'];
          final thumbnailUrl = userData['thumbnailUrl'];

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(thumbnailUrl),
            ),
            title: Text(name),
            subtitle: Text(email),
          );
        },
      ),
    );
  }
}

