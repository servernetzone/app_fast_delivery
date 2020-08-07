package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.firebaseauth.FirebaseAuthPlugin;
import io.flutter.plugins.firebase.core.FirebaseCorePlugin;
import io.flutter.plugins.firebasedynamiclinks.FirebaseDynamicLinksPlugin;
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;
import com.appleeducate.getversion.GetVersionPlugin;
import com.lyokone.location.LocationPlugin;
import com.baseflow.location_permissions.LocationPermissionsPlugin;
import io.flutter.plugins.packageinfo.PackageInfoPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import com.illescasDaniel.flutterShareItPlugin.share_it.ShareItPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import io.flutter.plugins.connectivity.ConnectivityPlugin;
import com.tekartik.sqflite.SqflitePlugin;
import mo.dyna.statusbar.StatusbarPlugin;
import io.flutter.plugins.urllauncher.UrlLauncherPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    FirebaseAuthPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebaseauth.FirebaseAuthPlugin"));
    FirebaseCorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.core.FirebaseCorePlugin"));
    FirebaseDynamicLinksPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasedynamiclinks.FirebaseDynamicLinksPlugin"));
    FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
    GetVersionPlugin.registerWith(registry.registrarFor("com.appleeducate.getversion.GetVersionPlugin"));
    LocationPlugin.registerWith(registry.registrarFor("com.lyokone.location.LocationPlugin"));
    LocationPermissionsPlugin.registerWith(registry.registrarFor("com.baseflow.location_permissions.LocationPermissionsPlugin"));
    PackageInfoPlugin.registerWith(registry.registrarFor("io.flutter.plugins.packageinfo.PackageInfoPlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    ShareItPlugin.registerWith(registry.registrarFor("com.illescasDaniel.flutterShareItPlugin.share_it.ShareItPlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    ConnectivityPlugin.registerWith(registry.registrarFor("io.flutter.plugins.connectivity.ConnectivityPlugin"));
    SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
    StatusbarPlugin.registerWith(registry.registrarFor("mo.dyna.statusbar.StatusbarPlugin"));
    UrlLauncherPlugin.registerWith(registry.registrarFor("io.flutter.plugins.urllauncher.UrlLauncherPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
