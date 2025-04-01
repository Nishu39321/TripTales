// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'auth_gate.dart';
// import 'map.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
//   final PageController _trendingPageController = PageController(viewportFraction: 0.85);
//   final PageController _savedPageController = PageController(viewportFraction: 0.85);

//   final List<Map<String, String>> trendingPlaces = [
//     {"title": "Bali", "image": "assets/bali.jpg"},
//     {"title": "Paris", "image": "assets/paris.jpg"},
//     {"title": "Tokyo", "image": "assets/tokyo.jpg"},
//   ];

//   final List<Map<String, String>> savedPlaces = [
//     {"title": "London", "image": "assets/london.jpg"},
//     {"title": "New York", "image": "assets/newyork.jpg"},
//     {"title": "Sydney", "image": "assets/sydney.jpg"},
//   ];

//   final List<Widget> _pages = [];

//   @override
//   void initState() {
//     super.initState();
//     _pages.addAll([
//       _buildHomeContent(),
//       Center(child: Text("Feature Coming Soon")),
//       Center(child: Text("Feature Coming Soon")),
//       Center(child: Text("Feature Coming Soon")),
//       _buildProfileSection(),
//     ]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//   type: BottomNavigationBarType.fixed,
//   currentIndex: _selectedIndex,
//   onTap: (index) {
//     if (index == 1) {
//       Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage()));
//     } else {
//       setState(() => _selectedIndex = index);
//     }
//   },
//   items: [
//     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),  // Home
//     BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),  // Map
//     BottomNavigationBarItem(icon: Icon(Icons.flight_takeoff), label: "Plan a Trip"),  // New Plan a Trip icon
//     BottomNavigationBarItem(icon: Icon(Icons.description), label: "Notes"),  // Notes
//     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),  // Profile
//   ],
// ),

//     );
//   }

//   Widget _buildHomeContent() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF93A5CF), Color(0xFFE4EFE9)],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildGreetingSection(),
//               SizedBox(height: 15),
//               _buildQuoteSection(),
//               SizedBox(height: 20),
//               _buildSection("Top Picks for You"),
//               _buildSlidingPlaces(trendingPlaces, _trendingPageController),
//               SizedBox(height: 20),
//               _buildSection("Your Saved Places"),
//               _buildSlidingPlaces(savedPlaces, _savedPageController),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileSection() {
//     final user = FirebaseAuth.instance.currentUser;

//     return Container(
//       padding: EdgeInsets.all(20),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             radius: 40,
//             backgroundImage: user?.photoURL != null
//                 ? NetworkImage(user!.photoURL!)
//                 : AssetImage("assets/profile_placeholder.png") as ImageProvider,
//           ),
//           SizedBox(height: 10),
//           Text(
//             user?.displayName ?? "Guest User",
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 5),
//           Text(user?.email ?? "No email available"),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => AuthGate()),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.redAccent,
//               padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//             ),
//             child: Text("Sign Out", style: TextStyle(fontSize: 18)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGreetingSection() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           "Hello, User",
//           style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//         ),
//         IconButton(
//           icon: Icon(Icons.notifications, color: Colors.black),
//           onPressed: () {},
//         ),
//       ],
//     );
//   }

