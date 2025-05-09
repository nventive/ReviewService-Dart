import 'package:logger/logger.dart';
import 'package:review_service/src/review_service/logging_review_prompter.dart';
import 'package:review_service/src/review_service/memory_review_settings_source.dart';
import 'package:review_service/src/review_service/review_condition_builder.dart';
import 'package:review_service/src/review_service/review_conditions_builder.extensions.dart';
import 'package:review_service/src/review_service/review_service.dart';
import 'package:review_service/src/review_service/review_service.extensions.dart';
import 'package:review_service/src/review_service/review_settings.dart';

void main() async {
  // Create a logger instance
  var logger = Logger();

  // Create a review conditions builder with default conditions
  var reviewConditionsBuilder =
      ReviewConditionsBuilderImplementation<ReviewSettings>()
          .minimumApplicationLaunchCount(3)
          .minimumPrimaryActionsCompleted(2);

  // Create an in-memory review settings source
  var reviewSettingsSource = MemoryReviewSettingsSource<ReviewSettings>(
    () => const ReviewSettings(),
  );

  // Create a review prompter
  var reviewPrompter = LoggingReviewPrompter(logger: logger);

  // Create the review service
  var reviewService = ReviewService<ReviewSettings>(
    logger: logger,
    reviewPrompter: reviewPrompter,
    reviewSettingsSource: reviewSettingsSource,
    reviewConditionsBuilder: reviewConditionsBuilder,
  );

  // Simulate tracking application events
  await reviewService.trackApplicationLaunched();
  await reviewService.trackPrimaryActionCompleted();

  // Try to request a review
  await reviewService.tryRequestReview();
}
