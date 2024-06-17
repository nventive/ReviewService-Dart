import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:review_service/src/review_service/logging_review_prompter.dart';
import 'package:review_service/src/review_service/memory_review_settings_source.dart';
import 'package:review_service/src/review_service/review_condition_builder.dart';
import 'package:review_service/src/review_service/review_conditions_builder.extensions.dart';
import 'package:review_service/src/review_service/review_service.dart';
import 'package:review_service/src/review_service/review_service.extensions.dart';
import 'package:review_service/src/review_service/review_settings.dart';

void main() {
  test(
      'MemoryReviewSettingSource should not return null when reading from a new instance',
      () async {
    // Arrange
    var source = MemoryReviewSettingsSource<ReviewSettings>(() => ReviewSettings());

    // Act
    var result = await source.read();

    // Assert
    expect(result, isNotNull);
  });
  test(
      'MemoryReviewSettingSource should return the same value that was written when reading',
      () async {
    // Arrange
    var source = MemoryReviewSettingsSource<ReviewSettings>(() => ReviewSettings());
    var value = ReviewSettings(requestCount: 10);

    await source.write(value);

    // Act
    var result = await source.read();

    // Assert
    expect(result, value);
  });

    test(
      'MemoryReviewSettingsSource should retain updated value from CustomReviewSetings when tracking application launched',
      () async {
    // Arrange
    var source = MemoryReviewSettingsSource<CustomReviewSettings>(() => CustomReviewSettings());

    var reviewConditionBuilder = ReviewConditionsBuilderImplementation<CustomReviewSettings>().minimumApplicationLaunchCount(1);

    var reviewService = ReviewService<CustomReviewSettings>(
      logger: Logger(),
      reviewSettingsSource: source,
      reviewConditionsBuilder: reviewConditionBuilder,
      reviewPrompter: LoggingReviewPrompter()
    );

    // Act
    await reviewService.updateReviewSettings((reviewSettings) {
      return reviewSettings
          .copyWithFavorite(reviewSettings.favoriteJokesCount + 1);
    });

    await reviewService.trackApplicationLaunched();
    var result = await source.read();

    // Assert
    expect(result.favoriteJokesCount, 1);
    expect(result.applicationLaunchCount, 1);
  });
}


class CustomReviewSettings extends ReviewSettings {
  final int favoriteJokesCount;

  const CustomReviewSettings({
    this.favoriteJokesCount = 0,
    super.primaryActionCompletedCount = 0,
    super.secondaryActionCompletedCount = 0,
    super.applicationLaunchCount = 0,
    super.firstApplicationLaunch,
    super.requestCount = 0,
    super.lastRequest,
  });

  @override
  CustomReviewSettings copyWith({
    int? primaryActionCompletedCount,
    int? secondaryActionCompletedCount,
    int? applicationLaunchCount,
    DateTime? firstApplicationLaunch,
    int? requestCount,
    DateTime? lastRequest,
  }) {
    return CustomReviewSettings(
      primaryActionCompletedCount:
          primaryActionCompletedCount ?? this.primaryActionCompletedCount,
      secondaryActionCompletedCount:
          secondaryActionCompletedCount ?? this.secondaryActionCompletedCount,
      applicationLaunchCount:
          applicationLaunchCount ?? this.applicationLaunchCount,
      firstApplicationLaunch:
          firstApplicationLaunch ?? this.firstApplicationLaunch,
      requestCount: requestCount ?? this.requestCount,
      lastRequest: lastRequest ?? this.lastRequest,
      favoriteJokesCount: favoriteJokesCount,
    );
  }

  CustomReviewSettings copyWithFavorite(int favoriteCount) {
    return CustomReviewSettings(
      primaryActionCompletedCount: super.primaryActionCompletedCount,
      secondaryActionCompletedCount: super.secondaryActionCompletedCount,
      applicationLaunchCount: super.applicationLaunchCount,
      firstApplicationLaunch: super.firstApplicationLaunch,
      requestCount: super.requestCount,
      lastRequest: super.lastRequest,
      favoriteJokesCount: favoriteCount,
    );
  }
}
