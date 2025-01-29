import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitnessapp/Provider/BottomnavbarProvider.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;

  const NavItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.index});

  @override
  Widget build(BuildContext context) {
    
    return Consumer<BottomNavBarProvider>(
        builder: (context, navbarProvider, child) {
      return GestureDetector(
          onTap: () => navbarProvider.setindex(index),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: navbarProvider.selectedindex == index
                    ? Colors.white
                    : Colors.grey,
              ),
              Text(label,
                  style: TextStyle(
                      color: navbarProvider.selectedindex == index
                          ? Colors.white
                          : Colors.grey)),
            ],
          ));
    });
  }
}
