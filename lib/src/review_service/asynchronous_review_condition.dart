import 'package:review_service/src/review_service/review_condition.dart';
import 'package:review_service/src/review_service/review_settings.dart';

/// Asynchronous implementation of [ReviewCondition].
class AsynchronousReviewCondition<TReviewSettings extends ReviewSettings>
    implements ReviewCondition<TReviewSettings> {
  final Future<bool> Function(TReviewSettings, DateTime) _condition;

  AsynchronousReviewCondition(this._condition);

  @override
  Future<bool> validate(
      TReviewSettings currentSettings, DateTime currentDateTime) {
    return _condition(currentSettings, currentDateTime);
  }
}