//   Widget _buildQuoteSection() {
//     return Center(
//       child: Container(
//         width: 300,
//         height: 50,
//         child: DefaultTextStyle(
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//             fontStyle: FontStyle.italic,
//           ),
//           child: AnimatedTextKit(
//             animatedTexts: [
//               TypewriterAnimatedText(
//                 '“Travel is the only thing you buy that makes you richer.”',
//                 speed: Duration(milliseconds: 100),
//               ),
//             ],
//             repeatForever: false,
//             totalRepeatCount: 1,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSection(String title) {
//     return Padding(
//       padding: EdgeInsets.only(left: 8),
//       child: Text(
//         title,
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Widget _buildSlidingPlaces(List<Map<String, String>> places, PageController controller) {
//     return Container(
//       height: 200,
//       child: PageView.builder(
//         controller: controller,
//         itemCount: places.length,
//         itemBuilder: (context, index) {
//           return _buildPlaceCard(places, index, controller);
//         },
//       ),
//     );
//   }

//   Widget _buildPlaceCard(List<Map<String, String>> places, int index, PageController controller) {
//     return AnimatedBuilder(
//       animation: controller,
//       builder: (context, child) {
//         double scale = 1.0;
//         if (controller.position.haveDimensions) {
//           double pageOffset = controller.page! - index;
//           scale = (1 - (pageOffset.abs() * 0.3)).clamp(0.8, 1.0);
//         }

//         return Transform.scale(
//           scale: scale,
//           child: Container(
//             margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               image: DecorationImage(
//                 image: AssetImage(places[index]["image"]!),
//                 fit: BoxFit.cover,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.3),
//                   blurRadius: 5,
//                   spreadRadius: 2,
//                   offset: Offset(2, 4),
//                 ),
//               ],
//             ),
//             child: Align(
//               alignment: Alignment.bottomLeft,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Text(
//                   places[index]["title"]!,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                     backgroundColor: Colors.black45,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'auth_gate.dart';
// import 'map.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
//   final PageController _trendingPageController = PageController(viewportFraction: 0.85);
//   final PageController _savedPageController = PageController(viewportFraction: 0.85);

//   final List<Map<String, String>> trendingPlaces = [
//     {"title": "Bali", "image": "assets/bali.jpg"},
//     {"title": "Paris", "image": "assets/paris.jpg"},
//     {"title": "Tokyo", "image": "assets/tokyo.jpg"},
//   ];

//   final List<Map<String, String>> savedPlaces = [
//     {"title": "London", "image": "assets/london.jpg"},
//     {"title": "New York", "image": "assets/newyork.jpg"},
//     {"title": "Sydney", "image": "assets/sydney.jpg"},
//   ];

//   late final List<Widget> _pages;

//   @override
//   void initState() {
//     super.initState();
//     _pages = [
//       _buildHomeContent(),               // Home Page (Index 0)
//       MapPage(),                         // Map Page (Index 1)
//       _buildPlanTripSection(),           // Plan a Trip (Index 2)
//       Center(child: Text("Feature Coming Soon")), // Notes (Index 3)
//       _buildProfileSection(),            // Profile Page (Index 4)
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() => _selectedIndex = index);
//         },
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
//           BottomNavigationBarItem(icon: Icon(Icons.flight_takeoff), label: "Plan a Trip"),
//           BottomNavigationBarItem(icon: Icon(Icons.description), label: "Notes"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }

//   /// 🏠 Home Page Content
//   Widget _buildHomeContent() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF93A5CF), Color(0xFFE4EFE9)],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildGreetingSection(),
//               SizedBox(height: 15),
//               _buildQuoteSection(),
//               SizedBox(height: 20),
//               _buildSection("Top Picks for You"),
//               _buildSlidingPlaces(trendingPlaces, _trendingPageController),
//               SizedBox(height: 20),
//               _buildSection("Your Saved Places"),
//               _buildSlidingPlaces(savedPlaces, _savedPageController),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// ✈️ Plan a Trip Section (Placeholder)
//   Widget _buildPlanTripSection() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.flight, size: 80, color: Colors.blue),
//           SizedBox(height: 10),
//           Text(
//             "Plan Your Trip",
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 5),
//           Text("Feature Coming Soon... Stay Tuned!"),
//         ],
//       ),
//     );
//   }

//   /// 👤 Profile Section
//   Widget _buildProfileSection() {
//     final user = FirebaseAuth.instance.currentUser;

//     return Container(
//       padding: EdgeInsets.all(20),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             radius: 40,
//             backgroundImage: user?.photoURL != null
//                 ? NetworkImage(user!.photoURL!)
//                 : AssetImage("assets/profile_placeholder.png") as ImageProvider,
//           ),
//           SizedBox(height: 10),
//           Text(
//             user?.displayName ?? "Guest User",
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 5),
//           Text(user?.email ?? "No email available"),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => AuthGate()),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.redAccent,
//               padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//             ),
//             child: Text("Sign Out", style: TextStyle(fontSize: 18)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGreetingSection() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           "Hello, User",
//           style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//         ),
//         IconButton(
//           icon: Icon(Icons.notifications, color: Colors.black),
//           onPressed: () {},
//         ),
//       ],
//     );
//   }

