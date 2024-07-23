import 'package:flex_seed_scheme/flex_seed_scheme.dart';

import 'package:elastic_dashboard/services/ip_address_util.dart';

/// Manages application settings and preferences.
class Settings {
  /// Link to the repository for the Elastic Dashboard.
  static const String repositoryLink =
      'https://github.com/Gold872/elastic-dashboard';

  /// Latest releases link for the Elastic Dashboard.
  static const String releasesLink = '$repositoryLink/releases/latest';

  // window_manager doesn't support drag disable/maximize
  // disable on some platforms, this is a dumb workaround for it
  static bool isWindowDraggable = true;

  /// Indicates whether the window is maximizable.
  static bool isWindowMaximizable = true;
}

class Defaults {
  static IPAddressMode ipAddressMode = IPAddressMode.driverStation;

  static FlexSchemeVariant themeVariant = FlexSchemeVariant.material3Legacy;
  static const String defaultVariantName = 'Material-3 Legacy (Default)';

  static const String ipAddress = '127.0.0.1';
  static const int teamNumber = 9999;
  static const int gridSize = 128;
  static const bool layoutLocked = false;
  static const double cornerRadius = 15.0;
  static const bool showGrid = true;
  static const bool autoResizeToDS = false;

  static const double defaultPeriod = 0.06;
  static const double defaultGraphPeriod = 0.033;
}

/// Constants for preference keys used in persistent storage.
class PrefKeys {
  static String layout = 'layout';
  static String ipAddress = 'ip_address';
  static String ipAddressMode = 'ip_address_mode';
  static String teamNumber = 'team_number';
  static String teamColor = 'team_color';
  static String themeVariant = 'theme_variant';
  static String layoutLocked = 'layout_locked';
  static String gridSize = 'grid_size';
  static String cornerRadius = 'corner_radius';
  static String showGrid = 'show_grid';
  static String autoResizeToDS = 'auto_resize_to_driver_station';
  static String rememberWindowPosition = 'remember_window_position';
  static String defaultPeriod = 'default_period';
  static String defaultGraphPeriod = 'default_graph_period';

  /// Key for IP address preferences.
  static const ipAddress = 'ip_address';

  /// Key for IP address mode preferences.
  static const ipAddressMode = 'ip_address_mode';

  /// Key for team number preferences.
  static const teamNumber = 'team_number';

  /// Key for team color preferences.
  static const teamColor = 'team_color';

  /// Key for layout lock preferences.
  static const layoutLocked = 'layout_locked';

  /// Key for grid size preferences.
  static const gridSize = 'grid_size';

  /// Key for corner radius preferences.
  static const cornerRadius = 'corner_radius';

  /// Key for snap to grid preferences.
  static const snapToGrid = 'show_grid';

  /// Key for auto resize to driver station preferences.
  static const autoResizeToDS = 'auto_resize_to_driver_station';

  /// Key for remembering window position preferences.
  static const rememberWindowPosition = 'remember_window_position';

  /// Key for default period preferences.
  static const defaultPeriod = 'default_period';

  /// Key for default graph period preferences.
  static const defaultGraphPeriod = 'default_graph_period';

  /// Key for window position preferences.
  static const windowPosition = 'window_position';

  /// Key for auto save preferences.
  static const autoSave = 'auto_save';

  /// Key for auto switch tabs preferences.
  static const autoSwitchTabs = 'auto_switch_tabs';
}
