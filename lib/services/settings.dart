import 'package:flex_seed_scheme/flex_seed_scheme.dart';

import 'package:elastic_dashboard/services/ip_address_util.dart';

/// Manages application settings and preferences.
class Settings {
  /// Link to the repository for the Elastic Dashboard.
  static const String repositoryLink =
      'https://github.com/Gold872/elastic-dashboard';

  /// Latest releases link for the Elastic Dashboard.
  static const String releasesLink = '$repositoryLink/releases/latest';

<<<<<<< HEAD
  /// Mode for handling IP addresses.
  static IPAddressMode ipAddressMode = IPAddressMode.driverStation;

  /// Default IP address for communication.
  static String ipAddress = '127.0.0.1';

  /// Team number for FRC team identification.
  static int teamNumber = 9999;

  /// Size of the grid in the dashboard.
  static int gridSize = 128;

  /// Indicates whether the layout is locked.
  static bool layoutLocked = false;

  /// Radius for rounding corners of UI elements.
  static double cornerRadius = 15.0;

  /// Indicates whether elements snap to grid.
  static bool snapToGrid = true;

  /// Automatically resize UI elements to fit the driver station.
  static bool autoResizeToDS = false;

  /// Automatically switch tabs based on selected elements.
  static bool autoSwitchTabs = false;

  /// Indicates whether the window is draggable.
=======
  // window_manager doesn't support drag disable/maximize
  // disable on some platforms, this is a dumb workaround for it
>>>>>>> 8d8667119a03e9f68a44f6d693542ab070c13126
  static bool isWindowDraggable = true;

  /// Indicates whether the window is maximizable.
  static bool isWindowMaximizable = true;
}

<<<<<<< HEAD
  /// Default period for periodic tasks.
  static double defaultPeriod = 0.06;

  /// Default period for graph updates.
  static double defaultGraphPeriod = 0.033;

  /// Indicates whether settings should be autosaved.
  static bool autoSave = false;

  /// Internal map storing all settings.
  static final Map<String, dynamic> _settings = {
    'repositoryLink': repositoryLink,
    'releasesLink': releasesLink,
    'ipAddressMode': ipAddressMode,
    'ipAddress': ipAddress,
    'teamNumber': teamNumber,
    'gridSize': gridSize,
    'layoutLocked': layoutLocked,
    'cornerRadius': cornerRadius,
    'snapToGrid': snapToGrid,
    'autoResizeToDS': autoResizeToDS,
    'autoSwitchTabs': autoSwitchTabs,
    'isWindowDraggable': isWindowDraggable,
    'isWindowMaximizable': isWindowMaximizable,
    'defaultPeriod': defaultPeriod,
    'defaultGraphPeriod': defaultGraphPeriod,
    'autoSave': autoSave,
  };

  /// Retrieves a setting value by [key].
  static dynamic get(String key) => _settings[key];

  /// Sets a setting [value] identified by [key].
  ///
  /// Throws [ArgumentError] for an invalid [key].
  static void set(String key, dynamic value) {
    _settings[key] = value;
    switch (key) {
      case 'ipAddressMode':
        ipAddressMode = value;
        break;
      case 'ipAddress':
        ipAddress = value;
        break;
      case 'teamNumber':
        teamNumber = value;
        break;
      case 'gridSize':
        gridSize = value;
        break;
      case 'layoutLocked':
        layoutLocked = value;
        break;
      case 'cornerRadius':
        cornerRadius = value;
        break;
      case 'snapToGrid':
        snapToGrid = value;
        break;
      case 'autoResizeToDS':
        autoResizeToDS = value;
        break;
      case 'autoSwitchTabs':
        autoSwitchTabs = value;
        break;
      case 'isWindowDraggable':
        isWindowDraggable = value;
        break;
      case 'isWindowMaximizable':
        isWindowMaximizable = value;
        break;
      case 'defaultPeriod':
        defaultPeriod = value;
        break;
      case 'defaultGraphPeriod':
        defaultGraphPeriod = value;
        break;
      case 'autoSave':
        autoSave = value;
        break;
      default:
        throw ArgumentError('Invalid settings key: $key');
    }
  }
=======
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
>>>>>>> 8d8667119a03e9f68a44f6d693542ab070c13126
}

/// Constants for preference keys used in persistent storage.
class PrefKeys {
<<<<<<< HEAD
  /// Key for layout preferences.
  static const layout = 'layout';
=======
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
>>>>>>> 8d8667119a03e9f68a44f6d693542ab070c13126

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
