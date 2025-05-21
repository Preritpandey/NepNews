import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_portal/author/author.dart';
import 'package:news_portal/controllers/auth_controller.dart';
import 'package:news_portal/controllers/theme_controller.dart';
import 'package:news_portal/editor/editor_page.dart';
import 'package:news_portal/pages/Home/home.dart';
import 'package:news_portal/pages/auth/login_page.dart';

import '../Home/home_page.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  AuthController _authController = Get.put(AuthController());
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Profile',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${_authController.getUserName() == null ? "name" : _authController.getUserName()}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${_authController.getUserEmail() == null ? "email" : _authController.getUserEmail()}',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // Theme Toggle
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(() => ListTile(
                  leading: Icon(
                    themeController.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Switch(
                    value: themeController.isDarkMode,
                    onChanged: (_) => themeController.toggleTheme(),
                    activeColor: theme.colorScheme.primary,
                  ),
                )),
          ),
          Divider(
            height: 1,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => LoginPage());
                  },
                  child: ListTile(
                    leading:
                        Icon(Icons.login, color: theme.colorScheme.primary),
                    title: Text(
                      'Login',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right,
                        color: theme.colorScheme.onSurface.withOpacity(0.5)),
                  ),
                ),
                Divider(
                  height: 1,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                GestureDetector(
                  onTap: () {
                    _authController.logout();
                    Get.offAll(() => HomePage());
                  },
                  child: ListTile(
                    leading: Icon(Icons.help_outline,
                        color: theme.colorScheme.primary),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.logout_outlined),
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      onPressed: () {
                        _authController.logout();
                      },
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                GestureDetector(
                  onTap: () {
                    if (_authController.getUserRole() == "editor") {
                      Get.to(() => DraftArticlesScreen());
                    } else {
                      Get.snackbar("Access Denied",
                          "You do not have access to this page");
                    }
                  },
                  child: ListTile(
                    leading: Icon(Icons.edit, color: theme.colorScheme.primary),
                    title: Text(
                      'Editor Dashboard',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right,
                        color: theme.colorScheme.onSurface.withOpacity(0.5)),
                  ),
                ),
                Divider(
                  height: 1,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                GestureDetector(
                  onTap: () {
                    if (_authController.getUserRole() == "author") {
                      Get.to(() => const AuthorNewsPage());
                    } else {
                      Get.snackbar("Access Denied",
                          "You do not have access to this page");
                    }
                  },
                  child: ListTile(
                    leading:
                        Icon(Icons.person, color: theme.colorScheme.primary),
                    title: Text(
                      'Author Dashboard',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right,
                        color: theme.colorScheme.onSurface.withOpacity(0.5)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
