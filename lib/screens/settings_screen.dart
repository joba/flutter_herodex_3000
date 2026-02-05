import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/auth/cubit/auth_cubit.dart';
import 'package:flutter_herodex_3000/auth/cubit/auth_state.dart';
import 'package:flutter_herodex_3000/blocs/theme/theme_cubit.dart';
import 'package:flutter_herodex_3000/config/app_texts.dart';
import 'package:flutter_herodex_3000/managers/analytics_manager.dart';
import 'package:flutter_herodex_3000/managers/crashlytics_manager.dart';
import 'package:flutter_herodex_3000/managers/location_manager.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';
import 'package:flutter_herodex_3000/utils/snackbar.dart';
import 'package:flutter_herodex_3000/widgets/herodex_logo.dart';
import 'package:flutter_herodex_3000/widgets/uppercase_elevated_button.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = '';
  String _buildNumber = '';
  String _osVersion = '';
  String _deviceModel = '';

  final _analyticsManager = AnalyticsManager();
  final _crashlyticsManager = CrashlyticsManager();
  final _locationManager = LocationManager();

  bool _analyticsEnabled = false;
  bool _crashReportingEnabled = false;
  bool _locationEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSystemInfo();
    _loadPreferences();
  }

  void _loadPreferences() async {
    try {
      final analyticsEnabled = await _analyticsManager.isEnabled;
      final crashLyticsEnabled = await _crashlyticsManager.isEnabled;
      final locationEnabled = await _locationManager.isEnabled;
      setState(() {
        _analyticsEnabled = analyticsEnabled;
        _crashReportingEnabled = crashLyticsEnabled;
        _locationEnabled = locationEnabled;
      });
    } catch (e, stackTrace) {
      _crashlyticsManager.recordError(
        e,
        stackTrace,
        reason: AppTexts.settings.loadPreferencesError,
      );
      if (mounted) {
        AppSnackBar.of(
          context,
        ).showError('${AppTexts.settings.loadPreferencesError}: $e');
      }
    }
  }

  Future<void> _loadSystemInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final deviceInfo = DeviceInfoPlugin();

      String osVersion = '';
      String deviceModel = '';

      if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        osVersion =
            '${AppTexts.settings.systemInfoPrefixWeb} - ${webInfo.browserName.name}';
        deviceModel = webInfo.platform ?? AppTexts.settings.systemInfoUnknown;
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        osVersion =
            '${AppTexts.settings.systemInfoPrefixAndroid} ${androidInfo.version.release}';
        deviceModel = androidInfo.model;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        osVersion =
            '${AppTexts.settings.systemInfoPrefixIOS} ${iosInfo.systemVersion}';
        deviceModel = iosInfo.model;
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        osVersion =
            '${AppTexts.settings.systemInfoPrefixMacOS} ${macInfo.osRelease}';
        deviceModel = macInfo.model;
      }

      setState(() {
        _version = packageInfo.version;
        _buildNumber = packageInfo.buildNumber;
        _osVersion = osVersion;
        _deviceModel = deviceModel;
      });
    } catch (e, stackTrace) {
      _crashlyticsManager.recordError(
        e,
        stackTrace,
        reason: AppTexts.settings.loadSystemInfoError,
      );
      if (mounted) {
        AppSnackBar.of(
          context,
        ).showError('${AppTexts.settings.loadSystemInfoError}: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentYear = DateTime.now().year;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.appPaddingBase * 1.5),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            const HerodexLogo(),
                            const SizedBox(
                              height: AppConstants.appPaddingBase * 2,
                            ),
                            Text(
                              AppTexts.common.title.toUpperCase(),
                              style: theme.textTheme.headlineLarge,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.appPaddingBase * 3),
                      // Build Version
                      _buildSectionTitle(
                        AppTexts.settings.settingsHeaderVersion,
                        theme,
                      ),
                      const SizedBox(height: AppConstants.appPaddingBase / 2),
                      _buildInfoCard(
                        AppTexts.settings.settingsLabelVersion,
                        _version.isEmpty ? '-' : _version,
                        theme,
                      ),
                      _buildInfoCard(
                        AppTexts.settings.settingsLabelBuildNumber,
                        _buildNumber.isEmpty ? '-' : _buildNumber,
                        theme,
                      ),
                      const SizedBox(height: AppConstants.appPaddingBase * 3),

                      // System Status
                      _buildSectionTitle(
                        AppTexts.settings.settingsHeaderSystemStatus,
                        theme,
                      ),
                      const SizedBox(height: AppConstants.appPaddingBase / 2),
                      _buildInfoCard(
                        AppTexts.settings.settingsLabelPlatform,
                        _osVersion.isEmpty ? '-' : _osVersion,
                        theme,
                      ),
                      _buildInfoCard(
                        AppTexts.settings.settingsLabelDevice,
                        _deviceModel.isEmpty ? '-' : _deviceModel,
                        theme,
                      ),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          if (state is AuthAuthenticated) {
                            return _buildInfoCard(
                              AppTexts.settings.settingsLabelUser,
                              state.user.email ??
                                  AppTexts.settings.settingsLabelUserNoEmail,
                              theme,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: AppConstants.appPaddingBase * 3),

                      // Preferences
                      _buildSectionTitle(
                        AppTexts.settings.settingsHeaderPreferences,
                        theme,
                      ),
                      const SizedBox(height: AppConstants.appPaddingBase / 2),
                      Card(
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: Text(
                                AppTexts.settings.settingsLabelAnalytics,
                              ),
                              subtitle: Text(
                                AppTexts.settings.settingsInfoAnalytics,
                              ),
                              value: _analyticsEnabled,
                              onChanged: (value) async {
                                await _analyticsManager.setAnalyticsEnabled(
                                  value,
                                );
                                setState(() {
                                  _analyticsEnabled = value;
                                });
                              },
                            ),
                            if (!kIsWeb) const Divider(height: 1),
                            if (!kIsWeb)
                              SwitchListTile(
                                title: Text(
                                  AppTexts.settings.settingsLabelCrashlytics,
                                ),
                                subtitle: Text(
                                  AppTexts.settings.settingsInfoCrashlytics,
                                ),
                                value: _crashReportingEnabled,
                                onChanged: (value) async {
                                  await _crashlyticsManager.updateConsent(
                                    value,
                                  );
                                  setState(() {
                                    _crashReportingEnabled = value;
                                  });
                                },
                              ),
                            const Divider(height: 1),
                            SwitchListTile(
                              title: Text(
                                AppTexts.settings.settingsLabelLocation,
                              ),
                              subtitle: Text(
                                AppTexts.settings.settingsInfoLocation,
                              ),
                              value: _locationEnabled,
                              onChanged: (value) async {
                                await _locationManager.setLocationEnabled(
                                  value,
                                );
                                setState(() {
                                  _locationEnabled = value;
                                });
                              },
                            ),
                            const Divider(height: 1),
                            BlocBuilder<ThemeCubit, ThemeMode>(
                              builder: (context, themeMode) {
                                return SwitchListTile(
                                  title: Text(
                                    AppTexts.settings.settingsLabelDarkMode,
                                  ),
                                  subtitle: Text(
                                    AppTexts.settings.settingsInfoDarkMode,
                                  ),
                                  value: themeMode == ThemeMode.dark,
                                  onChanged: (value) {
                                    context.read<ThemeCubit>().setThemeMode(
                                      value ? ThemeMode.dark : ThemeMode.light,
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.appPaddingBase * 3),

                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          if (state is AuthAuthenticated) {
                            return UpperCaseElevatedButton(
                              onPressed: () async {
                                await context.read<AuthCubit>().signOut();
                                if (context.mounted) {
                                  context.go('/auth');
                                }
                              },
                              child: Text(AppTexts.auth.signOut),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      // Copyright
                      const SizedBox(height: AppConstants.appPaddingBase / 2),
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(
                              AppConstants.appPaddingBase,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '© $currentYear ${AppTexts.common.title}',
                                  style: theme.textTheme.bodyLarge,
                                ),
                                const SizedBox(
                                  height: AppConstants.appPaddingBase / 2,
                                ),
                                Text(
                                  AppTexts.settings.settingsCopyright,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: AppConstants.appPaddingBase / 4),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.appPaddingBase / 2),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.appPaddingBase),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
