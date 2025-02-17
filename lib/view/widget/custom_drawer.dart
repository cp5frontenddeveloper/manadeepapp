import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manadeebapp/controllers/authcontroller/login_page_controller.dart';
import 'package:manadeebapp/services/server_shared.dart';

import '../../core/themes/app_theme.dart';
import 'sharedwidget/customlisttitle/custom_listtitle.dart';
import 'package:manadeebapp/localization/change_language.dart';

class CustomDrawer extends StatelessWidget {
  final String username;
  final String email;
  final VoidCallback? onLogout;
  CustomDrawer({
    Key? key,
    required this.username,
    required this.email,
    this.onLogout,
  }) : super(key: key);
  final MyServices _myServices = Get.find<MyServices>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          _buildHeader(theme),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildAccountSection(theme),
                const SizedBox(height: 16),
                _buildPreferencesSection(theme),
                const SizedBox(height: 16),
                _buildSecuritySection(theme),
                const SizedBox(height: 24),
                _buildLogoutSection(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
      ),
      accountName: Text(
        username,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      accountEmail: Text(
        email,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onPrimary.withOpacity(0.9),
        ),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: theme.colorScheme.surface,
        child: Text(
          username[0].toUpperCase(),
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Text(
            '81'.tr,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CustomListTile(
          title: '82'.tr,
          leadingIcon: Icons.lock_outline,
          trailingIcon: Icons.arrow_forward_ios,
          onTap: () {
            final loginPageController = Get.put(LoginPageController(
               loginRepositories: Get.find(),
               myServices: Get.find(),
            ));
            loginPageController.showdilaog(Get.context!);
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          dense: true,
          iconSize: 24,
          iconColor: theme.colorScheme.primary,
          titleStyle: theme.textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Text(
            '83'.tr,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        CustomListTile(
          title: '84'.tr,
          leadingIcon: Icons.language,
          trailingIcon: Icons.arrow_forward_ios,
          onTap: () {
            final languageController = Get.find<LanguageController>();
            languageController.toggleLanguage();
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          dense: true,
          iconSize: 24,
          iconColor: theme.colorScheme.primary,
          titleStyle: theme.textTheme.titleMedium,
        ),
        SizedBox(
          height: 10,
        ),
        CustomListTile(
          title: '85'.tr,
          leadingIcon: Get.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          trailingIcon: Icons.arrow_forward_ios,
          onTap: () {
            final themeService = Get.find<ThemeService>();
            themeService.changeTheme();
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          dense: true,
          iconSize: 24,
          iconColor: theme.colorScheme.primary,
          titleStyle: theme.textTheme.titleMedium,
        ),
        SizedBox(
          height: 10,
        ),
        // CustomListTile(
        //   title: '86'.tr,
        //   leadingIcon: Icons.notifications_outlined,
        //   trailingIcon: Icons.arrow_forward_ios,
        //   onTap: () => print('النغمة'),
        //   contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        //   dense: true,
        //   iconSize: 24,
        //   iconColor: theme.colorScheme.primary,
        //   titleStyle: theme.textTheme.titleMedium,
        // ),
      ],
    );
  }

  Widget _buildSecuritySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Text(
            '87'.tr,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          title: Text(
            '88'.tr,
            style: theme.textTheme.titleMedium,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.fingerprint_outlined,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
          subtitle: Text(
            '89'.tr,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          trailing: Obx(
            () => Switch.adaptive(
              value: _myServices.isFingerprintEnabled.value,
              onChanged: _myServices.toggleFingerprint,
              activeColor: theme.colorScheme.primary,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          dense: true,
        ),
      ],
    );
  }

  Widget _buildLogoutSection(ThemeData theme) {
    return CustomListTile(
      title: '90'.tr,
      leadingIcon: Icons.logout,
      onTap: () async {
        await _myServices.sharedPreferences.clear();
        // Get.offAllNamed(AppRoutes.login);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      dense: true,
      iconSize: 24,
      iconColor: theme.colorScheme.error,
      titleStyle: theme.textTheme.titleMedium?.copyWith(
        color: theme.colorScheme.error,
      ),
    );
  }
}
