import 'package:flutter/material.dart';
import 'package:geji_music_client/common/com_color.dart';
import 'package:geji_music_client/pages/home_favorlist_page.dart';
import 'package:geji_music_client/pages/home_profile_page.dart';
import 'package:geji_music_client/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       elevation: 8,
  //       backgroundColor: Colors.blue,
  //       foregroundColor: Colors.white,
  //     ),
  //     body: Center(
  //       child: Column(
  //         children: [
  //           const Text("HomePage"),
  //           Text(Account.instance().accountDisplayName()),
  //           InkWell(
  //             onTap: ()async{
  //               await LoginManager.instance().clearLoginData();
  //               if(!context.mounted){
  //                 return;
  //               }
  //               Navigator.of(context).pushNamedAndRemoveUntil(
  //                 ROUTER_LOGIN,
  //                 (route) => false
  //               );
  //             },
  //             child: Text("退出"),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

}

class HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final pages = const [
    FavorlistPage(),
    SearchPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ComColors.MainBackground,
        body: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(8),
          child: NavigationBar(
            backgroundColor: ComColors.MainBackground2,
            indicatorColor: Colors.blue.withValues(alpha: 0.25),
            selectedIndex: currentIndex,
            labelBehavior:NavigationDestinationLabelBehavior.alwaysShow,
            onDestinationSelected: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.library_music_outlined),
                selectedIcon: Icon(Icons.library_music),
                label: "歌单",
              ),
              NavigationDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search),
                label: "搜索",
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: "我的",
              ),
            ],
          ),
        ),
      )
    );
  }
}
