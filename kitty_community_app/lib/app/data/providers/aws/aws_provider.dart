import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kitty_community_app/app/core/errors/failures.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/core/values/languages/key_language.dart';

class AWSProvider {
  static Future<Either<Failure, String?>> predictImage(String imagePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://13.212.26.185/predict'),
    );
    var file = await http.MultipartFile.fromPath(
      'file',
      imagePath
    );
    request.files.add(file);

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(body);
        logger.d(jsonResponse);
        return Right("abc");
      } else {
        return Left(ServerFailureWithMessage(
            message:
                'Failed to upload image. Status code: ${response.statusCode}'));
        // Handle failure
      }
    } catch (error) {
      print('Error uploading image: $error');
      // Handle error
      return Left(ServerFailureWithMessage(message: KeyLanguage.c500.tr));
    }
  }
}
