import 'package:review_service/src/review_service/review_condition.dart';
import 'package:review_service/src/review_service/review_conditions_builder.extensions.dart';
import 'package:review_service/src/review_service/review_settings.dart';

/// Provide a way to gather the review conditions.
abstract interface class ReviewConditionsBuilder<
    TReviewSettings extends ReviewSettings> {
  /// Gets the review conditions.
  List<ReviewCondition<TReviewSettings>> get conditions;
}

/// Implementation of [ReviewConditionsBuilder].
/// Provides methods to get an empty or default [ReviewConditionsBuilder].
final class ReviewConditionsBuilderImplementation<
        TReviewSettings extends ReviewSettings>
    implements ReviewConditionsBuilder<TReviewSettings> {
  ReviewConditionsBuilderImplementation();

  @override
  List<ReviewCondition<TReviewSettings>> conditions = [];

  static ReviewConditionsBuilder<TReviewSettings>
      empty<TReviewSettings extends ReviewSettings>() {
    return ReviewConditionsBuilderImplementation<TReviewSettings>();
  }

  static ReviewConditionsBuilder<TReviewSettings>
      defaultBuilder<TReviewSettings extends ReviewSettings>() {
    return ReviewConditionsBuilderImplementation<TReviewSettings>()
      .minimumApplicationLaunchCount(3)
      .minimumElapsedTimeSinceApplicationFirstLaunch(const Duration(days: 5))
      .minimumPrimaryActionsCompleted(2)
      .minimumElapsedTimeSinceLastReviewRequest(const Duration(days: 15));
  }
}
