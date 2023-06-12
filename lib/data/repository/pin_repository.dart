import 'package:outsource/data/repository/shared_preference_data.dart';

class PinRepository  {
  final SharedPreferenceData spData;

  static PinRepository? _instance;

  factory PinRepository.getInstance() => _instance ??=
      PinRepository._internal(SharedPreferenceData.getInstance());

  PinRepository._internal(this.spData);

  Future<String?> getPin() => spData.getPin();

  Future<bool> savePin(String? item) => spData.setPin(item);
}
