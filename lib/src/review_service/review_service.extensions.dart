import 'package:review_service/src/review_service/review_service.dart';
import 'package:review_service/src/review_service/review_settings.dart';

/// Extensions of [IReviewService].
extension ReviewServiceExtensions<TReviewSettings extends ReviewSettings>
    on ReviewService<TReviewSettings> {
  /// Tracks that the application was launched.
  Future<void> trackApplicationLaunched() async {
    await updateReviewSettings((reviewSettings) {
      return reviewSettings.firstApplicationLaunch == null
          ? reviewSettings.copyWith(
              firstApplicationLaunch: DateTime.now(),
              applicationLaunchCount: reviewSettings.applicationLaunchCount + 1,
            ) as TReviewSettings
          : reviewSettings.copyWith(
              applicationLaunchCount: reviewSettings.applicationLaunchCount + 1,
            ) as TReviewSettings;
    });
  }

  /// Tracks that a primary action was completed.
  Future<void> trackPrimaryActionCompleted() async {
    await updateReviewSettings(
      (reviewSettings) => reviewSettings.copyWith(
              primaryActionCompletedCount:
                  reviewSettings.primaryActionCompletedCount + 1)
          as TReviewSettings,
    );
  }

  /// Tracks that a secondary action was completed.
  Future<void> trackSecondaryActionCompleted() async {
    await updateReviewSettings(
      (reviewSettings) => reviewSettings.copyWith(
              secondaryActionCompletedCount:
                  reviewSettings.secondaryActionCompletedCount + 1)
          as TReviewSettings,
    );
  }
}
