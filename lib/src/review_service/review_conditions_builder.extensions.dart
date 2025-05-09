import 'package:review_service/src/review_service/asynchronous_review_condition.dart';
import 'package:review_service/src/review_service/review_condition_builder.dart';
import 'package:review_service/src/review_service/review_settings.dart';
import 'package:review_service/src/review_service/synchronous_review_condition.dart';

/// Extensions for [ReviewConditionsBuilder].
extension ReviewConditionBuilderExtensions<
        TReviewSettings extends ReviewSettings>
    on ReviewConditionsBuilder<TReviewSettings> {
  /// The number of completed primary actions must be greater than the review settings.
  ReviewConditionsBuilder<TReviewSettings> minimumPrimaryActionsCompleted(
      int minimumActionCompleted) {
    conditions.add(SynchronousReviewCondition<TReviewSettings>(
      (reviewSettings, currentDateTime) =>
          reviewSettings.primaryActionCompletedCount >= minimumActionCompleted,
    ));
    return this;
  }

  /// The number of completed secondary actions must be greater than the review settings.
  ReviewConditionsBuilder<TReviewSettings> minimumSecondaryActionsCompleted(
      int minimumActionCompleted) {
    conditions.add(SynchronousReviewCondition<TReviewSettings>(
      (reviewSettings, currentDateTime) =>
          reviewSettings.secondaryActionCompletedCount >=
          minimumActionCompleted,
    ));
    return this;
  }

  /// The number of times the application has been launched must be greater than the review settings.
  ReviewConditionsBuilder<TReviewSettings> minimumApplicationLaunchCount(
      int minimumCount) {
    conditions.add(SynchronousReviewCondition<TReviewSettings>(
      (reviewSettings, currentDateTime) =>
          reviewSettings.applicationLaunchCount >= minimumCount,
    ));
    return this;
  }

  /// The elapsed time since the first application launch must be greater than the review settings.
  ReviewConditionsBuilder<TReviewSettings>
      minimumElapsedTimeSinceApplicationFirstLaunch(
          Duration minimumTimeElapsed) {
    conditions.add(SynchronousReviewCondition<TReviewSettings>(
      (reviewSettings, currentDateTime) =>
          reviewSettings.firstApplicationLaunch != null &&
          reviewSettings.firstApplicationLaunch!
              .add(minimumTimeElapsed)
              .isBefore(currentDateTime),
    ));
    return this;
  }

  /// The time elapsed since the last review requested must be greater than the review settings.
  ReviewConditionsBuilder<TReviewSettings>
      minimumElapsedTimeSinceLastReviewRequest(Duration minimumTimeElapsed) {
    conditions.add(SynchronousReviewCondition<TReviewSettings>(
      (reviewSettings, currentDateTime) =>
          reviewSettings.lastRequest == null ||
          reviewSettings.lastRequest!
              .add(minimumTimeElapsed)
              .isBefore(currentDateTime),
    ));
    return this;
  }

  /// Adds a custom synchronous condition.
  ReviewConditionsBuilder<TReviewSettings> custom(
      bool Function(TReviewSettings, DateTime) condition) {
    conditions.add(SynchronousReviewCondition<TReviewSettings>(condition));
    return this;
  }

  /// Adds a custom asynchronous condition.
  ReviewConditionsBuilder<TReviewSettings> customAsync(
      Future<bool> Function(TReviewSettings, DateTime) condition) {
    conditions.add(AsynchronousReviewCondition<TReviewSettings>(condition));
    return this;
  }
}
