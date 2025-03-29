import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_portal/controllers/theme_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
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
                  offset: Offset(0, 4),
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
                SizedBox(height: 16),
                Text(
                  'Prit Pandey',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  'pandeyprerit45@gmail.com',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Settings Section
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16),

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

          // Other Settings Options
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.notifications_outlined,
                      color: theme.colorScheme.primary),
                  title: Text(
                    'Notifications',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right,
                      color: theme.colorScheme.onSurface.withOpacity(0.5)),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.language_outlined,
                      color: theme.colorScheme.primary),
                  title: Text(
                    'Language',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right,
                      color: theme.colorScheme.onSurface.withOpacity(0.5)),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.help_outline,
                      color: theme.colorScheme.primary),
                  title: Text(
                    'Help & Support',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right,
                      color: theme.colorScheme.onSurface.withOpacity(0.5)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
