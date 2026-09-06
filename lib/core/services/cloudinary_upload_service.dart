import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../constants/api_constants.dart';

class CloudinaryUploadResult {
  final String secureUrl;
  final String publicId;
  final String? format;
  final int? width;
  final int? height;
  final bool isMock;

const CloudinaryUploadResult({
    required this.secureUrl,
 required this.publicId,
 this.format,
 this.width,
 this.height,
 this.isMock = false,
  });

factory CloudinaryUploadResult.fromJson(Map<String, dynamic> json) {
    return CloudinaryUploadResult(
      secureUrl: json['secure_url'] as String? ?? '',
publicId: json['public_id'] as String? ?? '',
format: json['format'] as String?,
width: json['width'] as int?,
height: json['height'] as int?,
isMock: json['isMock'] as bool? ?? false,
    );
  }
}

class CloudinaryUploadService {
  CloudinaryUploadService._();
static final CloudinaryUploadService instance = CloudinaryUploadService._();

  /// Maximum file size: 25 MB
static const int maxFileSizeBytes = 25 * 1024 * 1024;

  /// Probes candidate hosts with a fast check to find the working backend IP
  Future<String> resolveWorkingBaseUrl() async {
    try {
      final current = ApiConstants.baseUrl;
      final res = await http
.get(Uri.parse('$current/health'))
.timeout(const Duration(milliseconds: 1500));
if (res.statusCode == 200) {
        ApiConstants.setWorkingHost(current);
        return current;
      }
    } catch (_) {}

    for (final host in ApiConstants.candidateHosts) {
      try {
        final res = await http
.get(Uri.parse('$host/health'))
.timeout(const Duration(milliseconds: 1500));
if (res.statusCode == 200) {
          ApiConstants.setWorkingHost(host);
          debugPrint('✅ Found working backend at: $host');
          return host;
        }
      } catch (_) {}
    }

    return ApiConstants.baseUrl;
  }

  /// Uploads an event image/banner to Cloudinary folder 'techculture/events'
  Future<CloudinaryUploadResult> uploadEventImage(
    XFile file, {
    String? oldPublicId,
  }) async {
    await resolveWorkingBaseUrl();
    return _uploadFile(
      endpointUrl: ApiConstants.uploadEventImageUrl,
file: file,
oldPublicId: oldPublicId,
    );
  }

  /// Uploads a user profile image to Cloudinary folder 'techculture/profiles'
  Future<CloudinaryUploadResult> uploadProfileImage(
    XFile file, {
    String? oldPublicId,
  }) async {
    await resolveWorkingBaseUrl();
    return _uploadFile(
      endpointUrl: ApiConstants.uploadProfileImageUrl,
file: file,
oldPublicId: oldPublicId,
    );
  }

  /// Deletes an image from Cloudinary by its publicId
  Future<bool> deleteImage(String publicId) async {
    try {
      await resolveWorkingBaseUrl();
      final response = await http.post(
        Uri.parse(ApiConstants.deleteImageUrl),
headers: {'Content-Type': 'application/json'},
body: jsonEncode({'public_id': publicId}),
      ).timeout(const Duration(seconds: 15));

if (response.statusCode == 200) {
        return true;
      }
      debugPrint('Cloudinary deletion failed: ${response.body}');
      return false;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }

  /// Internal multipart upload method
  Future<CloudinaryUploadResult> _uploadFile({
    required String endpointUrl,
 required XFile file,
 String? oldPublicId,
  }) async {
    final bytes = await file.readAsBytes();

if (bytes.length > maxFileSizeBytes) {
      throw Exception('Image size exceeds 25MB limit. Please choose a smaller image.');
    }

    final request = http.MultipartRequest('POST', Uri.parse(endpointUrl));

    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
bytes,
filename: file.name.isNotEmpty ? file.name : 'upload.jpg',
      ),
    );

if (oldPublicId != null && oldPublicId.isNotEmpty) {
      request.fields['old_public_id'] = oldPublicId;
    }

    try {
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );

      final response = await http.Response.fromStream(streamedResponse);

if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
if (data['success'] == true && data['secure_url'] != null) {
          return CloudinaryUploadResult.fromJson(data);
        }
        throw Exception(data['error'] ?? 'Upload failed with unknown server response.');
      }

      final errorBody = jsonDecode(response.body);
      throw Exception(
        errorBody['error'] ?? 'Upload failed with status ${response.statusCode}',
      );
    } catch (e) {
      debugPrint('Cloudinary upload error: $e');
if (e.toString().contains('TimeoutException') || e.toString().contains('SocketException')) {
        throw Exception(
          'Cannot reach backend (${ApiConstants.baseUrl}). Make sure your phone and PC are on the same Wi-Fi and backend is running.',
        );
      }
      rethrow;
    }
  }
}
