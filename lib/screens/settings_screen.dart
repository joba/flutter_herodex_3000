import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/blocs/theme/theme_cubit.dart';
import 'package:flutter_herodex_3000/config/texts.dart';
import 'package:flutter_herodex_3000/managers/analytics_manager.dart';
import 'package:flutter_herodex_3000/managers/crashlytics_manager.dart';
import 'package:flutter_herodex_3000/widgets/herodex_logo.dart';
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

  bool _analyticsEnabled = false;
  bool _crashReportingEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSystemInfo();
    _loadPreferences();
  }

  void _loadPreferences() {
    setState(() {
      _analyticsEnabled = _analyticsManager.isEnabled;
      _crashReportingEnabled = _crashlyticsManager.isEnabled;
    });
  }

  Future<void> _loadSystemInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceInfo = DeviceInfoPlugin();

    String osVersion = '';
    String deviceModel = '';

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      osVersion = 'Android ${androidInfo.version.release}';
      deviceModel = androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      osVersion = 'iOS ${iosInfo.systemVersion}';
      deviceModel = iosInfo.model;
    } else if (Platform.isMacOS) {
      final macInfo = await deviceInfo.macOsInfo;
      osVersion = 'macOS ${macInfo.osRelease}';
      deviceModel = macInfo.model;
    }

    setState(() {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
      _osVersion = osVersion;
      _deviceModel = deviceModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentYear = DateTime.now().year;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const HerodexLogo(),
              const SizedBox(height: 32),
              Text(
                AppTexts.common.title.toUpperCase(),
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 48),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Build Version
                      _buildSectionTitle('Version', theme),
                      const SizedBox(height: 8),
                      _buildInfoCard(
                        'App Version',
                        _version.isEmpty ? 'Loading...' : _version,
                        theme,
                      ),
                      _buildInfoCard(
                        'Build Number',
                        _buildNumber.isEmpty ? 'Loading...' : _buildNumber,
                        theme,
                      ),
                      const SizedBox(height: 24),

                      // System Status
                      _buildSectionTitle('System Status', theme),
                      const SizedBox(height: 8),
                      _buildInfoCard(
                        'Platform',
                        _osVersion.isEmpty ? 'Loading...' : _osVersion,
                        theme,
                      ),
                      _buildInfoCard(
                        'Device',
                        _deviceModel.isEmpty ? 'Loading...' : _deviceModel,
                        theme,
                      ),
                      const SizedBox(height: 24),

                      // Preferences
                      _buildSectionTitle('Preferences', theme),
                      const SizedBox(height: 8),
                      Card(
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: const Text('Analytics'),
                              subtitle: const Text(
                                'Help improve the app by sharing usage data',
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
                            const Divider(height: 1),
                            SwitchListTile(
                              title: const Text('Crashlytics'),
                              subtitle: const Text(
                                'Automatically report crashes to help fix bugs',
                              ),
                              value: _crashReportingEnabled,
                              onChanged: (value) async {
                                await _crashlyticsManager.updateConsent(value);
                                setState(() {
                                  _crashReportingEnabled = value;
                                });
                              },
                            ),
                            const Divider(height: 1),
                            BlocBuilder<ThemeCubit, ThemeMode>(
                              builder: (context, themeMode) {
                                return SwitchListTile(
                                  title: const Text('Dark Mode'),
                                  subtitle: const Text(
                                    'Use dark theme throughout the app',
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
                      const SizedBox(height: 24),

                      // Copyright
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '© $currentYear ${AppTexts.common.title}',
                                  style: theme.textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'All rights reserved.',
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
      padding: const EdgeInsets.only(left: 8.0),
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
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
