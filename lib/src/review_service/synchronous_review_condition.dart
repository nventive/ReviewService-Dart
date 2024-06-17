import 'package:review_service/src/review_service/review_condition.dart';
import 'package:review_service/src/review_service/review_settings.dart';

/// Synchronous implementation of [ReviewCondition].
class SynchronousReviewCondition<TReviewSettings extends ReviewSettings>
    implements ReviewCondition<TReviewSettings> {
  final bool Function(TReviewSettings, DateTime) _condition;

  SynchronousReviewCondition(this._condition);

  @override
  Future<bool> validate(TReviewSettings currentSettings, DateTime currentDateTime) {
    return Future.value(_condition(currentSettings, currentDateTime));
  }
}