//   Widget _buildQuoteSection() {
//     return Center(
//       child: Container(
//         width: 300,
//         height: 50,
//         child: DefaultTextStyle(
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//             fontStyle: FontStyle.italic,
//           ),
//           child: AnimatedTextKit(
//             animatedTexts: [
//               TypewriterAnimatedText(
//                 '“Travel is the only thing you buy that makes you richer.”',
//                 speed: Duration(milliseconds: 100),
//               ),
//             ],
//             repeatForever: false,
//             totalRepeatCount: 1,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSection(String title) {
//     return Padding(
//       padding: EdgeInsets.only(left: 8),
//       child: Text(
//         title,
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Widget _buildSlidingPlaces(List<Map<String, String>> places, PageController controller) {
//     return Container(
//       height: 200,
//       child: PageView.builder(
//         controller: controller,
//         itemCount: places.length,
//         itemBuilder: (context, index) {
//           return _buildPlaceCard(places, index, controller);
//         },
//       ),
//     );
//   }

//   Widget _buildPlaceCard(List<Map<String, String>> places, int index, PageController controller) {
//     return AnimatedBuilder(
//       animation: controller,
//       builder: (context, child) {
//         double scale = 1.0;
//         if (controller.position.haveDimensions) {
//           double pageOffset = controller.page! - index;
//           scale = (1 - (pageOffset.abs() * 0.3)).clamp(0.8, 1.0);
//         }

//         return Transform.scale(
//           scale: scale,
//           child: Container(
//             margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               image: DecorationImage(
//                 image: AssetImage(places[index]["image"]!),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Align(
//               alignment: Alignment.bottomLeft,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Text(
//                   places[index]["title"]!,
//                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_gate.dart';
import 'map.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _trendingPageController = PageController(viewportFraction: 0.85);
  final PageController _savedPageController = PageController(viewportFraction: 0.85);

  final List<Map<String, String>> trendingPlaces = [
    {"title": "Bali", "image": "assets/bali.jpg"},
    {"title": "Paris", "image": "assets/paris.jpg"},
    {"title": "Tokyo", "image": "assets/tokyo.jpg"},
  ];

  final List<Map<String, String>> savedPlaces = [
    {"title": "London", "image": "assets/london.jpg"},
    {"title": "New York", "image": "assets/newyork.jpg"},
    {"title": "Sydney", "image": "assets/sydney.jpg"},
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomeContent(),               // Home Page (Index 0)
      MapPage(),                         // Map Page (Index 1)
      _buildPlanTripSection(),           // Plan a Trip (Index 2)
      Center(child: Text("Feature Coming Soon")), // Notes (Index 3)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildProfileDrawer(), // Drawer added
      appBar: AppBar(
        title: Text("Travel App"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.person, color: Colors.white), // Profile icon in top left
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open drawer when clicked
            },
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.flight_takeoff), label: "Plan a Trip"),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: "Notes"),
        ],
      ),
    );
  }

  /// 🏠 Home Page Content
  Widget _buildHomeContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF93A5CF), Color(0xFFE4EFE9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuoteSection(),
              SizedBox(height: 20),
              _buildSection("Top Picks for You"),
              _buildSlidingPlaces(trendingPlaces, _trendingPageController),
              SizedBox(height: 20),
              _buildSection("Your Saved Places"),
              _buildSlidingPlaces(savedPlaces, _savedPageController),
            ],
          ),
        ),
      ),
    );
  }

  /// 📖 Profile Drawer (Side Menu)
  Widget _buildProfileDrawer() {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? "Guest User"),
            accountEmail: Text(user?.email ?? "No email available"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : AssetImage("assets/profile_placeholder.png") as ImageProvider,
            ),
            decoration: BoxDecoration(color: Colors.blueAccent),
          ),
          ListTile(
            leading: Icon(Icons.card_travel),
            title: Text("Your Trips"),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 2); // Navigate to Plan a Trip
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("Your Friends"),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Feature Coming Soon!")),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Sign Out", style: TextStyle(color: Colors.red)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthGate()),
              );
            },
          ),
        ],
      ),
    );
  }

  /// ✈️ Plan a Trip Section (Placeholder)
  Widget _buildPlanTripSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flight, size: 80, color: Colors.blue),
          SizedBox(height: 10),
          Text(
            "Plan Your Trip",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text("Feature Coming Soon... Stay Tuned!"),
        ],
      ),
    );
  }

  /// 📜 Quote Section
  Widget _buildQuoteSection() {
    return Center(
      child: Container(
        width: 300,
        height: 50,
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                '“Travel is the only thing you buy that makes you richer.”',
                speed: Duration(milliseconds: 100),
              ),
            ],
            repeatForever: false,
            totalRepeatCount: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSlidingPlaces(List<Map<String, String>> places, PageController controller) {
    return Container(
      height: 200,
      child: PageView.builder(
        controller: controller,
        itemCount: places.length,
        itemBuilder: (context, index) {
          return _buildPlaceCard(places, index);
        },
      ),
    );
  }

  Widget _buildPlaceCard(List<Map<String, String>> places, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(places[index]["image"]!),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            places[index]["title"]!,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
