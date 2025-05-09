import 'package:logger/logger.dart';
import 'package:review_service/src/review_service/review_prompter.dart';

/// Implementation of [ReviewPrompter] that logs information.
final class LoggingReviewPrompter implements ReviewPrompter {
  final Logger logger;

  /// Initializes a new instance of the cref="LoggingReviewPrompter" class.
  LoggingReviewPrompter({Logger? logger}) : logger = logger ?? Logger();

  @override
  Future<void> tryPrompt() async {
    logger.i('TryPrompt was invoked.');
  }
}
