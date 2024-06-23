import 'package:app/service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/pages/home.dart';
import 'package:app/pages/order.dart' as app_order;
import 'package:app/pages/profile.dart';
import 'package:app/pages/wallet.dart';
import 'package:badges/badges.dart' as badges;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;
  late List<Widget> pages;
  late Widget currentPage;
  late Home homepage;
  late Profile profile;
  late app_order.Order order;
  late Wallet wallet;

  int cartItemCount = 0;
  String? userId;

  @override
  void initState() {
    homepage = Home();
    order = app_order.Order();
    profile = Profile();
    wallet = Wallet();
    pages = [homepage, order, wallet, profile];
    super.initState();

    fetchUserId();
  }

  void fetchUserId() async {
    userId = await SharedPreferenceHelper().getUserId();
    if (userId != null) {
      fetchCartItemCount();
    }
  }

  void fetchCartItemCount() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Cart')
        .snapshots()
        .listen((snapshot) {
      int itemCount = snapshot.docs.length;
      setState(() {
        cartItemCount = itemCount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Icon(
            Icons.home_outlined,
            color: Colors.white,
          ),
          if (cartItemCount > 0)
            badges.Badge(
              badgeContent: Text(
                cartItemCount.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
              ),
              badgeStyle: badges.BadgeStyle(
                badgeColor: Colors.red,
              ),
            )
          else
            Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
            ),
          Icon(
            Icons.wallet_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.person_outlined,
            color: Colors.white,
          ),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
