// -----------------------------------------
// menu_page.dart
// -----------------------------------------

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentedge_app/constants.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  // Define vibrant gradients for each card
  final List<List<Color>> cardGradients = const [
    [Color(0xFF42A5F5), Color(0xFF1E88E5)], // Blue
    [Color(0xFF66BB6A), Color(0xFF43A047)], // Green
    [Color(0xFFFFA726), Color(0xFFF57C00)], // Orange
    [Color(0xFFAB47BC), Color(0xFF8E24AA)], // Purple
    [Color(0xFF26C6DA), Color(0xFF00ACC1)], // Teal
    [Color(0xFFEF5350), Color(0xFFE53935)], // Red
  ];

  final List<Map<String, dynamic>> _menuItems = const [
    {
      "title": "Dashboard",
      "icon": Icons.dashboard,
      "route": "/coursesDashboard",
    },
    {
      "title": "Courses",
      "icon": Icons.book,
      "route": "/coursesDashboard",
    },
    {
      "title": "Achievements",
      "icon": Icons.star,
      "route": "/achievements",
    },
    {
      "title": "Profile",
      "icon": Icons.person,
      "route": "/userDashboard",
    },
    {
      "title": "Settings",
      "icon": Icons.settings,
      "route": "/settings",
    },
    {
      "title": "Support",
      "icon": Icons.support_agent,
      "route": "/support",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Menu",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: kPrimaryBlue,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: _menuItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final menuItem = _menuItems[index];
            final gradient = cardGradients[index % cardGradients.length];

            return InkWell(
              onTap: () {
                final route = menuItem["route"] as String?;
                if (route != null) {
                  GoRouter.of(context).push(route);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[1].withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      menuItem["icon"],
                      size: 42,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        menuItem["title"],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
