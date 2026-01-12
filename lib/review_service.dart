/// A Dart package for managing in-app review prompts with configurable conditions.
///
/// This package provides abstractions around native review capabilities to ease code sharing and testability.
/// It includes business logic to quickly configure conditions and state tracking to prompt for reviews at the right moment.
library;

export 'src/review_service/asynchronous_review_condition.dart';
export 'src/review_service/logging_review_prompter.dart';
export 'src/review_service/memory_review_settings_source.dart';
export 'src/review_service/review_condition.dart';
export 'src/review_service/review_condition_builder.dart';
export 'src/review_service/review_conditions_builder.extensions.dart';
export 'src/review_service/review_prompter.dart';
export 'src/review_service/review_service.dart';
export 'src/review_service/review_service.extensions.dart';
export 'src/review_service/review_settings.dart';
export 'src/review_service/review_settings_source.dart';
export 'src/review_service/synchronous_review_condition.dart';
