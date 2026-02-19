import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../l10n/language_provider.dart';
import '../config/app_theme.dart';

class PermissionHelper {
  /// Show custom pre-permission dialog before requesting camera permission
  static Future<bool> requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      _showSettingsDialog(context, 'permission_camera_title', 'permission_camera_denied');
      return false;
    }

    // Show custom dialog first
    final shouldRequest = await _showPrePermissionDialog(
      context,
      icon: Icons.camera_alt,
      iconColor: AppTheme.primaryCyan,
      title: 'permission_camera_title',
      description: 'permission_camera_desc',
    );

    if (!shouldRequest) return false;

    final result = await Permission.camera.request();
    return result.isGranted;
  }

  /// Show custom pre-permission dialog before requesting location permission
  static Future<bool> requestLocationPermission(BuildContext context) async {
    final current = await Geolocator.checkPermission();
    if (current == LocationPermission.whileInUse ||
        current == LocationPermission.always) return true;
    if (current == LocationPermission.deniedForever) {
      _showSettingsDialog(context, 'permission_location_title', 'permission_location_denied');
      return false;
    }

    // Show custom dialog first
    final shouldRequest = await _showPrePermissionDialog(
      context,
      icon: Icons.location_on,
      iconColor: AppTheme.primaryCyan,
      title: 'permission_location_title',
      description: 'permission_location_desc',
    );

    if (!shouldRequest) return false;

    // Wait for dialog to close before native dialog appears
    await Future.delayed(const Duration(milliseconds: 800));

    final result = await Geolocator.requestPermission();
    return result == LocationPermission.whileInUse ||
        result == LocationPermission.always;
  }

  /// Show custom pre-permission dialog before requesting photo library permission
  static Future<bool> requestPhotoPermission(BuildContext context) async {
    final status = await Permission.photos.status;
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      _showSettingsDialog(context, 'permission_photos_title', 'permission_photos_denied');
      return false;
    }

    // Show custom dialog first
    final shouldRequest = await _showPrePermissionDialog(
      context,
      icon: Icons.photo_library,
      iconColor: AppTheme.primaryCyan,
      title: 'permission_photos_title',
      description: 'permission_photos_desc',
    );

    if (!shouldRequest) return false;

    final result = await Permission.photos.request();
    return result.isGranted;
  }

  /// Show localized pre-permission dialog
  static Future<bool> _showPrePermissionDialog(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36, color: iconColor),
              ),
              const SizedBox(height: 20),
              Text(
                ctx.tr(title),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Mulish',
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                ctx.tr(description),
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Mulish',
                  color: Color(0xFF666666),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryCyan,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    ctx.tr('permission_allow'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF666666),
                    side: const BorderSide(color: Color(0xFFE0E0E0)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    ctx.tr('permission_deny'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Mulish'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return result ?? false;
  }

  /// Show settings dialog when permission is permanently denied
  static Future<void> _showSettingsDialog(
    BuildContext context,
    String titleKey,
    String descKey,
  ) async {
    await showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.settings, size: 36, color: Colors.orange),
              ),
              const SizedBox(height: 20),
              Text(
                ctx.tr(titleKey),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Mulish',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                ctx.tr(descKey),
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Mulish',
                  color: Color(0xFF666666),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    openAppSettings();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryCyan,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    ctx.tr('permission_open_settings'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  ctx.tr('cancel'),
                  style: const TextStyle(color: Color(0xFF666666), fontFamily: 'Mulish'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
