import 'package:logger/logger.dart';
import 'package:review_service/src/review_service/review_condition.dart';
import 'package:review_service/src/review_service/review_condition_builder.dart';
import 'package:review_service/src/review_service/review_prompter.dart';
import 'package:review_service/src/review_service/review_settings.dart';
import 'package:review_service/src/review_service/review_settings_source.dart';

/// Provides ways to validate review prompt conditions using [TReviewSettings] and
/// to prompt user to review the current application using [ReviewPrompter].
abstract interface class ReviewService<TReviewSettings extends ReviewSettings> {
  factory ReviewService({
    required Logger logger,
    required ReviewPrompter reviewPrompter,
    required ReviewSettingsSource<TReviewSettings> reviewSettingsSource,
    required ReviewConditionsBuilder<TReviewSettings> reviewConditionsBuilder,
  }) = _ReviewService;

  /// Checks if all review prompt conditions are satisfied and then prompt user to review the current application.
  Future<void> tryRequestReview();

  /// Gets if all conditions are satisfied which means that we can prompt user to review the current application.
  Future<bool> getAreConditionsSatisfied();

  /// Updates the persisted [TReviewSettings].
  Future<void> updateReviewSettings(
    TReviewSettings Function(TReviewSettings) updateFunction,
  );
}

/// Implementation of [IReviewService].
final class _ReviewService<TReviewSettings extends ReviewSettings>
    implements ReviewService<TReviewSettings> {
  final Logger _logger;
  final ReviewPrompter _reviewPrompter;
  final ReviewSettingsSource<TReviewSettings> _reviewSettingsSource;
  final List<ReviewCondition<TReviewSettings>> _reviewConditions;

  _ReviewService({
    required Logger logger,
    required ReviewPrompter reviewPrompter,
    required ReviewSettingsSource<TReviewSettings> reviewSettingsSource,
    required ReviewConditionsBuilder<TReviewSettings> reviewConditionsBuilder,
  })  : _logger = logger,
        _reviewPrompter = reviewPrompter,
        _reviewSettingsSource = reviewSettingsSource,
        _reviewConditions = reviewConditionsBuilder.conditions;

  /// Tracks that a review was requested.
  Future<void> _trackReviewRequested() async {
    await updateReviewSettings((reviewSettings) {
      return reviewSettings.copyWith(
        lastRequest: DateTime.now(),
        requestCount: reviewSettings.requestCount + 1,
      ) as TReviewSettings;
    });
  }

  @override
  Future<void> tryRequestReview() async {
    _logger.d('Trying to request a review.');

    if (await getAreConditionsSatisfied()) {
      await _reviewPrompter.tryPrompt();
      await _trackReviewRequested();

      _logger.i('Review requested.');
    } else {
      _logger.i(
          'Failed to request a review because one or more conditions were not satisfied.');
    }
  }

  @override
  Future<bool> getAreConditionsSatisfied() async {
    _logger.d('Evaluating conditions.');

    final currentSettings = await _reviewSettingsSource.read();
    final reviewConditionTasks = _reviewConditions.map(
        (condition) => condition.validate(currentSettings, DateTime.now()));
    final result = (await Future.wait(reviewConditionTasks)).every((x) => x);

    if (result) {
      _logger.i('Evaluated conditions and all conditions are satisfied.');
    } else {
      _logger.i(
          'Evaluated conditions and one or more conditions were not satisfied.');
    }

    return result;
  }

  @override
  Future<void> updateReviewSettings(
      TReviewSettings Function(TReviewSettings) updateFunction) async {
    _logger.d('Updating review settings.');

    final currentSettings = await _reviewSettingsSource.read();

    try {
      await _reviewSettingsSource.write(updateFunction(currentSettings));

      _logger.i('Updated review settings.');
    } catch (ex) {
      _logger.e('Failed to update review settings.', error: ex);
    }
  }
}
