import 'package:uuid/uuid.dart';

class UniqueId {
  UniqueId._(this.value);
  final String value;
  factory UniqueId() {
    return UniqueId._(const Uuid().v4());
  }

  factory UniqueId.fromUniqueString(String uniqueString) {
    return UniqueId._(uniqueString);
  }
}

class PredictionId extends UniqueId {
  @override
  final String value;

  PredictionId._({required this.value}) : super._(value);

  factory PredictionId() => PredictionId._(value: const Uuid().v4());

  factory PredictionId.fromUniqueString(String uniqueString) {
    return PredictionId._(value: uniqueString);
  }
}
