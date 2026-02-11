import 'api_service.dart';

class QRService {
  static Future<Map<String, dynamic>?> checkIn(String qrToken) async {
    try {
      final response = await ApiService.post(
        '/api/mobile/visits/checkin',
        data: {'qr_token': qrToken},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> generateQRCode(String partnerId) async {
    try {
      final response = await ApiService.post(
        '/api/partners/$partnerId/generate-qr',
      );

      if (response.statusCode == 200) {
        return response.data['qr_token'];
      }
      return null;
    } catch (e) {
      print('Error generating QR code: $e');
      return null;
    }
  }

  static Future<bool> validateQRToken(String qrToken) async {
    try {
      final response = await ApiService.post(
        '/api/visits/validate-qr',
        data: {'qr_token': qrToken},
      );

      return response.statusCode == 200 && response.data['valid'] == true;
    } catch (e) {
      print('Error validating QR token: $e');
      return false;
    }
  }
}
