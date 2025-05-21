import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/hamburger_menu_controller.dart';

class CategoryMenu extends StatelessWidget {
  final HamburgerMenuController menuController =
      Get.put(HamburgerMenuController());

  final List<Map<String, dynamic>> categories = [
    {'title': 'Top News', 'icon': Icons.star},
    {'title': 'Politics', 'icon': Icons.account_balance},
    {'title': 'Technology', 'icon': Icons.memory},
    {'title': 'Sports', 'icon': Icons.sports_soccer},
    {'title': 'Health', 'icon': Icons.health_and_safety},
    {'title': 'Entertainment', 'icon': Icons.movie},
    {'title': 'Business', 'icon': Icons.business_center},
    {'title': 'World', 'icon': Icons.public},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        left: menuController.isMenuOpen.value ? 0 : -270,
        top: 0,
        bottom: 0,
        child: SizedBox(
          width: 270,
          child: Material(
            elevation: 16,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            color: theme.colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'News Categories',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                Divider(height: 1, color: theme.dividerColor),
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return AnimatedCategoryItem(
                        delay: index * 100, // Stagger by 100ms
                        icon: categories[index]['icon'],
                        title: categories[index]['title'],
                        onTap: () {
                          menuController.closeMenu();
                          // Navigate or filter logic here
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class AnimatedCategoryItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final int delay;
  final VoidCallback onTap;

  const AnimatedCategoryItem({
    super.key,
    required this.icon,
    required this.title,
    required this.delay,
    required this.onTap,
  });

  @override
  State<AnimatedCategoryItem> createState() => _AnimatedCategoryItemState();
}

class _AnimatedCategoryItemState extends State<AnimatedCategoryItem>
    with SingleTickerProviderStateMixin {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: _visible ? 1 : 0,
      curve: Curves.easeOut,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 400),
        offset: _visible ? const Offset(0, 0) : const Offset(-0.3, 0),
        curve: Curves.easeOut,
        child: ListTile(
          leading: Icon(widget.icon, color: theme.iconTheme.color),
          title: Text(
            widget.title,
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          onTap: widget.onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          hoverColor: theme.colorScheme.primary.withOpacity(0.05),
        ),
      ),
    );
  }
}
