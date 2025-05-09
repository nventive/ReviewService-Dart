import 'package:review_service/src/review_service/review_settings.dart';

/// Holds the review prompt settings used for prompt conditions.
abstract interface class ReviewSettingsSource<
    TReviewSettings extends ReviewSettings> {
  /// Gets the current [ReviewSettings].
  Future<TReviewSettings> read();

  /// Updates the review prompt settings.
  Future<void> write(TReviewSettings reviewSettings);
}
