import 'package:in_app_review/in_app_review.dart';
import 'package:logger/logger.dart';

/// Provides ways to prompt user to review the current application.
abstract interface class ReviewPrompter {
  factory ReviewPrompter({
    required Logger logger,
  }) = _ReviewPrompter;

  /// Prompts the user to rate the current application using the platform's default application store.
  Future<void> tryPrompt();
}

/// Implementation of [ReviewPrompter].
final class _ReviewPrompter implements ReviewPrompter {
  final Logger _logger;

  _ReviewPrompter({
    required Logger logger,
  }) : _logger = logger;

  @override
  Future<void> tryPrompt() async {
    _logger.d('Trying to prompt user to review the current application.');

    if (await InAppReview.instance.isAvailable()) {
      InAppReview.instance.requestReview();

      _logger.i('Prompted user to review the current application.');
    } else {
      _logger.i(
          'Failed to prompt user to review the current application because the platform does not support it.');
    }
  }
}
