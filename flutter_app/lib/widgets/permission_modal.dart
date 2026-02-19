import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../l10n/language_provider.dart';
import '../config/app_theme.dart';

/// LOCATION PERMISSION FLOW (uses Geolocator — correctly maps iOS states):
///
/// iOS states via Geolocator:
///   whileInUse / always  → already granted
///   deniedForever        → permanently denied (must go to Settings)
///   denied               → notDetermined on iOS (first time) OR user denied once
///                          Calling requestPermission() on notDetermined → shows native dialog
///                          Calling requestPermission() on denied → silently returns denied
///
/// Flow:
///   1. granted           → return true (skip everything)
///   2. deniedForever     → Settings modal (no UI modal)
///   3. denied            → show UI modal → user taps Allow → call requestPermission()
///                          → if native dialog appears and user allows: granted ✓
///                          → if user already denied before (no dialog): show Settings modal
Future<bool> showLocationPermissionModal(BuildContext context) async {
  final current = await Geolocator.checkPermission();

  // Already granted
  if (current == LocationPermission.whileInUse ||
      current == LocationPermission.always) {
    return true;
  }

  // Permanently denied — must go to Settings
  if (current == LocationPermission.deniedForever) {
    if (context.mounted) await _showSettingsModal(context, isCamera: false);
    return false;
  }

  // Show our custom UI modal first (covers both notDetermined and denied states)
  if (!context.mounted) return false;
  final agreed = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (_) => _PermissionModal(isCamera: false),
  );

  if (agreed != true) return false;

  // Wait for Flutter dialog dismiss animation to fully complete
  // so the native iOS dialog appears cleanly on top
  await Future.delayed(const Duration(milliseconds: 800));
  if (!context.mounted) return false;

  // Request native permission — on first launch iOS shows the native dialog
  final result = await Geolocator.requestPermission();

  if (result == LocationPermission.whileInUse ||
      result == LocationPermission.always) {
    return true;
  }

  // User denied or already denied before (no native dialog shown) → Settings
  if (context.mounted) await _showSettingsModal(context, isCamera: false);
  return false;
}

/// CAMERA PERMISSION FLOW:
/// 1. Already granted → return true immediately
/// 2. Permanently denied → show Settings modal
/// 3. First time / denied → show UI modal → user taps Allow → native iOS dialog
Future<bool> showCameraPermissionModal(BuildContext context) async {
  // Check current status
  final current = await Permission.camera.status;

  // Already granted — skip everything
  if (current.isGranted) return true;

  // Permanently denied — must go to Settings
  if (current.isPermanentlyDenied) {
    if (context.mounted) await _showSettingsModal(context, isCamera: true);
    return false;
  }

  // Show our custom UI modal (useRootNavigator so it appears above everything)
  if (!context.mounted) return false;
  final agreed = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (_) => _PermissionModal(isCamera: true),
  );

  if (agreed != true) return false;

  // Wait for dialog animation to fully complete
  await Future.delayed(const Duration(milliseconds: 600));
  if (!context.mounted) return false;

  // Trigger native iOS/Android camera permission dialog
  final result = await Permission.camera.request();

  if (result.isGranted) return true;

  // iOS denied or permanently denied — show Settings modal
  if (context.mounted) await _showSettingsModal(context, isCamera: true);
  return false;
}

Future<void> _showSettingsModal(BuildContext context,
    {required bool isCamera}) async {
  await showDialog(
    context: context,
    builder: (_) => _PermissionSettingsModal(isCamera: isCamera),
  );
}

// ─── Custom permission modal ─────────────────────────────────────────────────

class _PermissionModal extends StatelessWidget {
  final bool isCamera;
  const _PermissionModal({required this.isCamera});

  @override
  Widget build(BuildContext context) {
    final titleKey =
        isCamera ? 'camera_permission_title' : 'location_permission_title';
    final descKey =
        isCamera ? 'camera_permission_desc' : 'location_permission_desc';
    final allowKey =
        isCamera ? 'camera_permission_allow' : 'location_permission_allow';
    final denyKey =
        isCamera ? 'camera_permission_deny' : 'location_permission_deny';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryCyan.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCamera ? Icons.camera_alt_rounded : Icons.location_on_rounded,
                size: 40,
                color: AppTheme.primaryCyan,
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              context.tr(titleKey),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                fontFamily: 'Mulish',
                color: Color(0xFF0A0C13),
              ),
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              context.tr(descKey),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Mulish',
                color: Color(0xFF8F96A0),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            // Allow button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryCyan,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  context.tr(allowKey),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Mulish',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Deny button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF8F96A0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  context.tr(denyKey),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Mulish',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Settings redirect modal (permission permanently denied) ─────────────────

class _PermissionSettingsModal extends StatelessWidget {
  final bool isCamera;
  const _PermissionSettingsModal({required this.isCamera});

  @override
  Widget build(BuildContext context) {
    final titleKey =
        isCamera ? 'camera_permission_title' : 'location_permission_title';
    final descKey =
        isCamera ? 'camera_permission_desc' : 'location_permission_desc';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCamera ? Icons.camera_alt_rounded : Icons.location_off_rounded,
                size: 40,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.tr(titleKey),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                fontFamily: 'Mulish',
                color: Color(0xFF0A0C13),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.tr(descKey),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Mulish',
                color: Color(0xFF8F96A0),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await openAppSettings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  context.tr('open_settings'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Mulish',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF8F96A0),
                ),
                child: Text(
                  context.tr('not_now'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'Mulish',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
