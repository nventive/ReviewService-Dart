import 'package:review_service/src/review_service/review_settings.dart';
import 'package:review_service/src/review_service/review_settings_source.dart';

/// In-memory implementation of [ReviewSettingsSource].
final class MemoryReviewSettingsSource<TReviewSettings extends ReviewSettings>
    implements ReviewSettingsSource<TReviewSettings> {
  late TReviewSettings _reviewSettings;

  MemoryReviewSettingsSource(TReviewSettings Function() defaultSettings) {
    _reviewSettings = defaultSettings();
  }

  @override
  Future<TReviewSettings> read() {
    return Future.value(_reviewSettings);
  }

  @override
  Future<void> write(TReviewSettings reviewSettings) {
    _reviewSettings = reviewSettings;

    return Future.value();
  }
}
