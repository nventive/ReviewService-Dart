import 'package:review_service/src/review_service/review_settings.dart';

/// A condition used to determine if a review should be requested based on [ReviewSettings].
abstract interface class ReviewCondition<
    TReviewSettings extends ReviewSettings> {
  /// Validates that the condition is satisfied.
  Future<bool> validate(
    TReviewSettings currentSettings,
    DateTime currentDateTime,
  );
}
