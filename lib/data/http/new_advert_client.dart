import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outsource/data/models/car_dto.dart';
import 'package:outsource/data/models/common_dto.dart';
import 'package:outsource/data/models/weight_dto.dart';
import 'package:outsource/presentation/adverts/models/advert.dart';

class NewAdvertClient {
  final Dio _dio;

  NewAdvertClient(this._dio);

  Future<List<CommonDto>> getRegions() async {
    try {
      final response = await _dio.get('api/common/regions');
      print(response);
      return List<CommonDto>.from(
        response.data["result"].map(
          (x) => CommonDto.fromJson(x),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CommonDto>> getDistrictsById(int regionId) async {
    try {
      final response = await _dio.get('api/common/districts/$regionId');
      print(response);
      return List<CommonDto>.from(
        response.data["result"].map(
          (x) => CommonDto.fromJson(x),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CarDto>> getCarBrands() async {
    try {
      final response = await _dio.get('api/common/cars/brands');
      print(response);
      return List<CarDto>.from(
        response.data["result"].map(
          (x) => CarDto.fromJson(x),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CarDto>> getCarModels(int carBrand) async {
    try {
      final response = await _dio.get('api/common/cars/$carBrand/models');
      print(response);
      return List<CarDto>.from(
        response.data["result"].map(
          (x) => CarDto.fromJson(x),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WeightDto>> getWeights() async {
    try {
      final response = await _dio.get('api/common/adverts/get-weight-list');
      print(response);
      return List<WeightDto>.from(
        response.data["result"].map(
          (x) => WeightDto.fromJson(x),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addAdvert({
    required String title,
    required String fromLat,
    required String fromLong,
    required int fromRegionId,
    required int fromDistrictId,
    required int toRegionId,
    required int toDistrictId,
    required String receiverFullName,
    required String receiverAddress,
    required String receiverPhoneNumber,
    required String comment,
    required List<XFile> image,
    required int weightId,
  }) async {
    final multipartImageList =
        image.map((image) => MultipartFile.fromFileSync(image.path)).toList();
    FormData? formData = FormData.fromMap({'images[]': multipartImageList});

    await _dio.post(
      'api/member/adverts/create',
      queryParameters: {
        "title": title,
        "from_lat": fromLat,
        "from_lng": fromLong,
        "from_region_id": fromRegionId.toString(),
        "from_district_id": fromDistrictId.toString(),
        "to_region_id": toRegionId.toString(),
        "to_district_id": toDistrictId.toString(),
        "receiver_full_name": receiverFullName,
        "receiver_address": receiverAddress,
        "receiver_phone_number": receiverPhoneNumber,
        "comment": comment,
        "weight_id": weightId.toString(),
      },
      data: formData ?? {},
    );
  }

  Future<Advert> getAdvert(int advertId) async {
    try {
      final response = await _dio.get('api/member/adverts/$advertId/get');
      return Advert.fromJson(response.data["result"]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editAdvert({
    required int advertId,
    required String title,
    required String fromLat,
    required String fromLong,
    required int fromRegionId,
    required int fromDistrictId,
    required int toRegionId,
    required int toDistrictId,
    required String receiverFullName,
    required String receiverAddress,
    required String receiverPhoneNumber,
    required String comment,
    required List<XFile> image,
    required int weightId,
  }) async {
    final multipartImageList =
    image.map((image) => MultipartFile.fromFileSync(image.path)).toList();
    FormData? formData = FormData.fromMap({'images[]': multipartImageList});

    await _dio.post(
      'api/member/adverts/$advertId/update',
      queryParameters: {
        "title": title,
        "from_lat": fromLat,
        "from_lng": fromLong,
        "from_region_id": fromRegionId.toString(),
        "from_district_id": fromDistrictId.toString(),
        "to_region_id": toRegionId.toString(),
        "to_district_id": toDistrictId.toString(),
        "receiver_full_name": receiverFullName,
        "receiver_address": receiverAddress,
        "receiver_phone_number": receiverPhoneNumber,
        "comment": comment,
        "weight_id": weightId.toString(),
      },
      data: formData ?? {},
    );
  }
}
